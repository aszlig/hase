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

class Sprite extends Object
{
    public var ascii(default, set):Image;
    public var rect(default, null):Rect;

    public function new()
    {
        super();
        this.ascii = null;
        this.rect = null;
    }

    private inline function set_ascii(val:Image):Image
        return this.ascii = this.set_dirty(this.ascii, val);

    private override function set_surface(val:Surface):Surface
    {
        if (val != null)
            val.register_sprite(this);
        else if (this.surface != null)
            this.surface.unregister_sprite(this);

        return super.set_surface(val);
    }

    public function blit():Void
    {
        if (!this.is_dirty || this.ascii == null)
            return;

        var width:Int = this.ascii.width;
        var height:Int = this.ascii.height;

        var old_rect:Rect = this.rect;
        this.rect = new Rect(
            this.parent.absolute_x + this.x - this.center_x,
            this.parent.absolute_y + this.y - this.center_y,
            width, height
        );

        old_rect = old_rect == null ? this.rect : old_rect.union(this.rect);
        this.surface.redraw_rect(old_rect);

        this.is_dirty = false;
    }

    public override function update(td:Float):Void
    {
        super.update(td);
        this.blit();
    }
}