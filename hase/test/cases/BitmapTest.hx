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

import hase.geom.Bitmap;
import hase.geom.Rect;

class BitmapTest extends haxe.unit.TestCase
{
    public function test_simple_even_set():Void
    {
        var map = new Bitmap(62, 62);
        map.set(17, 31);
        this.assertTrue(map.is_set(17, 31));
        this.assertFalse(map.is_set(16, 31));
        this.assertFalse(map.is_set(18, 31));
        this.assertFalse(map.is_set(17, 30));
        this.assertFalse(map.is_set(17, 32));
    }

    public function test_simple_even_unset():Void
    {
        var map = new Bitmap(62, 62);
        map.set(17, 31);
        map.set(18, 31);

        this.assertFalse(map.is_set(16, 31));
        this.assertTrue(map.is_set(17, 31));
        this.assertTrue(map.is_set(18, 31));
        this.assertFalse(map.is_set(19, 31));

        map.unset(17, 31);

        this.assertFalse(map.is_set(16, 31));
        this.assertFalse(map.is_set(17, 31));
        this.assertTrue(map.is_set(18, 31));
        this.assertFalse(map.is_set(19, 31));
    }

    public function test_simple_uneven_set():Void
    {
        var map = new Bitmap(61, 3);
        map.set(19, 1);
        this.assertTrue(map.is_set(19, 1));
        this.assertFalse(map.is_set(18, 1));
        this.assertFalse(map.is_set(20, 1));
        this.assertFalse(map.is_set(19, 0));
        this.assertFalse(map.is_set(19, 2));
    }

    public function test_simple_uneven_unset():Void
    {
        var map = new Bitmap(62, 3);
        map.set(19, 1);
        map.set(31, 1);
        map.set(32, 1);

        this.assertFalse(map.is_set(18, 1));
        this.assertTrue(map.is_set(19, 1));
        this.assertFalse(map.is_set(20, 1));
        this.assertFalse(map.is_set(30, 1));
        this.assertTrue(map.is_set(31, 1));
        this.assertTrue(map.is_set(32, 1));
        this.assertFalse(map.is_set(33, 1));

        map.unset(19, 1);
        map.unset(32, 1);

        this.assertFalse(map.is_set(18, 1));
        this.assertFalse(map.is_set(19, 1));
        this.assertFalse(map.is_set(20, 1));
        this.assertFalse(map.is_set(30, 1));
        this.assertTrue(map.is_set(31, 1));
        this.assertFalse(map.is_set(32, 1));
        this.assertFalse(map.is_set(33, 1));
    }

    public function test_out_of_bounds():Void
    {
        var map = new Bitmap(4, 4);

        map.set(3, 3);

        this.assertTrue(map.is_set(3, 3));

        for (x in 4...80) {
            for (y in 4...80) {
                map.set(x, y);
                this.assertFalse(map.is_set(x, y));
                map.unset(x, y);
                this.assertFalse(map.is_set(x, y));
            }
        }
    }

    public function test_simple_set_rect():Void
    {
        var map = new Bitmap(200, 200);

        map.set_rect(new Rect(50, 50, 100, 100));

        for (x in 0...200) {
            for (y in 0...200) {
                if (x < 50 || x > 149 || y < 50 || y > 149)
                    this.assertFalse(map.is_set(x, y));
                else
                    this.assertTrue(map.is_set(x, y));
            }
        }
    }

    public function test_set_rect_out_of_bounds():Void
    {
        var map = new Bitmap(10, 10);

        map.set_rect(new Rect(-20, -20, 40, 40));

        for (x in 0...40) {
            for (y in 0...40) {
                if (x >= 10 || y >= 10)
                    this.assertFalse(map.is_set(x, y));
                else
                    this.assertTrue(map.is_set(x, y));
            }
        }
    }

    public function test_set_rect_null():Void
    {
        var map = new Bitmap(0, 0);

        map.set_rect(new Rect(-5, -5, 10, 10));

        for (x in 0...40)
            for (y in 0...40)
                this.assertFalse(map.is_set(x, y));
    }

    private function assert_set_rect(bmx:Int, bmy:Int, rect:Rect):Void
    {
        var expected = new Bitmap(bmx, bmy);
        for (y in rect.top...rect.bottom)
            for (x in rect.left...rect.right)
                expected.set(x, y);

        var result = new Bitmap(bmx, bmy);
        result.set_rect(rect);

        for (y in 0...expected.width + 5) {
            for (x in 0...expected.height + 5) {
                if (expected.is_set(x, y))
                    this.assertTrue(result.is_set(x, y));
                else
                    this.assertFalse(result.is_set(x, y));
            }
        }
    }

    public function test_set_rect_with_reference():Void
    {
        this.assert_set_rect(10, 10, new Rect(-8, 1, 9, 0));
        this.assert_set_rect(31, 31, new Rect(25, 25, 6, 6));
        this.assert_set_rect(64, 64, new Rect(-8, 70, 9, 11));
    }
}
