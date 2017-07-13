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
package hase.test.cases;

import hase.display.Image;
import hase.display.Symbol;

class ImageTest extends haxe.unit.TestCase
{
    public function test_reset_dirty():Void
    {
        var img = Image.create(10, 10, new Symbol("x".code));
        this.assertTrue(img.is_dirty);
        img.reset_dirty();
        this.assertFalse(img.is_dirty);
    }

    public function test_set_width():Void
    {
        var img = Image.create(10, 10, new Symbol("x".code));
        img.reset_dirty();

        img.width = 10;
        this.assertFalse(img.is_dirty);

        img.width = 11;
        this.assertTrue(img.is_dirty);

        this.assertEquals(10, img.dirty_rect.x);
        this.assertEquals(1, img.dirty_rect.width);

        img.reset_dirty();

        img.width = 9;
        this.assertTrue(img.is_dirty);

        this.assertEquals(9, img.dirty_rect.x);
        this.assertEquals(2, img.dirty_rect.width);
    }

    public function test_set_height():Void
    {
        var img = Image.create(10, 10, new Symbol("x".code));
        img.reset_dirty();

        img.height = 10;
        this.assertFalse(img.is_dirty);

        img.height = 11;
        this.assertTrue(img.is_dirty);

        this.assertEquals(10, img.dirty_rect.y);
        this.assertEquals(1, img.dirty_rect.height);

        img.reset_dirty();

        img.height = 9;
        this.assertTrue(img.is_dirty);

        this.assertEquals(9, img.dirty_rect.y);
        this.assertEquals(2, img.dirty_rect.height);
    }

    public function test_set_single():Void
    {
        var img = Image.create(10, 10, new Symbol("x".code));
        img.reset_dirty();

        img.set(5, 5, new Symbol("y".code));
        this.assertTrue(img.is_dirty);
        img.set(4, 3, new Symbol("z".code));
        this.assertTrue(img.is_dirty);

        img.map_(function(x:Int, y:Int, sym:Symbol) {
            if (x == 5 && y == 5)
                this.assertEquals(new Symbol("y".code), sym);
            else if (x == 4 && y == 3)
                this.assertEquals(new Symbol("z".code), sym);
            else
                this.assertEquals(new Symbol("x".code), sym);
        });

        this.assertEquals(4, img.dirty_rect.x);
        this.assertEquals(3, img.dirty_rect.y);
        this.assertEquals(2, img.dirty_rect.width);
        this.assertEquals(3, img.dirty_rect.height);
    }

    public function test_clear():Void
    {
        var img = Image.create(10, 10, new Symbol("x".code));
        img.reset_dirty();

        img.clear(new Symbol("y".code));

        this.assertTrue(img.is_dirty);

        img.map_(function(x:Int, y:Int, sym:Symbol) {
            this.assertEquals(new Symbol("y".code), sym);
        });

        this.assertEquals(0, img.dirty_rect.x);
        this.assertEquals(0, img.dirty_rect.y);
        this.assertEquals(10, img.dirty_rect.width);
        this.assertEquals(10, img.dirty_rect.height);
    }
}
