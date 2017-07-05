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
package hase.term;

import hase.geom.Rect;

class Test implements Interface
{
    public var width:Int;
    public var height:Int;

    private var renderer:hase.term.renderer.Interface;
    private var area:Array<hase.display.Symbol>;

    public function new()
    {
        this.width = 40;
        this.height = 25;

        this.renderer = new hase.term.renderer.CharRenderer(this);
        this.area = new Array();

        for (i in 0...(this.width * this.height))
            this.area.push(new hase.display.Symbol(" ".code));
    }

    public inline function exit(code:Int):Void {}
    public inline function get_key():hase.input.Key return None;

    private function draw_area(rect:Rect, area:hase.display.Image):Void
    {
        area.map_(function(x:Int, y:Int, sym:hase.display.Symbol):Void {
            this.area[(rect.y + y) * this.width + (rect.x + x)] = sym;
        });
    }

    public function clear():Void
    {
        for (c in 0...this.area.length)
            this.area[c] = new hase.display.Symbol(" ".code);
    }

    public function extract(x:Int, y:Int, width:Int, height:Int):Array<String>
    {
        var out:Array<String> = new Array();
        var buf:String = "";

        for (c in 0...this.area.length) {
            if (c > 0 && c % this.width == 0 && buf.length > 0) {
                out.push(buf);
                buf = "";
            }

            var cur_x:Int = c % this.width;
            var cur_y:Int = Std.int(c / this.width);

            if (cur_x < x || cur_x >= x + width)
                continue;

            if (cur_y < y || cur_y >= y + height)
                continue;

            buf += String.fromCharCode(this.area[c].ordinal);
        }

        return out;
    }

    public function toString():String
    {
        var out:String = "\n,";

        out += StringTools.rpad("", "-", this.width) + ".\n|";

        for (c in 0...this.area.length) {
            if (c > 0 && c % this.width == 0)
                out += "|\n|";

            out += String.fromCharCode(this.area[c].ordinal);
        }

        out += "|\n`" + StringTools.rpad("", "-", this.width) + "'";

        return out;
    }
}
