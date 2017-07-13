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

class Image implements hase.iface.Raster<Symbol>
{
    private var dirty_rect:hase.geom.Rect;
    private var raster:Raster<Symbol>;

    public var width(get, set):Int;
    public var height(get, set):Int;

    // XXX!
    public var is_dirty:Bool;

    private function new(width:Int, height:Int, data:Array<Symbol>, def:Symbol)
    {
        this.is_dirty = true;
        this.raster = new Raster(width, height, data, def);
    }

    private inline function get_width():Int
        return this.raster.width;

    private function set_width(width:Int):Int
    {
        this.is_dirty = true; // XXX
        return this.raster.width = width;
    }

    private inline function get_height():Int
        return this.raster.height;

    private function set_height(height:Int):Int
    {
        this.is_dirty = true; // XXX
        return this.raster.height = height;
    }

    public function clear(?val:Symbol):Void
    {
        this.is_dirty = true; // XXX
        return this.raster.clear(val);
    }

    public inline function get(x:Int, y:Int):Symbol
        return this.raster.get(x, y);

    public function set(x:Int, y:Int, val:Symbol):Symbol
    {
        this.is_dirty = true; // XXX
        return this.raster.set(x, y, val);
    }

    public inline function unsafe_get(x:Int, y:Int):Symbol
        return this.raster.unsafe_get(x, y);

    public inline function unsafe_set(x:Int, y:Int, val:Symbol):Symbol
    {
        this.is_dirty = true; // XXX
        return this.raster.unsafe_set(x, y, val);
    }

    /*
    public function add_row(row:Array<Symbol>):Array<Symbol>
    {
        this.is_dirty = true; // XXX
        return this.raster.add_row(row);
    }
    */

    public inline function map_(f:Int -> Int -> Symbol -> Void):Void
        return this.raster.map_(f);

    public function merge_raster(raster:Raster<Symbol>):Void
    {
        if (this.raster != raster)
            this.is_dirty = true; // XXX
        // XXX!
        this.raster = raster;
        /*
        this.raster.width = raster.width;
        this.raster.height = raster.height;
        raster.map_(this.raster.unsafe_set);
        */
    }

    public inline static function from_raster(raster:Raster<Symbol>):Image
    {
        return new Image(
            raster.width, raster.height,
            raster.data,
            raster.default_value
        );
    }

    public inline static function
        create(width:Int, height:Int, ?val:Symbol, ?def:Symbol):Image
    {
        return new Image(
            width, height,
            [for (_ in 0...(width * height))
                val == null ? new Symbol(0) : val],
            def == null ? new Symbol(0) : def
        );
    }

    public static function from_2d_array(array:Array<Array<Symbol>>):Image
    {
        var new_image:Image = new Image(0, 0, [], new Symbol(0));

        for (row in array)
            new_image.raster.add_row(row);

        return new_image;
    }
}
