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
package hase.geom;

class Bitmap implements hase.iface.Raster<Bool>
{
    // 31 bits because on some platforms we might get into signed territory.
    private inline static var BITSIZE:Int = 31;
    private inline static var MASK_FULL:Int = 2147483647;

    private var _width:Int;
    private var _height:Int;

    public var width(get, set):Int;
    public var height(get, set):Int;

    private var data:Raster<Int>;

    public function new(width:Int, height:Int)
    {
        this._width = width;
        this._height = height;

        this.data = Raster.create(this.calc_width(width), height, 0, 0);
    }

    private inline function calc_width(width:Int):Int
        return Std.int(width / Bitmap.BITSIZE)
             + hase.utils.Misc.signum(width % Bitmap.BITSIZE);

    private inline function calc_x(x:Int):Int
        return Std.int(x / Bitmap.BITSIZE);

    private inline function calc_x_bit(x:Int):Int
        return 1 << (x % Bitmap.BITSIZE);

    private inline function get_width():Int
        return this._width;

    private function set_width(width:Int):Int
    {
        this.data.width = this.calc_width(width);
        return this._width = width;
    }

    private inline function get_height():Int
        return this._height;

    private function set_height(height:Int):Int
        return this._height = this.data.height = height;

    private function get_raster_cell(x:Int, y:Int):Int
        return y * this.data.width + this.calc_x(x);

    private inline function is_oob(x:Int, y:Int):Bool
        return x < 0 || y < 0 || x >= this.width || y >= this.height;

    public function unsafe_get(x:Int, y:Int):Bool
        return this.data.unsafe_get(this.calc_x(x), y)
             & this.calc_x_bit(x) > 0;

    public inline function get(x:Int, y:Int):Bool
        return is_oob(x, y) ? false : this.unsafe_get(x, y);

    public function unsafe_set(x:Int, y:Int, val:Bool):Bool
    {
        if (val)
            this.data.data[this.get_raster_cell(x, y)] |= this.calc_x_bit(x);
        else
            this.data.data[this.get_raster_cell(x, y)] &= ~this.calc_x_bit(x);
        return val;
    }

    public inline function set(x:Int, y:Int, val:Bool):Bool
        return is_oob(x, y) ? val : this.unsafe_set(x, y, val);

    public function map_(f:Int -> Int -> Bool -> Void):Void
    {
        for (y in 0...this._height) {
            for (x in 0...this._width) {
                var val:Int = this.data.unsafe_get(this.calc_x(x), y);
                f(x, y, val & this.calc_x_bit(x) > 0);
            }
        }
    }

    public function set_rect(rect:Rect):Bitmap
    {
        if (this.width == 0 || this.height == 0 ||
            rect.width == 0 || rect.height == 0 )
            return this;

        var bounds:Rect = new Rect(0, 0, this.width, this.height);

        if (!bounds.intersects(rect))
            return this;

        var real_rect:Rect = bounds > rect ? rect : bounds | rect;

        var mask_first:Int = Bitmap.MASK_FULL & ~(calc_x_bit(real_rect.x) - 1);
        var mask_last:Int = calc_x_bit(real_rect.right) - 1;

        for (y in real_rect.top...real_rect.bottom) {
            var first:Int = this.get_raster_cell(real_rect.x, y);
            var last:Int = this.get_raster_cell(real_rect.right, y);

            if (first == last) {
                this.data.data[first] |= calc_x_bit(real_rect.right)
                                       - calc_x_bit(real_rect.x);
                continue;
            }

            this.data.data[first] |= mask_first;
            if (first + 1 != last)
                this.data.data[last] |= mask_last;

            for (x in (first + 1)...last)
                this.data.data[x] = Bitmap.MASK_FULL;
        }

        return this;
    }

    public inline function set_bit(x:Int, y:Int):Void
        this.set(x, y, true);

    public inline function unset_bit(x:Int, y:Int):Void
        this.set(x, y, false);

    public inline function clear(?val:Bool):Void
        return this.data.clear(val == null ? 0 : val ? MASK_FULL : 0);
}
