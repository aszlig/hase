package hase.test.cases;

import hase.geom.PVector;

class PVectorTest extends haxe.unit.TestCase
{
    private inline function assert_vector(x:Float, y:Float, result:PVector):Void
    {
        this.assertEquals(x, result.x);
        this.assertEquals(y, result.y);
    }

    public function test_simple_math():Void
    {
        var v1:PVector = new PVector(5, 4);
        var v2:PVector = new PVector(3, 2);

        this.assert_vector( 8, 6, v1 + v2);
        this.assert_vector( 2, 2, v1 - v2);
        this.assert_vector(15, 8, v1 * v2);
    }

    public function test_multiply_float():Void
    {
        var v:PVector = new PVector(5, 4);

        this.assert_vector( 15,  12, v *  3.0);
        this.assert_vector(-15, -12, v * -3.0);
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
        var v:PVector = new PVector(vx, vy);
        v.normalize();
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
