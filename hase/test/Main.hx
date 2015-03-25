/* Copyright (C) 2013-2015 aszlig
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
        runner.add(new hase.test.cases.SpriteTest());
        runner.add(new hase.test.cases.SurfaceTest());
        runner.add(new hase.test.cases.AnimationTest());
        runner.add(new hase.test.cases.MatrixTest());
        runner.add(new hase.test.cases.AnimationParserTest());
        runner.add(new hase.test.cases.FrameAreaParserTest());
        runner.add(new hase.test.cases.ColorTableTest());
        runner.add(new hase.test.cases.RectTest());
        runner.add(new hase.test.cases.PVectorTest());
        runner.add(new hase.test.cases.MotionTest());
        runner.run();
    }
}
