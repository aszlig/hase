/* Haxe ASCII Spriting Engine
 *
 * Copyright (C) 2017 aszlig
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
package hase.term.renderer;

import hase.display.Image;
import hase.display.Sprite;
import hase.geom.Rect;

class CharRenderer implements Interface
{
    private var terminal:hase.term.Interface;
    private var buffer:Image;

    @:allow(hase.term.Interface)
    private function new(term:hase.term.Interface)
    {
        this.terminal = term;
        this.buffer = Image.create(0, 0, " ".code, " ".code);
    }

    private function render(rect:Rect, sprites:Array<Sprite>):Void
    {
        this.buffer.clear();
        this.buffer.width = rect.width;
        this.buffer.height = rect.height;

        for (sprite in sprites) {
            if (sprite.dirty_rect == null || sprite.ascii == null)
                continue;

            var render_rect:Rect = sprite.render_rect;

            // intersection between redraw rectangle and current sprite
            var common:Null<Rect> = render_rect | rect;
            if (common == null)
                continue;

            // relative within redraw rectangle
            var rel_redraw_x:Int = common.x - rect.x;
            var rel_redraw_y:Int = common.y - rect.y;

            // relative within current sprite
            var rel_sprite_x:Int = common.x - render_rect.x;
            var rel_sprite_y:Int = common.y - render_rect.y;

            #if debug
            if (hase.utils.Debug.show_dirty_rects && sprite.is_dirty) {
                var name:String = Type.getClassName(Type.getClass(sprite));
                if (hase.utils.Debug.current_sprites.exists(name))
                    hase.utils.Debug.current_sprites[name]++;
                else
                    hase.utils.Debug.current_sprites[name] = 1;
            }
            #end

            for (y in rel_redraw_y...(rel_redraw_y + common.height)) {
                for (x in rel_redraw_x...(rel_redraw_x + common.width)) {
                    var sym:hase.display.Symbol = sprite.ascii.get(
                        rel_sprite_x + (x - rel_redraw_x),
                        rel_sprite_y + (y - rel_redraw_y)
                    );

                    if (!sym.is_alpha())
                        this.buffer.set(x, y, sym);
                }
            }
        }

        this.terminal.draw_area(rect, this.buffer);
    }
}
