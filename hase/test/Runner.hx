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