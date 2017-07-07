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
package hase.test.cases;

import hase.geom.Rect;
import hase.geom.PVector;

class RectTest extends haxe.unit.TestCase
{
    public function test_union_horizontal():Void
    {
        var r1:Rect = new Rect(10, 10, 20, 20);
        var r2:Rect = new Rect(5, 3, 3, 30);

        var result:Rect = r1 & r2;

        this.assertEquals(5, result.x);
        this.assertEquals(3, result.y);
        this.assertEquals(25, result.width);
        this.assertEquals(30, result.height);
    }

    public function test_union_vertical():Void
    {
        var r1:Rect = new Rect(1, 11, 20, 20);
        var r2:Rect = new Rect(5, 3, 30, 1);

        var result:Rect = r1 & r2;

        this.assertEquals(1, result.x);
        this.assertEquals(3, result.y);
        this.assertEquals(34, result.width);
        this.assertEquals(28, result.height);
    }

    public function test_impure_union():Void
    {
        var result = new Rect(1, 1, 1, 1);

        for (i in 1...11)
            result.union_(new Rect(i, i, 1, 1));

        this.assertEquals(1, result.x);
        this.assertEquals(1, result.y);
        this.assertEquals(10, result.width);
        this.assertEquals(10, result.height);
    }

    public function test_intersects_horizontal():Void
    {
        var r:Rect = new Rect(5, 0, 10, 10);
        this.assertFalse(r.intersects(new Rect(0, 0, 5, 10)));
        this.assertTrue(r.intersects(new Rect(1, 0, 5, 10)));
        this.assertTrue(r.intersects(new Rect(1, 9, 5, 10)));
        this.assertFalse(r.intersects(new Rect(1, 10, 5, 10)));
    }

    public function test_intersects_vertical():Void
    {
        var r:Rect = new Rect(5, 5, 10, 10);
        this.assertFalse(r.intersects(new Rect(5, 15, 5, 11)));
        this.assertTrue(r.intersects(new Rect(5, 14, 5, 11)));
        this.assertTrue(r.intersects(new Rect(14, 14, 5, 11)));
        this.assertFalse(r.intersects(new Rect(15, 14, 5, 11)));
    }

    public function test_intersects_inner():Void
    {
        var r:Rect = new Rect(5, 5, 5, 5);
        this.assertTrue(r.intersects(new Rect(5, 5, 5, 5)));
        this.assertTrue(r.intersects(new Rect(0, 0, 15, 15)));
        this.assertTrue(r.intersects(new Rect(6, 0, 3, 15)));
        this.assertTrue(r.intersects(new Rect(0, 6, 15, 3)));
        this.assertFalse(r.intersects(new Rect(0, 10, 15, 15)));
        this.assertFalse(r.intersects(new Rect(10, 0, 15, 15)));
        this.assertTrue(r.intersects(new Rect(0, 9, 15, 15)));
        this.assertTrue(r.intersects(new Rect(9, 0, 15, 15)));
    }

    public function test_matches():Void
    {
        var r:Rect = new Rect(5, 5, 5, 5);

        for (x in 3...7) for (y in 3...7) for (w in 3...7) for (h in 3...7) {
            if (x == 5 && y == 5 && w == 5 && h == 5) {
                this.assertFalse(r != new Rect(x, y, w, h));
                this.assertTrue(r == new Rect(x, y, w, h));
            } else {
                this.assertFalse(r == new Rect(x, y, w, h));
                this.assertTrue(r != new Rect(x, y, w, h));
            }
        }
    }

    public function test_matches_null():Void
    {
        var r:Rect = new Rect(5, 5, 5, 5);
        this.assertFalse(r == null);
        this.assertTrue(r != null);
    }

    public function test_intersection_area_diagonal():Void
    {
        var r1:Rect = new Rect(8, 8, 4, 4);
        var r2:Rect = new Rect(10, 10, 8, 8);

        var result:Null<Rect> = r1 | r2;

        this.assertEquals(10, result.x);
        this.assertEquals(10, result.y);
        this.assertEquals(2, result.width);
        this.assertEquals(2, result.height);
    }

    public function test_intersection_area_vertical():Void
    {
        var r1:Rect = new Rect(4, 4, 4, 4);
        var r2:Rect = new Rect(4, 7, 4, 4);

        var result:Null<Rect> = r1 | r2;

        this.assertEquals(4, result.x);
        this.assertEquals(7, result.y);
        this.assertEquals(4, result.width);
        this.assertEquals(1, result.height);
    }

    public function test_intersection_area_horizontal():Void
    {
        var r1:Rect = new Rect(4, 4, 4, 4);
        var r2:Rect = new Rect(7, 4, 4, 4);

        var result:Null<Rect> = r1 | r2;

        this.assertEquals(7, result.x);
        this.assertEquals(4, result.y);
        this.assertEquals(1, result.width);
        this.assertEquals(4, result.height);
    }

    public function test_intersection_area_overlap():Void
    {
        var r1:Rect = new Rect(4, 4, 4, 4);
        var r2:Rect = new Rect(4, 4, 4, 4);

        var result:Null<Rect> = r1 | r2;

        this.assertEquals(4, result.x);
        this.assertEquals(4, result.y);
        this.assertEquals(4, result.width);
        this.assertEquals(4, result.height);
    }

    public function test_intersection_area_none():Void
    {
        var r1:Rect = new Rect(0, 0, 2, 2);
        var r2:Rect = new Rect(5, 5, 2, 2);
        this.assertEquals(null, r1 | r2);
    }

    public function test_impure_intersection():Void
    {
        var result = new Rect(5, 5, 10, 10);

        for (i in 1...10)
            result.intersection_(new Rect(0, 0, i, i));

        this.assertEquals(5, result.x);
        this.assertEquals(5, result.y);
        this.assertEquals(1, result.width);
        this.assertEquals(1, result.height);
    }

    public function test_contains():Void
    {
        var r:Rect = new Rect(5, 5, 5, 5);

        this.assertTrue(r.contains(5, 5));
        this.assertFalse(r.contains(4, 4));
        this.assertTrue(r.contains(9, 9));
        this.assertFalse(r.contains(10, 10));

        this.assertFalse(r.contains(0, 0));
        this.assertFalse(r.contains(5, 4));
        this.assertFalse(r.contains(4, 5));

        this.assertFalse(r.contains(15, 15));
        this.assertFalse(r.contains(10, 11));
        this.assertFalse(r.contains(11, 10));

        this.assertTrue(r.contains(5, 9));
        this.assertTrue(r.contains(9, 5));
        this.assertTrue(r.contains(7, 7));
    }

    public function
        assert_vec(x:Float, y:Float, r1:Rect, r2:Rect, ?pi:haxe.PosInfos):Void
    {
        this.currentTest.done = true;

        var dv:PVector = Rect.distance_to(r1, r2);

        if (new PVector(x, y) != dv) {
            this.currentTest.success = false;
            this.currentTest.error = 'expected PVector (${x},${y}) but '
                                   + 'got PVector (${dv.x},${dv.y}) instead';
            this.currentTest.posInfos = pi;
            throw this.currentTest;
        }
    }

    public function test_distance():Void
    {
        var r:Rect = new Rect(5, 5, 5, 5);
        this.assert_vec(  0,   0, r, new Rect(  5,   5,  5,  5));
        this.assert_vec(  5,   5, r, new Rect( 15,  15,  5,  5));
        this.assert_vec(-10, -10, r, new Rect(-10, -10,  5,  5));
        this.assert_vec( -5,  -5, r, new Rect(-10, -10, 10, 10));
        this.assert_vec(  0,   0, r, new Rect(  2,   2,  3,  3));
        this.assert_vec( -1,  -1, r, new Rect(  2,   2,  2,  2));
        this.assert_vec(  1,   1, r, new Rect( 11,  11,  2,  2));
        this.assert_vec(  0,   5, r, new Rect(  5,  15,  5,  5));
        this.assert_vec(  0, -15, r, new Rect(  5, -15,  5,  5));
        this.assert_vec(  5,   0, r, new Rect( 15,   5,  5,  5));
        this.assert_vec(-15,   0, r, new Rect(-15,   5,  5,  5));
    }

    public function test_includes():Void
    {
        var r:Rect = new Rect(5, 5, 5, 5);

        this.assertFalse(r > new Rect(5, 5, 5, 5));
        this.assertTrue(r > new Rect(6, 6, 3, 3));
        this.assertFalse(r > new Rect(6, 5, 3, 4));
        this.assertFalse(r > new Rect(5, 6, 4, 3));
        this.assertFalse(r > new Rect(6, 6, 3, 4));
        this.assertFalse(r > new Rect(6, 6, 4, 3));

        this.assertFalse(new Rect(5, 5, 5, 5) < r);
        this.assertTrue(new Rect(6, 6, 3, 3) < r);
        this.assertFalse(new Rect(6, 5, 3, 4) < r);
        this.assertFalse(new Rect(5, 6, 4, 3) < r);
        this.assertFalse(new Rect(6, 6, 3, 4) < r);
        this.assertFalse(new Rect(6, 6, 4, 3) < r);
    }

    public function test_includes_match():Void
    {
        var r:Rect = new Rect(5, 5, 5, 5);

        this.assertTrue(r >= new Rect(5, 5, 5, 5));
        this.assertTrue(r >= new Rect(6, 6, 4, 4));
        this.assertFalse(r >= new Rect(6, 4, 4, 6));
        this.assertFalse(r >= new Rect(4, 6, 6, 4));
        this.assertFalse(r >= new Rect(6, 6, 5, 4));
        this.assertFalse(r >= new Rect(6, 6, 4, 5));

        this.assertTrue(new Rect(5, 5, 5, 5) <= r);
        this.assertTrue(new Rect(6, 6, 4, 4) <= r);
        this.assertFalse(new Rect(6, 4, 4, 6) <= r);
        this.assertFalse(new Rect(4, 6, 6, 4) <= r);
        this.assertFalse(new Rect(6, 6, 5, 4) <= r);
        this.assertFalse(new Rect(6, 6, 4, 5) <= r);
    }
}
