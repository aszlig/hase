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
