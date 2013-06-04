/* Copyright (C) 2013 aszlig
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

import haxe.macro.Expr;
import haxe.macro.Type;
import haxe.macro.Context;

using haxe.macro.ExprTools;

class AppBuilder
{
    private var target:String;
    private var type:Type;
    private var fields:Array<Field>;

    public function new(target:String, type:Type, fields:Array<Field>)
    {
        this.target = target;
        this.type = type;
        this.fields = fields;
    }

    private function create_statics():Array<Field>
    {
        var baseclass:ComplexType = Context.toComplexType(this.type);

        var path:TypePath = switch (baseclass) {
            case TPath(p): p;
            default: throw "Cannot find path to base class!";
        }

        var newbase:Expr = {
            expr: ENew(path, [macro term]),
            pos: Context.currentPos(),
        };

        var complex_statics:ComplexType = switch (this.target) {
            case "js": macro : {
                public inline static function
                    from_canvas(canvas:js.html.CanvasElement):$baseclass
                {
                    var term:hase.term.Canvas = new hase.term.Canvas(canvas);
                    return $e{newbase};
                }

                public static function main():Void
                {
                    js.Browser.window.onload = function(_) {
                        var canvas:js.html.CanvasElement =
                            js.Browser.document.createCanvasElement();

                        canvas.style.position = "fixed";
                        canvas.style.top = "0";
                        canvas.style.left = "0";
                        canvas.width = js.Browser.window.innerWidth;
                        canvas.height = js.Browser.window.innerHeight;

                        var app = from_canvas(canvas);

                        js.Browser.document.body.appendChild(canvas);

                        app.run();
                    };
                }
            };
            case "cpp": macro : {
                public static function main():Void
                {
                    var term:hase.term.Curses = new hase.term.Curses();
                    $e{newbase}.run();
                }
            };
            default: throw "Unknown target " + this.target + ".";
        };

        return switch (complex_statics) {
            case TAnonymous(statics): statics;
            default: throw "Cannot create Application static methods.";
        }
    }

    private inline function create_basefields():Array<Field>
    {
        var complex_fields:ComplexType = macro : {
            private var root:hase.display.Surface;

            public function new(term:hase.term.Interface)
            {
                this.root = new hase.display.Surface(term);
                this.init();
            }

            public inline function run():Void
            {
                var timer = new hase.Timer(this.root);
                timer.on_tick = this.update;
                timer.start();
            }

        };

        return switch (complex_fields) {
            case TAnonymous(fields): fields.concat(this.create_statics());
            default: throw "Cannot create Application base methods.";
        }
    }

    public function build_application():Array<Field>
    {
        var basefields:Array<Field> = this.create_basefields();

        for (field in basefields) {
            var field_exists = function(f:Field):Bool {
                return f.name == field.name;
            };

            if (Lambda.exists(this.fields, field_exists))
                throw "Field " + field.name + " already exists in "
                    + "Application base class!";

            this.fields.push(field);
        }

        return this.fields;
    }

    public static function build(target:String):Array<Field>
    {
        var type:Null<Type> = Context.getLocalType();
        var fields:Array<Field> = Context.getBuildFields();

        var builder:AppBuilder = new AppBuilder(target, type, fields);
        return builder.build_application();
    }
}
