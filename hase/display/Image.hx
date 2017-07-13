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
package hase.display;

import hase.geom.Raster;
import hase.geom.Rect;

class Image implements hase.iface.Raster<Symbol>
{
    public var dirty_rect(default, null):Rect;
    private var raster:Raster<Symbol>;

    public var width(get, set):Int;
    public var height(get, set):Int;
    public var is_dirty(get, never):Bool;

    private function new(raster:Raster<Symbol>)
    {
        this.raster = raster;
        this.dirty_rect =
            new hase.geom.Rect(0, 0, raster.width, raster.height);
    }

    private inline function get_width():Int
        return this.raster.width;

    private function set_width(width:Int):Int
    {
        if (width > this.raster.width) {
            this.union_rect(
                this.raster.width - 1,
                0,
                width - this.raster.width,
                this.raster.height
            );
        } else if (width < this.raster.width) {
            this.union_rect(
                width - 1,
                0,
                this.raster.width - width,
                this.raster.height
            );
        }
        return this.raster.width = width;
    }

    private inline function get_height():Int
        return this.raster.height;

    private function set_height(height:Int):Int
    {
        if (height > this.raster.height) {
            this.union_rect(
                0,
                this.raster.height - 1,
                this.raster.width,
                height - this.raster.height
            );
        } else if (height < this.raster.height) {
            this.union_rect(
                0,
                height - 1,
                this.raster.width,
                this.raster.height - height
            );
        }
        return this.raster.height = height;
    }

    private function union_rect(x:Int, y:Int, width:Int, height:Int):Void
    {
        if (this.is_dirty) {
            this.dirty_rect.union_values_(x, y, width, height);
        } else {
            this.dirty_rect.x = x;
            this.dirty_rect.y = y;
            this.dirty_rect.width = width;
            this.dirty_rect.height = height;
        }
    }

    public function reset_dirty():Void
    {
        this.dirty_rect.x = 0;
        this.dirty_rect.y = 0;
        this.dirty_rect.width = 0;
        this.dirty_rect.height = 0;
    }

    public inline function get_is_dirty():Bool
        return this.dirty_rect.x != 0
            || this.dirty_rect.y != 0
            || this.dirty_rect.width != 0
            || this.dirty_rect.height != 0;

    public function clear(?val:Symbol):Void
    {
        this.dirty_rect.x = 0;
        this.dirty_rect.y = 0;
        this.dirty_rect.width = this.raster.width;
        this.dirty_rect.height = this.raster.height;
        return this.raster.clear(val);
    }

    public inline function get(x:Int, y:Int):Symbol
        return this.raster.get(x, y);

    private inline function union_set(x:Int, y:Int, val:Symbol):Void
    {
        if (this.raster.get(x, y) != val)
            this.union_rect(x, y, 1, 1);
    }

    public function set(x:Int, y:Int, val:Symbol):Symbol
    {
        this.union_set(x, y, val);
        return this.raster.set(x, y, val);
    }

    public inline function unsafe_get(x:Int, y:Int):Symbol
        return this.raster.unsafe_get(x, y);

    public function unsafe_set(x:Int, y:Int, val:Symbol):Symbol
    {
        this.union_set(x, y, val);
        return this.raster.unsafe_set(x, y, val);
    }

    public inline function map_(f:Int -> Int -> Symbol -> Void):Void
        return this.raster.map_(f);

    public function merge_raster(raster:Raster<Symbol>):Void
    {
        this.width = raster.width;
        this.height = raster.height;
        raster.map_(this.unsafe_set);
    }

    public inline static function from_raster(raster:Raster<Symbol>):Image
        return new Image(raster.copy());

    public inline static function
        create(width:Int, height:Int, ?val:Symbol, ?def:Symbol):Image
    {
        return new Image(Raster.create(
            width, height,
            val == null ? new Symbol(0) : val,
            def == null ? new Symbol(0) : def
        ));
    }

    public inline static function
        from_2d_array(array:Array<Array<Symbol>>):Image
        return new Image(Raster.from_2d_array(array, new Symbol(0)));
}
