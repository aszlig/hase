package jascii.display;

class Symbol
{
    public var ordinal(default, null):Int;
    public var fgcolor(default, null):Int;
    public var bgcolor(default, null):Int;

    public inline function new(ord:Int, fg:Int = 0, bg:Int = 0)
    {
        this.ordinal = ord;
        this.fgcolor = fg;
        this.bgcolor = bg;
    }

    public inline function get_hash():Int
    {
        return this.ordinal << 16 | this.fgcolor << 8 | this.bgcolor;
    }

    public inline function is_alpha():Bool
    {
        return this.ordinal == 0;
    }
}
