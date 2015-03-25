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
package hase.geom;

class Matrix<T>
{
    private var _width:Int;
    private var _height:Int;
    private var data:Array<T>;
    private var default_value:T;

    public var width(get, set):Int;
    public var height(get, set):Int;

    private inline function new(width:Int, height:Int, data:Array<T>, defval:T)
    {
        this._width = width;
        this._height = height;
        this.data = data;
        this.default_value = defval;
    }

    private inline function get_width():Int
        return this._width;

    private inline function set_width(new_width:Int):Int
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

    private inline function set_height(new_height:Int):Int
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

    public inline function unsafe_get(x:Int, y:Int):T
        return this.data[y * this._width + x];

    public inline function unsafe_set(x:Int, y:Int, val:T):T
        return this.data[y * this._width + x] = val;

    public inline function get(x:Int, y:Int):T
    {
        return (x < 0 || y < 0 || x >= this._width || y >= this.height)
             ? this.default_value : this.unsafe_get(x, y);
    }

    public inline function set(x:Int, y:Int, val:T):T
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

    public inline function map<R>(f:Int -> Int -> T -> R, def:R):Matrix<R>
    {
        var out:Array<R> = new Array();

        for (y in 0...this._height)
            for (x in 0...this._width)
                out.push(f(x, y, this.unsafe_get(x, y)));

        return new Matrix(this._width, this._height, out, def);
    }

    public inline function
        zip<R, T2>(m:Matrix<T2>, f:T -> T2 -> R, def:R):Matrix<R>
    {
        if (this._width > m._width)
            m.width = this._width
        else if (this._width < m._width)
            this.width = m._width;

        if (this._height > m._height)
            m.height = this._height;
        else if (this._height < m._height)
            this.height = m._height;

        return this.map(
            inline function(x:Int, y:Int, sym:T)
                return f(sym, m.unsafe_get(x, y)),
            def
        );
    }

    public inline function add_row(row:Array<T>):Array<T>
    {
        if (row.length > this._width)
            this.set_width(row.length);

        for (x in 0...this._width)
            this.data.push(x >= row.length ? this.default_value : row[x]);

        this._height++;

        return row;
    }

    public inline function delete_col(pos:Int, len:Int = 1):Void
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

    public inline function
        extract(x:Int = 0, y:Int = 0, width:Int = -1, height:Int = -1):Matrix<T>
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

        return new Matrix(width, height, new_data, this.default_value);
    }

    public inline function extract_rect(rect:Rect):Matrix<T>
        return this.extract(rect.x, rect.y, rect.width, rect.height);

    public inline function to_2d_array():Array<Array<T>>
    {
        return [
            for (y in 0...this._height)
                [for (x in 0...this._width) this.unsafe_get(x, y)]
        ];
    }

    public static inline function
        create<T>(width:Int, height:Int, val:T, def:T):Matrix<T>
        return new
              Matrix(width, height, [for (_ in 0...(width * height)) val], def);

    public static inline function
        from_2d_array<T>(array:Array<Array<T>>, def:T):Matrix<T>
    {
        var new_matrix:Matrix<T> = new Matrix(0, 0, [], def);

        for (row in array)
            new_matrix.add_row(row);

        return new_matrix;
    }
}
