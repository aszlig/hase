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
package hase.test;

class SurfaceTestCase extends haxe.unit.TestCase
{
    var root:hase.display.Surface;
    var terminal:hase.term.Test;

    public override function setup():Void
    {
        this.terminal = new hase.term.Test();
        this.root = new hase.display.Surface(this.terminal);
    }

    public function
        create_image(data:Array<String>):hase.geom.Raster<hase.display.Symbol>
    {
        var img:Array<Array<hase.display.Symbol>> = new Array();

        for (row in data) {
            var introw:Array<hase.display.Symbol> = new Array();

            for (x in 0...row.length)
                introw.push(row.charCodeAt(x) == " ".code
                            ? 0 : row.charCodeAt(x));

            img.push(introw);
        }

        return hase.geom.Raster.from_2d_array(img, 0);
    }

    public function clear_surface(?sym:hase.display.Symbol):Void
        this.terminal.clear(sym);

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
        sprite.ascii = hase.display.Image.from_raster(
            this.create_image(image)
        );
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

    public function assert_msg(cond:Bool, msg:String, ?pi:haxe.PosInfos):Void
    {
        this.currentTest.done = true;

        if (cond != true) {
            this.currentTest.success = false;
            this.currentTest.error = msg;
            this.currentTest.posInfos = pi;
            throw this.currentTest;
        }
    }

    public function assert_area( expect:Array<String>
                               , x:Int = 0, y:Int = 0
                               , ?pi:haxe.PosInfos
                               ):Void
    {
        this.currentTest.done = true;

        var width:Int = expect.length > 0 ? expect[0].length : 0;
        for (row in expect) {
            if (row.length != width) {
                this.currentTest.success = false;
                this.currentTest.error =
                    "Expected value has irregular row lengths.";
                this.currentTest.posInfos = pi;
                throw this.currentTest;
            }
        }
        var height:Int = expect.length;

        var fraction:Array<String> =
            this.terminal.extract(x, y, width, height);

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
