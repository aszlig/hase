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
package hase.geom;

class Bitmap
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

    public function is_set(x:Int, y:Int):Bool
        return this.data.get(this.calc_x(x), y) & this.calc_x_bit(x) > 0;

    private function get_raster_cell(x:Int, y:Int):Int
        return y * this.data.width + this.calc_x(x);

    private inline function is_oob(x:Int, y:Int):Bool
        return x < 0 || y < 0 || x >= this.width || y >= this.height;

    public inline function set(x:Int, y:Int):Bitmap
    {
        if (is_oob(x, y)) return this;
        this.data.data[this.get_raster_cell(x, y)] |= this.calc_x_bit(x);
        return this;
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

    public inline function unset(x:Int, y:Int):Bitmap
    {
        if (is_oob(x, y)) return this;
        this.data.data[this.get_raster_cell(x, y)] &= ~this.calc_x_bit(x);
        return this;
    }

    public inline function clear():Void
        return this.data.clear();
}
