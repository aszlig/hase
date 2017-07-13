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

class Raster<T> implements hase.iface.Raster<T>
{
    private var _width:Int;
    private var _height:Int;

    @:allow(hase.display.Image)
    private var default_value:T;

    @:allow(hase.geom.Bitmap.set)
    @:allow(hase.geom.Bitmap.unset)
    @:allow(hase.geom.Bitmap.set_rect)
    @:allow(hase.display.Image)
    private var data:Array<T>;

    public var width(get, set):Int;
    public var height(get, set):Int;

    @:allow(hase.display.Image)
    private function new(width:Int, height:Int, data:Array<T>, defval:T)
    {
        this._width = width;
        this._height = height;
        this.data = data;
        this.default_value = defval;
    }

    private inline function get_width():Int
        return this._width;

    private function set_width(new_width:Int):Int
    {
        while (this._width < new_width) {
            for (y in 1...(this._height + 1))
                this.data.insert(y * this._width + (y - 1), this.default_value);
            this._width++;
        }

        if (this._width > new_width) {
            for (y in 1...(this._height + 1))
                this.data.splice(y * new_width, this._width - new_width);

            this._width = new_width;
        }

        return this._width;
    }

    private inline function get_height():Int
        return this._height;

    private function set_height(new_height:Int):Int
    {
        while (this._height < new_height) {
            for (x in 0...this._width) this.data.push(this.default_value);
            this._height++;
        }

        while (this._height > new_height) {
            for (x in 0...this._width)
                this.data.pop();
            this._height--;
        }

        return this._height;
    }

    public function clear(?val:T):Void
    {
        if (val == null)
            val = this.default_value;

        for (i in 0...this.data.length)
            this.data[i] = val;
    }

    public function copy():Raster<T>
        return new Raster(this._width, this._height, this.data.copy(),
                          this.default_value);

    public inline function unsafe_get(x:Int, y:Int):T
        return this.data[y * this._width + x];

    public inline function unsafe_set(x:Int, y:Int, val:T):T
        return this.data[y * this._width + x] = val;

    public function get(x:Int, y:Int):T
    {
        return (x < 0 || y < 0 || x >= this._width || y >= this.height)
             ? this.default_value : this.unsafe_get(x, y);
    }

    public function set(x:Int, y:Int, val:T):T
    {
        if (x < 0) x = 0;
        if (y < 0) y = 0;
        if (x >= this._width)  this.width  = x + 1;
        if (y >= this._height) this.height = y + 1;
        return this.unsafe_set(x, y, val);
    }

    public inline function map_(f:Int -> Int -> T -> Void):Void
    {
        for (y in 0...this._height)
            for (x in 0...this._width)
                f(x, y, this.unsafe_get(x, y));
    }

    public function map<R>(f:Int -> Int -> T -> R, def:R):Raster<R>
    {
        var out:Array<R> = new Array();

        for (y in 0...this._height)
            for (x in 0...this._width)
                out.push(f(x, y, this.unsafe_get(x, y)));

        return new Raster(this._width, this._height, out, def);
    }

    public function zip<R, T2>(m:Raster<T2>, f:T -> T2 -> R, def:R):Raster<R>
    {
        if (this._width > m._width)
            m.width = this._width
        else if (this._width < m._width)
            this.width = m._width;

        if (this._height > m._height)
            m.height = this._height;
        else if (this._height < m._height)
            this.height = m._height;

        var result:Array<R> = [
            for (i in 0...this.data.length) f(this.data[i], m.data[i])
        ];

        return new Raster(this._width, this._height, result, def);
    }

    public function add_row(row:Array<T>):Array<T>
    {
        if (row.length > this._width)
            this.set_width(row.length);

        for (x in 0...this._width)
            this.data.push(x >= row.length ? this.default_value : row[x]);

        this._height++;

        return row;
    }

    public function delete_col(pos:Int, len:Int = 1):Void
    {
        if (pos < 0)
            pos = this._width + pos;
        if (len < 0)
            len = this._width + len - pos + 1;
        if (pos + len > this._width)
            len = this._width - pos;

        this._width -= len;

        for (y in 0...this._height)
            this.data.splice(y * this._width + pos, len);
    }

    public function
        extract(x:Int = 0, y:Int = 0, width:Int = -1, height:Int = -1):Raster<T>
    {
        var new_data:Array<T> = new Array();

        if (x < 0)
            x = this._width + x;
        if (y < 0)
            y = this._width + y;
        if (width < 0)
            width = this._width + width - x + 1;
        if (height < 0)
            height = this._height + height - y + 1;
        if (x + width > this._width)
            width = this._width - x;
        if (y + height > this._height)
            height = this._height - y;

        for (yi in y...(y + height))
            for (xi in x...(x + width))
                new_data.push(this.unsafe_get(xi, yi));

        return new Raster(width, height, new_data, this.default_value);
    }

    public inline function extract_rect(rect:Rect):Raster<T>
        return this.extract(rect.x, rect.y, rect.width, rect.height);

    public function to_2d_array():Array<Array<T>>
    {
        return [
            for (y in 0...this._height)
                [for (x in 0...this._width) this.unsafe_get(x, y)]
        ];
    }

    public inline static function
        create<T>(width:Int, height:Int, val:T, def:T):Raster<T>
        return new
              Raster(width, height, [for (_ in 0...(width * height)) val], def);

    public static function
        from_2d_array<T>(array:Array<Array<T>>, def:T):Raster<T>
    {
        var new_raster:Raster<T> = new Raster(0, 0, [], def);

        for (row in array)
            new_raster.add_row(row);

        return new_raster;
    }
}
