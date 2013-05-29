package hase.geom;

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
        return Rect.x + Rect.width;

    private inline function get_bottom():Int
        return Rect.y + Rect.height;

    public inline function union(other:Rect):Rect
    {
        var x:Int = other.x > Rect.x ? Rect.x : other.x;
        var y:Int = other.y > Rect.y ? Rect.y : other.y;
        var width:Int = other.right > Rect.right
                      ? other.right : Rect.right;
        var height:Int = other.bottom > Rect.bottom
                       ? other.bottom : Rect.bottom;

        return new Rect(x, y, width - x, height - y);
    }

    public inline function intersects(other:Rect):Bool
    {
        return Rect.x < other.right
            && Rect.right > other.x
            && Rect.y < other.bottom
            && Rect.bottom > other.y;
    }

    public inline function matches(other:Null<Rect>):Bool
    {
        return other != null
            && Rect.x == other.x
            && Rect.y == other.y
            && Rect.width == other.width
            && Rect.height == other.height;
    }
}
