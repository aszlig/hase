/* Copyright (C) 2017 aszlig
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */
package hase.utils;

#if macro
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.ExprTools;
import haxe.macro.MacroStringTools;
#end

import hase.display.Box;
import hase.display.Text;

@:keep
class PreloaderSteps
{
    public static var loaders:Array<Void -> Void> = new Array();
    public static var results:Array<Null<Dynamic>> = new Array();
    public static var descriptions:Array<String> = new Array();
}

class Preloader extends hase.display.Sprite
{
    #if macro
    private static var loaders:Array<Expr> = new Array();
    private static var results:Array<Expr> = new Array();
    private static var descriptions:Array<Expr> = new Array();
    private static var previous:String = "PreloaderSteps";
    private static var current:String = "PreloaderSteps";
    private static var step_idx:Int = 0;
    private static var fullcls:Null<Expr> = null;
    #end

    private var preload_idx:Int;
    private var step_cls:Class<Dynamic>;
    private var steps:Int;

    public var done(default, null):Bool;
    public var progress_bar:ProgressBar;
    public var description:Text;

    public var current_desc(default, null):Null<String>;

    public function new()
    {
        super();
        this.preload_idx = 0;

        this.progress_bar = new ProgressBar();
        this.progress_bar.height = 3;
        this.add_child(progress_bar);

        this.description = new Text("Loading...");
        this.add_child(this.description);

        this.step_cls = Type.resolveClass("hase.utils.PreloaderSteps");
        this.steps = Reflect.field(this.step_cls, "loaders").length;
        this.done = this.steps == 0;

        this.realign();
    }

    private function realign():Void
    {
        this.progress_bar.width = Std.int(
            Math.max(Math.min(this.width - 4, 100), 10)
        );
        this.progress_bar.x = Std.int(
            (this.width - this.progress_bar.width) / 2
        );
        var ybase:Int = Std.int((this.height - 4) / 2);
        this.progress_bar.y = ybase + 1;

        this.description.x = this.progress_bar.x;
        this.description.y = ybase;
    }

    public override function update(td:Float):Void
    {
        this.realign();

        if (!this.done) {
            Reflect.field(this.step_cls, "loaders")[this.preload_idx]();

            hase.utils.PreloaderProxy.results.push(
                Reflect.field(this.step_cls, "results")[this.preload_idx]
            );

            var desc:String = Reflect.field(
                this.step_cls, "descriptions"
            )[this.preload_idx];

            this.description.text = "Loading " + desc + "...";

            this.progress_bar.progress =
                ++this.preload_idx / this.steps * 100.0;

            if (this.preload_idx >= this.steps)
                this.done = true;
        }
        super.update(td);
    }

    #if macro
    private static function replace_cls():Void
    {
        var clsname:String =
            'PreloaderSteps_${Std.string(Preloader.step_idx++)}';
        Preloader.current = clsname;

        var ps:TypeDefinition = macro class $clsname {
            public static var loaders:Array<Void -> Void> =
                $a{Preloader.loaders};
            public static var results:Array<Null<Dynamic>> =
                $a{Preloader.results};
            public static var descriptions:Array<String> =
                $a{Preloader.descriptions};
        };

        ps.pack = ["hase", "utils"];

        ps.meta.push({name: ":keep", pos: Context.currentPos()});
        ps.meta.push({
            name: ":native",
            params: [macro "hase.utils.PreloaderSteps"],
            pos: Context.currentPos()
        });

        Context.defineType(ps);
        haxe.macro.Compiler.exclude("hase.utils." + Preloader.previous);
        Preloader.previous = Preloader.current;
    }

    private static function wrap_expr(expr:Expr):Expr
    {
        var module_str:String = Context.getLocalModule();
        var module:Array<String> = module_str.split(".");
        var pack:Array<String> = module.slice(0, module.length - 1);

        var clsname:String = 'WrappedStep${Preloader.results.length}';

        var wrapped:Expr = switch (expr.expr) {
            case EBlock(content): macro (function() $b{content})();
            default: expr;
        }

        var cls:TypeDefinition = macro class $clsname {
            public static function load() return $e{wrapped};
        };

        var imports:Array<ImportExpr> = Context.getLocalImports();
        imports.push({
            path: [for (name in module) {
                pos: Context.currentPos(),
                name: name
            }],
            mode: INormal
        });

        var modname:String = '__internal.wrapped_preloader.${clsname}';

        Context.defineModule(modname, [cls], imports);

        var field_expr:Expr = MacroStringTools.toFieldExpr(modname.split("."));

        return macro $e{field_expr}.load();
    }
    #end

    macro private static function get_cls():Expr
    {
        if (Preloader.current == "PreloaderSteps")
            Preloader.replace_cls();
        var foo = MacroStringTools.toFieldExpr([
            "hase", "utils", Preloader.current
        ]);
        return macro $e{foo};
    }

    macro public static function preload(name:String, expr:Expr):Expr
    {
        var idx:Int = Preloader.results.length;

        var wrapped = Preloader.wrap_expr(expr);

        Preloader.loaders.push(macro function():Void {
            Reflect.field(
                Type.resolveClass("hase.utils.PreloaderSteps"), "results"
            )[$v{idx}] = $e{wrapped};
        });
        Preloader.results.push(macro null);
        Preloader.descriptions.push(macro $v{name});

        Preloader.replace_cls();

        return macro hase.utils.PreloaderProxy.results[$v{idx}];
    }
}
