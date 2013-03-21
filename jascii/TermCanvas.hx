package jascii;

private class Font
{
    public inline static var path:String = "cp437.png";

    public inline static var sprite_width:Int = 304;
    public inline static var sprite_height:Int = 304;

    public inline static var xpadding:Int = 0;
    public inline static var ypadding:Int = 1;
    public inline static var xmargin:Int = 7;
    public inline static var ymargin:Int = 7;

    public inline static var cwidth:Int = 9;
    public inline static var cheight:Int = 16;
}

class TermCanvas extends jascii.display.ObjectContainer,
                 implements jascii.display.ISurface
{
    private var canvas:Canvas;
    private var ctx:CanvasRenderingContext2D;
    private var font:Image;

    public function new(canvas:Canvas)
    {
        super();
        this.canvas = canvas;
        this.width = Std.int(canvas.width / Font.cwidth);
        this.height = Std.int(canvas.height / Font.cheight);
        this.autoresize = false;
        this.ctx = canvas.getContext("2d");
    }

    public function init():Void
    {
        ctx.fillStyle = "black";
        ctx.fillRect(0, 0, canvas.width, canvas.height);

        this.font = new Image();
        this.font.src = Font.path;
        this.font.width = Font.sprite_width;
        this.font.height = Font.sprite_height;
        this.font.onload = this.onload;
    }

    private inline function cursor2x(x:Int):Int
    {
#if debug
        if (x * Font.cwidth > this.canvas.width)
            trace("X cursor value of " + x + " exceeds width of " +
                  this.canvas.width + " pixels!");
#end

        return x * Font.cwidth;
    }

    private inline function cursor2y(y:Int):Int
    {
#if debug
        if (y * Font.cheight > this.canvas.height)
            trace("Y cursor value of " + y + " exceeds height of " +
                  this.canvas.height + " pixels!");
#end

        return y * Font.cheight;
    }

    public function draw_char(x:Int, y:Int, ordinal:Int):Void
    {
        if (x > width || y > height)
            return;

        var cleft:Int = (ordinal % 32) * Font.cwidth + Font.xpadding;
        var ctop:Int = Std.int(ordinal / 32) * Font.cheight + Font.ypadding;

        this.ctx.drawImage(
            this.font,
            Font.xmargin + cleft, Font.ymargin + ctop,
            Font.cwidth, Font.cheight,
            this.cursor2x(x), this.cursor2y(y),
            Font.cwidth, Font.cheight
        );
    }

    public dynamic function onload():Void {}
}
