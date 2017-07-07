/* Copyright (C) 2013-2017 aszlig
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

class Main
{
    public static function main():Void
    {
        var runner = new haxe.unit.TestRunner();
        #if js
        if (untyped __js__("typeof phantom") != "undefined") {
            var system = untyped __js__("require")("system");
            haxe.unit.TestRunner.print = system.stdout.write;
        }
        #end
        runner.add(new hase.test.cases.AnimationParserTest());
        runner.add(new hase.test.cases.AnimationTest());
        runner.add(new hase.test.cases.BitmapTest());
        runner.add(new hase.test.cases.BoxTest());
        runner.add(new hase.test.cases.ColorTableTest());
        runner.add(new hase.test.cases.FrameAreaParserTest());
        runner.add(new hase.test.cases.MiscTest());
        runner.add(new hase.test.cases.MotionTest());
        runner.add(new hase.test.cases.PVectorTest());
        runner.add(new hase.test.cases.PathTest());
        runner.add(new hase.test.cases.RasterTest());
        runner.add(new hase.test.cases.RectTest());
        runner.add(new hase.test.cases.SpriteTest());
        runner.add(new hase.test.cases.SurfaceTest());
        var result:Bool = runner.run();
        #if js
        if (untyped __js__("typeof phantom") != "undefined")
            untyped __js__("phantom.exit")(result ? 0 : 1);
        #elseif (cpp || neko)
        Sys.exit(result ? 0 : 1);
        #end
    }
}
