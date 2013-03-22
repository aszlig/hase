package jascii.display;

class Sprite extends Object
{
    public var ascii(default, null):Array<Array<Int>>;
    public var rect(default, null):Rect;

    public function new()
    {
        super();
        this.ascii = null;
        this.rect = null;
    }

    private function calculate_width():Int
    {
        var width:Int = 0;

        for (row in this.ascii)
            width = row.length > width ? row.length : width;

        return width;
    }

    private override function set_surface(val:Surface):Surface
    {
        if (val != null)
            val.register_sprite(this);
        else if (this.surface != null)
            this.surface.unregister_sprite(this);

        return super.set_surface(val);
    }

    public function blit(ascii:Array<Array<Int>>):Void
    {
        this.ascii = ascii;

        var width:Int = this.calculate_width();
        var height:Int = this.ascii.length;

        var new_rect:Rect = new Rect(
            this.parent.absolute_x + this.x,
            this.parent.absolute_y + this.y,
            width, height
        );

        var union:Rect = new_rect;

        if (this.rect != null)
            union = new_rect.union(this.rect);

        this.surface.redraw_rect(union);

        this.rect = new_rect;
    }
}
