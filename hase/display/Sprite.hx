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

    @:allow(hase.display.Surface)
    @:allow(hase.term.renderer.Interface)
    private var dirty_rect(default, null):Rect;

    public function new()
    {
        super();
        this.ascii = null;
        this.dirty_rect = null;
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

    public override function update(td:Float):Void
    {
        super.update(td);

        if (!this.is_dirty || this.ascii == null || this.surface == null)
            return;

        var width:Int = this.ascii.width;
        var height:Int = this.ascii.height;

        var redraw_rect:Rect = this.dirty_rect;
        this.dirty_rect = new Rect(
            this.absolute_x - this.center_x,
            this.absolute_y - this.center_y,
            width, height
        );

        this.surface.register_redraw(
            redraw_rect == null ? this.dirty_rect
                                : redraw_rect.union(this.dirty_rect)
        );

        this.is_dirty = false;
    }
}
