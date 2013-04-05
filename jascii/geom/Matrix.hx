package jascii.geom;

private typedef MatrixBase<T> = {
    var data:Array<T>;
    var width:Int;
    var height:Int;
}

abstract Matrix<T> (MatrixBase<T>)
{
    public var width(get, set):Int;
    public var height(get, set):Int;

    private inline function new(width:Int, height:Int, data:Array<T>)
        this = { width: width, height: height, data: data };

    private inline function get_default_value():T
        return null;

    public inline function get_width():Int
        return this.width;

    public inline function set_width(new_width:Int):Int
    {
        while (this.width < new_width) {
            for (y in 1...(this.height + 1))
                this.data.insert(y * this.width + (y - 1),
                                 Matrix.get_default_value(this));
            this.width++;
        }

        if (this.width > new_width) {
            for (y in 1...(this.height + 1))
                this.data.splice(y * new_width, this.width - new_width);

            this.width = new_width;
        }

        return this.width;
    }

    public inline function get_height():Int
        return this.height;

    public inline function set_height(new_height:Int):Int
    {
        while (this.height < new_height) {
            for (x in 0...this.width)
                this.data.push(Matrix.get_default_value(this));
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
                f(x, y, Matrix.get(this, x, y));
    }

    public inline function map<R>(f:Int -> Int -> T -> R):Matrix<R>
    {
        var out:Array<R> = new Array();

        for (y in 0...this.height)
            for (x in 0...this.width)
                out.push(f(x, y, Matrix.get(this, x, y)));

        return new Matrix(this.width, this.height, out);
    }

    public inline function zip<R, T2>(m:Matrix<T2>, f:T -> T2 -> R):Matrix<R>
    {
        return Matrix.map(this, inline function(x:Int, y:Int, sym:T)
                                return f(sym, m.get(x, y)));
    }

    public inline function add_row(row:Array<T>):Array<T>
    {
        if (row.length > this.width)
            Matrix.set_width(this, row.length);

        for (x in 0...this.width)
            this.data.push(x >= row.length
                           ? Matrix.get_default_value(this)
                           : row[x]);

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
                new_data.push(Matrix.get(this, xi, yi));

        return new Matrix(width, height, new_data);
    }

    public inline function extract_rect(rect:Rect):Matrix<T>
        return Matrix.extract(this, rect.x, rect.y, rect.width, rect.height);

    public inline function to_2d_array():Array<Array<T>>
    {
        return [for (y in 0...this.height)
                [for (x in 0...this.width) Matrix.get(this, x, y)]];
    }

    private static inline function fold_maxsize<O>(array:Array<O>, acc:Int):Int
        return array.length > acc ? array.length : acc;

    @:from public static inline function
        from_internal<O, T>(int:MatrixBase<O>):Matrix<T>
        return cast int;

    @:from public static inline function
        from_2d_array<O, T>(array:Array<Array<O>>):Matrix<T>
    {
        var new_matrix:Matrix<T> = new Matrix(0, 0, []);

        for (row in array)
            new_matrix.add_row(cast row);

        return new_matrix;
    }
}
