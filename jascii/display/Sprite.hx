package jascii.display;

class Sprite extends Object
{
    private var ascii:Array<Array<Int>>;
    private var rect:Rect;

    public function new()
    {
        super();
        this.ascii = null;
        this.rect = null;
    }

    private inline function check_culling( x:Int
                                         , y:Int
                                         , ?width:Int = 0
                                         , ?height:Int = 0
                                         ):Bool
    {
        return (this.x + x <= this.parent.width
            &&  this.y + y <= this.parent.height)
            || (this.x + x - width >= this.parent.x
            &&  this.y + y - height >= this.parent.y);
    }

    private function fill_rect(?char:Int = " ".code):Void
    {
        if (this.rect == null)
            return;

        for (y in this.rect.y...(this.rect.y + this.rect.height))
            for (x in this.rect.x...(this.rect.x + this.rect.width))
                this.surface.draw_char(x, y, char);
    }

    private override function set_surface(val:Surface):Surface
    {
        if (val != null)
            val.register_sprite(this);
        else if (this.surface != null)
            this.surface.unregister_sprite(this);
        return super.set_surface(val);
    }

    public function blit( ?ascii:Array<Array<Int>>
                        , ?x:Int = 0
                        , ?y:Int = 0
                        ):Void
    {
        if (!this.dirty)
            return;

        this.dirty = false;

        if (!this.check_culling(x, y))
            return;

        if (ascii != null)
            this.ascii = ascii;

        this.fill_rect();

        var width:Int = 0;
        var height:Int = this.ascii.length;

        for (yi in 0...this.ascii.length) {
            if (this.ascii[yi].length > width)
                width = this.ascii[yi].length;

            for (xi in 0...this.ascii[yi].length) {
                if (ascii[yi][xi] == 0)
                    continue;

                this.surface.draw_char(
                    this.parent.absolute_x + this.x + xi + x,
                    this.parent.absolute_y + this.y + yi + y,
                    this.ascii[yi][xi]
                );
            }
        }

        this.rect = new Rect(
            this.parent.absolute_x + this.x + x,
            this.parent.absolute_y + this.y + y,
            width, height
        );
    }
}
