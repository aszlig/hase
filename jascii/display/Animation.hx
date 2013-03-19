package jascii.display;

class Animation extends Image
{
    private var frames:Array<Array<String>>;
    private var current:Int;

    private var td:Int;
    public var factor:Int;

    public function new()
    {
        super();
        this.frames = new Array();
        this.current = 0;

        this.td = 0;
        this.factor = 1;
    }

    public inline function add_frame(frame:Array<String>):Array<String>
    {
        this.frames.push(frame);
        return frame;
    }

    public override function update():Void
    {
        if (this.frames.length == 0)
            return;

        this.data = this.frames[this.current];
        super.update();

        if (++this.td == this.factor) {
            if (++this.current == this.frames.length)
                this.current = 0;

            this.td = 0;
        }
    }
}
