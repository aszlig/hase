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

class Sprite extends Object
{
    public var ascii(default, set):Image;

    public var dirty_rect(default, null):Rect;
    public var render_rect(get, null):Rect;

    public function new()
    {
        super();
        this.ascii = null;
        this.dirty_rect = null;
    }

    private inline function set_ascii(val:Image):Image
        return this.ascii = this.set_dirty(this.ascii, val);

    private inline function get_render_rect():Rect
    {
        return new Rect(
            this.absolute_x - this.center_x,
            this.absolute_y - this.center_y,
            this.ascii.width, this.ascii.height
        );
    }

    private override function set_surface(val:Surface):Surface
    {
        if (val != null)
            val.register_sprite(this);
        else if (this.surface != null)
            this.surface.unregister_sprite(this);

        return super.set_surface(val);
    }

    public override function update(td:Float):Void
    {
        super.update(td);

        if (this.ascii == null || this.surface == null)
            return;

        if (!this.is_dirty && !this.ascii.is_dirty)
            return;

        var new_rect:Rect = this.render_rect;

        if (this.dirty_rect != null) {
            if (this.is_dirty) {
                new_rect.union_(this.dirty_rect);
            } else {
                new_rect.x += this.ascii.dirty_rect.x;
                new_rect.y += this.ascii.dirty_rect.y;
                new_rect.width = this.ascii.dirty_rect.width;
                new_rect.height = this.ascii.dirty_rect.height;
            }
        }

        this.surface.register_redraw(new_rect);
        this.dirty_rect = this.render_rect;

        this.is_dirty = false;
        this.ascii.reset_dirty();
    }
}
