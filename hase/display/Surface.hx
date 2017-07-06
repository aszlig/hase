/* Copyright (C) 2013-2017 aszlig
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

    private var dirties:Array<Rect>;
    private var dirty_idx:Int;

    public function new(terminal:hase.term.Interface)
    {
        super();
        this.is_surface = true;
        this.terminal = terminal;
        this.width = terminal.width;
        this.height = terminal.height;
        this.autoresize = false;
        this.sprites = new Array();

        this.dirties = new Array();
        this.dirty_idx = 0;
    }

    @:allow(hase.display.Object.set_z)
    private function z_reorder():Void
    {
        haxe.ds.ArraySort.sort(this.sprites, function(a:Sprite, b:Sprite) {
            return hase.utils.Misc.sigcmp(b.z, a.z);
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
            this.register_redraw(sprite.dirty_rect);
        return sprite;
    }

    @:allow(hase.display.Sprite.update)
    private function register_redraw(rect:Rect):Void
    {
        for (i in 0...this.dirty_idx) {
            if (this.dirties[i].intersects(rect)) {
                this.dirties[i] = this.dirties[i].union(rect);
                return;
            }
        }

        if (this.dirties.length <= this.dirty_idx)
            this.dirties.push(rect);
        else
            this.dirties[this.dirty_idx] = rect;
        this.dirty_idx++;
    }

    public override function update(td:Float):Void
    {
        super.update(td);

        for (i in 0...this.dirty_idx) {
            if (this.dirties[i].impure_intersect_(this.rect))
                this.terminal.renderer.render(this.dirties[i], this.sprites);
        }

        this.dirty_idx = 0;
    }
}
