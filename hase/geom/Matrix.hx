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
    public var width(default, set):Int;
    public var height(default, set):Int;
    private var data:Array<T>;
    private var default_value:T;

    public inline function new(width:Int, height:Int, data:Array<T>, defval:T)
    {
        this.width = width;
        this.height = height;
        this.data = data;
        this.default_value = defval;
    }

    public inline function set_width(new_width:Int):Int
    {
        while (this.width < new_width) {
            for (y in 1...(this.height + 1))
                this.data.insert(y * this.width + (y - 1), this.default_value);
            this.width++;
        }

        if (this.width > new_width) {
            for (y in 1...(this.height + 1))
                this.data.splice(y * new_width, this.width - new_width);

            this.width = new_width;
        }

        return this.width;
    }

    public inline function set_height(new_height:Int):Int
    {
        while (this.height < new_height) {
            for (x in 0...this.width) this.data.push(this.default_value);
            this.height++;
        }

        while (this.height > new_height) {
            for (x in 0...this.width)
                this.data.pop();
            this.height--;
        }

        return this.height;
    }

    public inline function get(x:Int, y:Int):T
        return this.data[y * this.width + x];

    public inline function set(x:Int, y:Int, val:T):T
        return this.data[y * this.width + x] = val;

    public inline function map_(f:Int -> Int -> T -> Void):Void
    {
        for (y in 0...this.height)
            for (x in 0...this.width)
                f(x, y, this.get(x, y));
    }

    public inline function map<R>(f:Int -> Int -> T -> R, def:R):Matrix<R>
    {
        var out:Array<R> = new Array();

        for (y in 0...this.height)
            for (x in 0...this.width)
                out.push(f(x, y, this.get(x, y)));

        return new Matrix(this.width, this.height, out, def);
    }

    public inline function
        zip<R, T2>(m:Matrix<T2>, f:T -> T2 -> R, def:R):Matrix<R>
    {
        return this.map(
            inline function(x:Int, y:Int, sym:T) return f(sym, m.get(x, y)),
            def
        );
    }

    public inline function add_row(row:Array<T>):Array<T>
    {
        if (row.length > this.width)
            this.set_width(row.length);

        for (x in 0...this.width)
            this.data.push(x >= row.length ? this.default_value : row[x]);

        this.height++;

        return row;
    }

    public inline function delete_col(pos:Int, len:Int = 1):Void
    {
        if (pos < 0)
            pos = this.width + pos;
        if (len < 0)
            len = this.width + len - pos + 1;
        if (pos + len > this.width)
            len = this.width - pos;

        this.width -= len;

        for (y in 0...this.height)
            this.data.splice(y * this.width + pos, len);
    }

    public inline function
        extract(x:Int = 0, y:Int = 0, width:Int = -1, height:Int = -1):Matrix<T>
    {
        var new_data:Array<T> = new Array();

        if (x < 0)
            x = this.width + x;
        if (y < 0)
            y = this.width + y;
        if (width < 0)
            width = this.width + width - x + 1;
        if (height < 0)
            height = this.height + height - y + 1;
        if (x + width > this.width)
            width = this.width - x;
        if (y + height > this.height)
            height = this.height - y;

        for (yi in y...(y + height))
            for (xi in x...(x + width))
                new_data.push(this.get(xi, yi));

        return new Matrix(width, height, new_data, this.default_value);
    }

    public inline function extract_rect(rect:Rect):Matrix<T>
        return this.extract(rect.x, rect.y, rect.width, rect.height);

    public inline function to_2d_array():Array<Array<T>>
    {
        return [for (y in 0...this.height)
                [for (x in 0...this.width) this.get(x, y)]];
    }

    public static inline function
        create<T>(width:Int, height:Int, val:T, def:T):Matrix<T>
        return new
              Matrix(width, height, [for (_ in 0...(width * height)) val], def);

    public static inline function
        from_2d_array<O, T>(array:Array<Array<O>>, def:T):Matrix<T>
    {
        var new_matrix:Matrix<T> = new Matrix(0, 0, [], def);

        for (row in array)
            new_matrix.add_row(cast row);

        return new_matrix;
    }
}
