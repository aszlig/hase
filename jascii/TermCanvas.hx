package jascii;

class TermCanvas implements jascii.display.ISurface
{
    private var canvas:js.html.CanvasElement;
    private var ctx:js.html.CanvasRenderingContext2D;

    private var font:TermFont;
    private var font_cache:Map<Int,Int>;
    private var font_canvas:js.html.CanvasElement;

    public var width:Int;
    public var height:Int;

    public function new(canvas:js.html.CanvasElement)
    {
        this.canvas = canvas;

        this.width = Std.int(canvas.width / (TermFont.WIDTH + 1));
        this.height = Std.int(canvas.height / TermFont.HEIGHT);

        this.ctx = canvas.getContext2d();
        this.ctx.fillStyle = "black";
        this.ctx.fillRect(0, 0, canvas.width, canvas.height);

        this.font = new TermFont();
        this.font_cache = new Map();
        this.font_canvas = null;
    }

    private inline function cursor2x(x:Int):Int
    {
#if debug
        if (x * (TermFont.WIDTH + 1) > this.canvas.width)
            trace("X cursor value of " + x + " exceeds width of " +
                  this.canvas.width + " pixels!");
#end

        return x * (TermFont.WIDTH + 1);
    }

    private inline function cursor2y(y:Int):Int
    {
#if debug
        if (y * TermFont.HEIGHT > this.canvas.height)
            trace("Y cursor value of " + y + " exceeds height of " +
                  this.canvas.height + " pixels!");
#end

        return y * TermFont.HEIGHT;
    }

    private inline function add_to_font_cache(sym:jascii.display.Symbol):Int
    {
        var cachedata:js.html.ImageData =
            this.ctx.createImageData(TermFont.WIDTH, TermFont.HEIGHT);

        var fgcolor:Int = jascii.display.Color.get_rgb(sym.fgcolor);
        var bgcolor:Int = jascii.display.Color.get_rgb(sym.bgcolor);

        var i:Int = 0;
        for (row in this.font.iter_char(sym.ordinal)) {
            for (val in row) {
                cachedata.data[i++] = val ? fgcolor >> 16 & 0xff
                                          : bgcolor >> 16 & 0xff;
                cachedata.data[i++] = val ? fgcolor >> 8  & 0xff
                                          : bgcolor >> 8  & 0xff;
                cachedata.data[i++] = val ? fgcolor       & 0xff
                                          : bgcolor       & 0xff;
                cachedata.data[i++] = 0xff;
            }
        }

        var cached:Int =
            (this.font_canvas == null ? 0 : this.font_canvas.width);

        var new_canvas:js.html.CanvasElement =
            js.Browser.document.createCanvasElement();

        new_canvas.width = cached + TermFont.WIDTH;
        new_canvas.height = TermFont.HEIGHT;

        var new_context:js.html.CanvasRenderingContext2D =
            new_canvas.getContext2d();

        if (cached > 0)
            new_context.drawImage(this.font_canvas, 0, 0);

        new_context.putImageData(cachedata, cached, 0);

        this.font_cache.set(sym.get_hash(), cached);
        this.font_canvas = new_canvas;
        return cached;
    }

    public function draw_char(x:Int, y:Int, sym:jascii.display.Symbol):Void
    {
        var cached:Int = this.font_cache.get(sym.get_hash());

        if (cached == null)
            cached = this.add_to_font_cache(sym);

        this.ctx.drawImage(this.font_canvas,
            cached, 0, TermFont.WIDTH, TermFont.HEIGHT,
            this.cursor2x(x), this.cursor2y(y),
            TermFont.WIDTH, TermFont.HEIGHT);
    }
}
