package jascii.display;

abstract Symbol(Int) from Int
{
    public var ordinal(get, set):Int;
    public var fgcolor(get, set):Int;
    public var bgcolor(get, set):Int;

    public inline function new(ord:Int, fg:Int = 0, bg:Int = 0)
        this = bg << 16 | fg << 8 | ord;

    private inline function get_ordinal():Int
        return this & 0xff;

    private inline function set_ordinal(ord:Int):Int
        return this |= ord;

    private inline function get_fgcolor():Int
        return (this & 0xff00) >> 8;

    private inline function set_fgcolor(fg:Int):Int
        return this |= (fg << 8);

    private inline function get_bgcolor():Int
        return (this & 0xff0000) >> 16;

    private inline function set_bgcolor(bg:Int):Int
        return this |= (bg << 16);

    public inline function is_alpha():Bool
        return this & 0xff == 0;
}
