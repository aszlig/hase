package jascii.geom;

abstract Rect (Array<Int>)
{
    public var x(get, never):Int;
    public var y(get, never):Int;
    public var width(get, never):Int;
    public var height(get, never):Int;

    public var right(get, never):Int;
    public var bottom(get, never):Int;

    public inline function new(x:Int, y:Int, width:Int, height:Int)
        this = [x, y, width, height];

    private inline function get_x():Int
        return this[0];

    private inline function get_y():Int
        return this[1];

    private inline function get_width():Int
        return this[2];

    private inline function get_height():Int
        return this[3];

    private inline function get_right():Int
        return Rect.get_x(this) + Rect.get_width(this);

    private inline function get_bottom():Int
        return Rect.get_y(this) + Rect.get_height(this);

    public inline function union(other:Rect):Rect
    {
        var x:Int = other.x > Rect.get_x(this) ? Rect.get_x(this) : other.x;
        var y:Int = other.y > Rect.get_y(this) ? Rect.get_y(this) : other.y;
        var width:Int = other.right > Rect.get_right(this)
                      ? other.right : Rect.get_right(this);
        var height:Int = other.bottom > Rect.get_bottom(this)
                       ? other.bottom : Rect.get_bottom(this);

        return new Rect(x, y, width - x, height - y);
    }

    public inline function intersects(other:Rect):Bool
    {
        return Rect.get_x(this) < other.right
            && Rect.get_right(this) > other.x
            && Rect.get_y(this) < other.bottom
            && Rect.get_bottom(this) > other.y;
    }

    public inline function matches(other:Null<Rect>):Bool
    {
        return other != null
            && Rect.get_x(this) == other.x
            && Rect.get_y(this) == other.y
            && Rect.get_width(this) == other.width
            && Rect.get_height(this) == other.height;
    }
}
