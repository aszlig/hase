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

    public function clear(?sym:hase.display.Symbol):Void
    {
        if (sym == null)
            sym = new hase.display.Symbol(" ".code);

        for (c in 0...this.area.length)
            this.area[c] = sym;
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
