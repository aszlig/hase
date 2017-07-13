/* Haxe ASCII Spriting Engine
 *
 * Copyright (C) 2017 aszlig
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
package hase.test;

#if macro
import haxe.macro.Context;
import haxe.macro.Expr;
#end

class Runner extends haxe.unit.TestRunner
{
    public function new()
    {
        #if js
        if (untyped __js__("typeof phantom") != "undefined") {
            var system = untyped __js__("require")("system");
            haxe.unit.TestRunner.print = system.stdout.write;
        }
        #end

        super();
    }

    public function run_and_exit():Void
    {
        var result:Bool = this.run();
        #if js
        if (untyped __js__("typeof phantom") != "undefined")
            untyped __js__("phantom.exit")(result ? 0 : 1);
        #elseif (cpp || neko)
        Sys.exit(result ? 0 : 1);
        #end
    }

    macro public static function build_single():Array<Field>
    {
        var type = Context.getLocalType();
        var fields:Array<Field> = Context.getBuildFields();

        var ctype:ComplexType = Context.toComplexType(type);
        var typepath:TypePath = switch (ctype) {
            case TPath(p): p;
            default: throw "Cannot find type path to base class!";
        };

        var main:ComplexType = macro : {
            public static function main():Void
            {
                var runner = new Runner();
                runner.add(new $typepath());
                runner.run_and_exit();
            }
        };

        var statics:Array<Field> = switch (main) {
            case TAnonymous(s): s;
            default: throw "Unable to create static function main().";
        };

        return fields.concat(statics);
    }
}
