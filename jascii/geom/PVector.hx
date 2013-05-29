package jascii.geom;

abstract PVector (Array<Float>)
{
    public var x(get, set):Float;
    public var y(get, set):Float;

    public inline function new(x:Float, y:Float)
        this = [x, y];

    public inline function get_x():Float
        return this[0];

    public inline function set_x(val:Float):Float
        return this[0] = val;

    public inline function get_y():Float
        return this[1];

    public inline function set_y(val:Float):Float
        return this[1] = val;

    public inline function dot_product(other:PVector):Float
        return PVector.x * other.x + PVector.y * other.y;

    public inline function cross_product(other:PVector):Float
        return PVector.x * other.y - PVector.y * other.x;

    public inline function normalize():Void
    {
        var len:Float = Math.sqrt(this[0] * this[0] + this[1] * this[1]);
        this[0] /= len;
        this[1] /= len;
    }

    @:op(A + B)
    public static inline function add(a:PVector, b:PVector):PVector
        return new PVector(a.x + b.x, a.y + b.y);

    @:op(A - B)
    public static inline function sub(a:PVector, b:PVector):PVector
        return new PVector(a.x - b.x, a.y - b.y);

    @:op(A * B)
    public static inline function mul(a:PVector, b:PVector):PVector
        return new PVector(a.x * b.x, a.y * b.y);

    @:commutative @:op(A * B)
    public static inline function mulf(a:PVector, b:Float):PVector
        return new PVector(a.x * b, a.y * b);

    @:op(-A)
    public static inline function inv(v:PVector):PVector
        return new PVector(-v.x, -v.y);
}
