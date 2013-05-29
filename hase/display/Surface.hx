/* Copyright (C) 2013 aszlig
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */
package hase.display;

import hase.geom.Rect;

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
        if (sprite.rect != null)
            this.redraw_rect(sprite.rect);
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
