package jascii.display;

class Sprite extends ObjectContainer
{
    private var ascii:Array<Array<Int>>;

    public function new()
    {
        super();
        this.ascii = null;
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

    public function blit( ?ascii:Array<Array<Int>>
                        , ?x:Int = 0
                        , ?y:Int = 0
                        ):Void
    {
        if (!this.check_culling(x, y))
            return;

        if (ascii != null)
            this.ascii = ascii;

        for (yi in 0...this.ascii.length) {
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
    }
}
