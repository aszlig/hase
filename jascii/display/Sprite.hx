package jascii.display;

class Sprite extends ObjectContainer
{
    public inline function draw_string(x:Int, y:Int, value:String):Void
    {
        if (x <= this.parent.width && y <= this.parent.height)
            for (i in 0...value.length)
                this.surface.draw_char(this.parent.absolute_x + x + i,
                                       this.parent.absolute_y + y,
                                       value.charCodeAt(i));
    }

    public inline function draw_block(x:Int, y:Int, values:Array<String>):Void
    {
        if (x <= this.parent.width && y <= this.parent.height)
            for (i in values)
                this.draw_string(x, ++y, i);
    }
}
