/* Haxe ASCII Spriting Engine
 *
 * Copyright (C) 2013-2017 aszlig
 *
 * This program is free software: you can redistribute it and/or modify it
 * under the terms of the GNU Affero General Public License, version 3, as
 * published by the Free Software Foundation.
 *
 * This program is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 * FITNESS FOR A PARTICULAR PURPOSE. See the GNU Affero General Public License
 * for more details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 */
package hase.macro;

#if macro

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
            case "cpp" | "neko": macro : {
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
            private var __timer:Null<hase.Timer>;

            public function new(term:hase.term.Interface)
            {
                this.root = new hase.display.Surface(term);
                this.__timer = null;

                var preloader = new hase.utils.Preloader();
                if (!preloader.done) {
                    this.root.add_child(preloader);

                    while (!preloader.done) {
                        preloader.width = this.root.width;
                        preloader.height = this.root.height;
                        this.root.update(0.0);
                    }

                    this.root.remove_child(preloader);
                }

                this.init();
            }

            public inline function run():Void
            {
                this.__timer = new hase.Timer(this.root);
                this.__timer.on_tick = function(td:Float) {
                    #if debug
                    var key:Key = this.root.terminal.get_key();
                    switch (key) {
                        case Char("d".code):
                            if (hase.utils.Debug.show_dirty_rects) {
                                hase.utils.Debug.show_dirty_rects = false;
                                this.root.mark_dirty();
                                this.root.terminal.clear();
                            } else {
                                hase.utils.Debug.show_dirty_rects = true;
                            };
                        case _:
                    }
                    this.on_keypress(key);
                    #else
                    this.on_keypress(this.root.terminal.get_key());
                    #end

                    return this.update(td);
                };
                this.__timer.start();
            }

            public function exit(code:Int = 0):Void
            {
                if (this.__timer != null) this.__timer.stop();
                this.root.terminal.exit(code);
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
#end
