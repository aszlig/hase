package jascii.geom;

private typedef MatrixBase<T> = {
    var data:Array<T>;
    var width:Int;
    var height:Int;
}

abstract Matrix<T> (MatrixBase<T>)
{
    public var width(get, never):Int;
    public var height(get, never):Int;

    private inline function new(width:Int, height:Int, data:Array<T>)
        this = { width: width, height: height, data: data };

    public inline function get_width():Int
        return this.width;

    public inline function get_height():Int
        return this.height;

    public inline function map_(f:Int -> Int -> T -> Void):Void
    {
        for (y in 0...this.height)
            for (x in 0...this.width)
                f(x, y, this.data[y * this.width + x]);
    }

    public inline function map<R>(f:Int -> Int -> T -> R):Matrix<R>
    {
        var out:Array<R> = new Array();

        for (y in 0...this.height)
            for (x in 0...this.width)
                out.push(f(x, y, this.data[y * this.width + x]));

        return new Matrix(this.width, this.height, out);
    }

    private static inline function fold_maxsize<O>(array:Array<O>, acc:Int):Int
        return array.length > acc ? array.length : acc;

    @:from public static inline function
        from_2d_array<O, T>(array:Array<Array<O>>):Matrix<T>
    {
        var data:Array<T> = new Array();

        var width:Int = Lambda.fold(array, Matrix.fold_maxsize, 0);
        var height:Int = array.length;

        for (row in array)
            for (x in 0...width)
                // XXX: This is _ugly_ as hell, as it's not guaranteed whether
                // the value will be null when the width gets out of the array
                // bounds of row.
                data.push(cast row[x]);

        return new Matrix(width, height, data);
    }
}
