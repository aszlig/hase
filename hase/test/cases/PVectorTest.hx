/* Copyright (C) 2013 aszlig
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

import hase.geom.PVector;

class PVectorTest extends haxe.unit.TestCase
{
    private inline function assert_vector(x:Float, y:Float, result:PVector):Void
    {
        this.assertEquals(x, result.x);
        this.assertEquals(y, result.y);
    }

    public function test_equality():Void
    {
        this.assertTrue(new PVector(10, 20) == new PVector(10, 20));
        this.assertFalse(new PVector(10, 20) == new PVector(20, 10));
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
}
