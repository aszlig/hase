package jascii.display;

class Surface extends Object
{
    private var provider:ISurface;
    private var sprites:Array<Sprite>;

    public function new(provider:ISurface)
    {
        super();
        this.is_surface = true;
        this.provider = provider;
        this.width = provider.width;
        this.height = provider.height;
        this.autoresize = false;
        this.sprites = new Array();
    }

    public inline function register_sprite(sprite:Sprite):Sprite
    {
        this.sprites.push(sprite);
        this.sprites.sort(function(a:Sprite, b:Sprite) {
            return (a.z < b.z) ? -1 : (a.z > b.z) ? 1 : 0;
        });
        return sprite;
    }

    public inline function unregister_sprite(sprite:Sprite):Sprite
    {
        this.sprites.remove(sprite);
        return sprite;
    }

    public inline function draw_char(x:Int, y:Int, ordinal:Int):Void
    {
        if (x <= this.width && y <= this.height)
            this.provider.draw_char(x, y, ordinal);
    }
}
