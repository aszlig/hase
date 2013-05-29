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
package hase.test;

class SurfaceTestCase extends haxe.unit.TestCase
{
    var root:hase.display.Surface;
    var test_canvas:hase.test.TestCanvas;

    public override function setup():Void
    {
        this.test_canvas = new hase.test.TestCanvas();
        this.root = new hase.display.Surface(this.test_canvas);
    }

    public function create_image(data:Array<String>):hase.display.Image
    {
        var img:Array<Array<hase.display.Symbol>> = new Array();

        for (row in data) {
            var introw:Array<hase.display.Symbol> = new Array();

            for (x in 0...row.length)
                introw.push(row.charCodeAt(x) == " ".code
                            ? 0 : row.charCodeAt(x));

            img.push(introw);
        }

        return img;
    }

    public function clear_surface():Void
        this.test_canvas.clear();

    public function update(?td:Float = 1000):Void
        return this.root.update(td);

    public function
        create_animation(frames:Array<Array<String>>):hase.display.Animation
    {
        var new_frames:Array<hase.display.Animation.FrameData> = new Array();

        for (frame in frames)
            new_frames.push({ image: this.create_image(frame) });

        return new hase.display.Animation(new_frames);
    }

    public function create_sprite(image:Array<String>):hase.display.Sprite
    {
        var sprite:hase.display.Sprite = new hase.display.Sprite();
        sprite.ascii = this.create_image(image);
        return sprite;
    }

    private function format_expect(expect:Array<String>, got:Array<String>)
    {
        var ewidth:Int = expect[0].length;
        var eheight:Int = expect.length;

        var gwidth:Int = got[0].length;
        var gheight:Int = got.length;

        var eheader:String = "," + StringTools.rpad("", "-", ewidth) + ".";
        var gheader:String = "," + StringTools.rpad("", "-", gwidth) + ".";

        var efooter:String = "`" + StringTools.rpad("", "-", ewidth) + "'";
        var gfooter:String = "`" + StringTools.rpad("", "-", gwidth) + "'";

        var out:String = "\n";
        out += StringTools.rpad(" Expected:", " ", ewidth + 4) + "Got:";
        out += "\n" + eheader + " " + gheader + "\n";

        for (y in 0...gheight)
            out += "|" + expect[y] + "| |" + got[y] + "|\n";

        out += efooter + " " + gfooter;

        return out;
    }

    public function assert_area( expect:Array<String>
                               , x:Int, y:Int
                               , width:Int, height:Int
                               , ?pi:haxe.PosInfos
                               ):Void
    {
        this.currentTest.done = true;

        var fraction:Array<String> =
            this.test_canvas.extract(x, y, width, height);

        var match:Bool = true;

        var maxlen:Int = fraction.length > expect.length
                       ? fraction.length : expect.length;

        for (i in 0...maxlen)
            if (expect[i] != fraction[i])
                match = false;

        if (!match) {
            this.currentTest.success = false;
            this.currentTest.error = this.format_expect(expect, fraction);
            this.currentTest.posInfos = pi;
            throw this.currentTest;
        };
    }
}
