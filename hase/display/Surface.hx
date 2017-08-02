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

class Surface extends Object
{
    public var terminal(default, null):hase.term.Interface;

    private var sprites:hase.ds.LinkedList<Sprite>;

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
        this.sprites = new hase.ds.LinkedList();

        this.dirties = new Array();
        this.dirty_idx = 0;
    }

    @:allow(hase.display.Object.set_z)
    private function z_reorder():Void
    {
        this.sprites.sort(
            function(a:Sprite, b:Sprite)
                return hase.utils.Misc.sigcmp(b.z, a.z)
        );
    }

    @:allow(hase.display.Sprite.set_surface)
    private inline function register_sprite(sprite:Sprite):Sprite
    {
        this.sprites.add(sprite);
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
                this.dirties[i] &= rect;
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
