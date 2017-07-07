/* Copyright (C) 2017 aszlig
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

            // intersection between redraw rectangle and current sprite
            var common:Null<Rect> = sprite.dirty_rect | rect;
            if (common == null)
                continue;

            // relative within redraw rectangle
            var rel_redraw_x:Int = common.x - rect.x;
            var rel_redraw_y:Int = common.y - rect.y;

            // relative within current sprite
            var rel_sprite_x:Int = common.x - sprite.dirty_rect.x;
            var rel_sprite_y:Int = common.y - sprite.dirty_rect.y;

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
