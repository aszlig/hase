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
package hase.test.cases;

import hase.geom.PVector;

class PVectorTest extends haxe.unit.TestCase
{
    private inline function
        assert_vector(x:Float, y:Float, result:PVector):Void
    {
        this.assertEquals(x, Math.round(result.x));
        this.assertEquals(y, Math.round(result.y));
    }

    public function test_equality():Void
    {
        this.assertTrue(new PVector(10, 20) == new PVector(10, 20));
        this.assertFalse(new PVector(10, 20) == new PVector(20, 10));
        this.assertFalse(new PVector(10, 20) != new PVector(10, 20));
        this.assertTrue(new PVector(10, 20) != new PVector(20, 10));
    }

    public function test_lower_than():Void
    {
        this.assertTrue( new PVector( 9,  9) < new PVector(10, 10));
        this.assertFalse(new PVector(10,  9) < new PVector(10, 10));
        this.assertFalse(new PVector( 9, 10) < new PVector(10, 10));
        this.assertFalse(new PVector(10, 10) < new PVector(10, 10));
        this.assertFalse(new PVector(11, 11) < new PVector(10, 10));
    }

    public function test_lower_equal():Void
    {
        this.assertTrue( new PVector( 9,  9) <= new PVector(10, 10));
        this.assertTrue( new PVector(10,  9) <= new PVector(10, 10));
        this.assertTrue( new PVector( 9, 10) <= new PVector(10, 10));
        this.assertTrue( new PVector(10, 10) <= new PVector(10, 10));
        this.assertFalse(new PVector(11, 11) <= new PVector(10, 10));
    }

    public function test_greater_than():Void
    {
        this.assertTrue( new PVector(10, 10) > new PVector( 9,  9));
        this.assertFalse(new PVector(10, 10) > new PVector(10,  9));
        this.assertFalse(new PVector(10, 10) > new PVector( 9, 10));
        this.assertFalse(new PVector(10, 10) > new PVector(10, 10));
        this.assertFalse(new PVector(10, 10) > new PVector(11, 11));
    }

    public function test_greater_equal():Void
    {
        this.assertTrue( new PVector(10, 10) >= new PVector( 9,  9));
        this.assertTrue( new PVector(10, 10) >= new PVector(10,  9));
        this.assertTrue( new PVector(10, 10) >= new PVector( 9, 10));
        this.assertTrue( new PVector(10, 10) >= new PVector(10, 10));
        this.assertFalse(new PVector(10, 10) >= new PVector(11, 11));
    }

    public function test_simple_math():Void
    {
        var v1:PVector = new PVector(5, 4);
        var v2:PVector = new PVector(3, 2);

        this.assert_vector( 8, 6, v1 + v2);
        this.assert_vector( 2, 2, v1 - v2);
    }

    public function test_multiply_float():Void
    {
        var v:PVector = new PVector(5, 4);

        this.assert_vector( 15,  12, v *  3.0);
        this.assert_vector(-15, -12, v * -3.0);
    }

    public function test_divide_float():Void
    {
        var v:PVector = new PVector(24, 12);

        this.assert_vector(6, 3, new PVector(24, 12) / 4);
        this.assert_vector(3, 10, new PVector(9, 30) / 3);
    }

    public function test_negate():Void
    {
        var v:PVector = new PVector(5, 4);

        this.assert_vector(-5, -4, -v);
        this.assert_vector( 5,  4, -(-v));
    }

    public function test_dot_product():Void
    {
        var v1:PVector = new PVector(5, 4);
        var v2:PVector = new PVector(3, 2);

        this.assertEquals(23.0, v1.dot_product(v2));
        this.assertEquals(46.0, v1.dot_product(v2 * 2.0));
        this.assertEquals(69.0, v1.dot_product(v2 * 3.0));
    }

    public function test_cross_product():Void
    {
        var v1:PVector = new PVector(5, 4);
        var v2:PVector = new PVector(3, 2);

        this.assertEquals(-2.0, v1.cross_product(v2));
        this.assertEquals(-4.0, v1.cross_product(v2 * 2.0));
        this.assertEquals(-6.0, v1.cross_product(v2 * 3.0));
    }

    public function test_set():Void
    {
        var v:PVector = new PVector(10, 20);

        v.x = 12.0;
        this.assertEquals(12.0, v.x);
        this.assertEquals(14.0, v.x = 14.0);

        v.y = 22.0;
        this.assertEquals(22.0, v.y);
        this.assertEquals(24.0, v.y = 24.0);

        v.set(15.0, 25.0);
        this.assert_vector(15.0, 25.0, v);
        this.assert_vector(16.0, 26.0, v.set(16.0, 26.0));

        v.set_from_vector(new PVector(17.0, 27.0));
        this.assert_vector(17.0, 27.0, v);
        this.assert_vector(18.0, 28.0,
                           v.set_from_vector(new PVector(18.0, 28.0)));
    }

    public inline function
        assert_normalized(x:Float, y:Float, vx:Float, vy:Float):Void
    {
        var v:PVector = new PVector(vx, vy).normalize();
        this.assertEquals(Math.round(x * 10000)   / 10000,
                          Math.round(v.x * 10000) / 10000);
        this.assertEquals(Math.round(y * 10000)   / 10000,
                          Math.round(v.y * 10000) / 10000);
    }

    public function test_normalize():Void
    {
        this.assert_normalized(1, 0, 2, 0);
        this.assert_normalized(0, 1, 0, 2);

        this.assert_normalized(0.4961, 0.8682, 0.4, 0.7);
        this.assert_normalized(0.2425, 0.9701, 0.2, 0.8);
        this.assert_normalized(0.9939, 0.1104, 0.9, 0.1);
        this.assert_normalized(0.8944, 0.4472, 0.6, 0.3);

        this.assert_normalized( 0.6247,  0.7809,  4,  5);
        this.assert_normalized( 0.6247, -0.7809,  4, -5);
        this.assert_normalized(-0.6247,  0.7809, -4,  5);
        this.assert_normalized(-0.6247, -0.7809, -4, -5);
    }

    public function test_normalize_div_zero():Void
    {
        this.assert_vector(0, 0, new PVector(0, 0).normalize());
    }

    public function test_normalize_no_mutate():Void
    {
        var orig = new PVector(1, 0);
        orig.normalize().y = 10;
        this.assert_vector(1, 0, orig);
    }

    public function test_length():Void
    {
        this.assertEquals(0.0,  new PVector(0, 0).length);
        this.assertEquals(10.0, new PVector(10, 0).length);
        this.assertEquals(10.0, new PVector(0, 10).length);
        this.assertEquals(10.0, new PVector(-10, 0).length);
        this.assertEquals(10.0, new PVector(0, -10).length);
        this.assertEquals(5.0,  new PVector(3, 4).length);
        this.assertEquals(5.0,  new PVector(4, 3).length);
    }

    private function
        assert_dist(expect:Int, x1:Float, y1:Float, x2:Float, y2:Float):Void
    {
        var v1 = new PVector(x1, y1);
        var v2 = new PVector(x2, y2);
        return this.assertEquals(expect, Math.floor(v1.distance_to(v2)));
    }

    public function test_distance():Void
    {
        this.assert_dist(1,   9,  2, 10,  3);
        this.assert_dist(15, 11,  0,  0, 11);
        this.assert_dist(10,  1,  0, 11,  0);
        this.assert_dist(5,   6,  1,  6,  6);
        this.assert_dist(5,  -5, -5, -5,  0);
    }

    public function test_rotate():Void
    {
        var v:PVector = new PVector(10, 10);

        this.assert_vector(-10, -10, v.rotate(Math.PI));
        this.assert_vector( 10,  10, v.rotate(Math.PI * 2));
        this.assert_vector(-10,  10, v.rotate(Math.PI / 2));
        this.assert_vector(  0,  14, v.rotate(Math.PI / 4));

        this.assert_vector(-10, -10, v.rotate(-Math.PI));
        this.assert_vector( 10,  10, v.rotate(-Math.PI * 2));
        this.assert_vector( 10, -10, v.rotate(-Math.PI / 2));
        this.assert_vector( 14,   0, v.rotate(-Math.PI / 4));

        this.assert_vector(-10, -10, v.rotate_deg(180));
        this.assert_vector( -6,  13, v.rotate_deg(70));
        this.assert_vector(-14,   4, v.rotate_deg(120));
        this.assert_vector( 10, -10, v.rotate_deg(270));
    }
}
