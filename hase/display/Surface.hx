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
    public var terminal(default, null):hase.term.Interface;

    private var sprites:Array<Sprite>;

    public function new(terminal:hase.term.Interface)
    {
        super();
        this.is_surface = true;
        this.terminal = terminal;
        this.width = terminal.width;
        this.height = terminal.height;
        this.autoresize = false;
        this.sprites = new Array();
    }

    @:allow(hase.display.Object.set_z)
    private function z_reorder():Void
    {
        this.sprites.sort(function(a:Sprite, b:Sprite) {
            return (a.z < b.z) ? -1 : (a.z > b.z) ? 1 : 0;
        });
    }

    @:allow(hase.display.Sprite.set_surface)
    private inline function register_sprite(sprite:Sprite):Sprite
    {
        this.sprites.push(sprite);
        this.z_reorder();
        return sprite;
    }

    @:allow(hase.display.Sprite.set_surface)
    private inline function unregister_sprite(sprite:Sprite):Sprite
    {
        this.sprites.remove(sprite);
        if (sprite.dirty_rect != null)
            this.redraw_rect(sprite.dirty_rect);
        return sprite;
    }

    @:allow(hase.display.Sprite.blit)
    private function redraw_rect(rect:Rect):Void
    {
        var render_rect:Rect = this.rect & rect;
        if (render_rect != null)
            this.terminal.renderer.render(render_rect, this.sprites);
    }
}
