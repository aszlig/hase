/* Haxe ASCII Spriting Engine
 *
 * Copyright (C) 2013-2017 aszlig
 *
 * This program is free software: you can redistribute it and/or modify it
 * under the terms of the GNU Affero General Public License, version 3, as
 * published by the Free Software Foundation.
 *
 * This program is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 * FITNESS FOR A PARTICULAR PURPOSE. See the GNU Affero General Public License
 * for more details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
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
        return this.ascii = this.mark_dirty(this.ascii, val);

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

        if (this.ascii.dirty_rect.width == 0 ||
            this.ascii.dirty_rect.height == 0)
            return;

        if (!this.is_dirty && !this.ascii.is_dirty)
            return;

        var new_rect:Rect = this.render_rect;

        if (this.dirty_rect != null) {
            new_rect.x += this.ascii.dirty_rect.x;
            new_rect.y += this.ascii.dirty_rect.y;
            new_rect.width = this.ascii.dirty_rect.width;
            new_rect.height = this.ascii.dirty_rect.height;
            if (this.is_dirty)
                new_rect.union_(this.dirty_rect);
        }

        this.surface.register_redraw(new_rect);
        this.dirty_rect = this.render_rect;

        this.is_dirty = false;
        this.ascii.reset_dirty();
    }
}
