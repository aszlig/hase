package jascii.display;

import jascii.geom.Rect;

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

    public inline function z_reorder():Void
    {
        this.sprites.sort(function(a:Sprite, b:Sprite) {
            return (a.z < b.z) ? -1 : (a.z > b.z) ? 1 : 0;
        });
    }

    public inline function register_sprite(sprite:Sprite):Sprite
    {
        this.sprites.push(sprite);
        this.z_reorder();
        return sprite;
    }

    public inline function unregister_sprite(sprite:Sprite):Sprite
    {
        this.sprites.remove(sprite);
        return sprite;
    }

    private inline function fill_rect(rect:Rect, ?char:Int = " ".code):Void
    {
        for (y in rect.y...(rect.y + rect.height))
            for (x in rect.x...(rect.x + rect.width))
                this.draw_char(x, y, new Symbol(char));
    }

    public function redraw_rect(rect:Rect):Void
    {
        this.fill_rect(rect);

        for (sprite in this.sprites)
            if (sprite.rect == null || sprite.rect.intersects(rect))
                this.blit(sprite);
    }

    private inline function draw_char(x:Int, y:Int, sym:Symbol):Void
    {
        if (x >= 0 && y >= 0 && x <= this.width && y <= this.height)
            this.provider.draw_char(x, y, sym);
    }

    private function blit(sprite:Sprite):Void
    {
        if (sprite.ascii == null || sprite.rect == null)
            return;

        sprite.ascii.map_(inline function(x:Int, y:Int, sym:Symbol) {
            if (sym.is_alpha()) return;
            this.draw_char(sprite.rect.x + x, sprite.rect.y + y, sym);
        });
    }
}
