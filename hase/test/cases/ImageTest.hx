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

        this.assertEquals(9, img.dirty_rect.x);
        this.assertEquals(1, img.dirty_rect.width);

        img.reset_dirty();

        img.width = 9;
        this.assertTrue(img.is_dirty);

        this.assertEquals(8, img.dirty_rect.x);
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

        this.assertEquals(9, img.dirty_rect.y);
        this.assertEquals(1, img.dirty_rect.height);

        img.reset_dirty();

        img.height = 9;
        this.assertTrue(img.is_dirty);

        this.assertEquals(8, img.dirty_rect.y);
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
