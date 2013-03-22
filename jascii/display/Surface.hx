package jascii.display;

class Surface extends ObjectContainer
{
    private var provider:ISurface;

    public function new(provider:ISurface)
    {
        super();
        this.provider = provider;
        this.width = provider.width;
        this.height = provider.height;
        this.autoresize = false;
    }

    public inline function draw_char(x:Int, y:Int, ordinal:Int):Void
    {
        if (x <= this.width && y <= this.height)
            this.provider.draw_char(x, y, ordinal);
    }
}
