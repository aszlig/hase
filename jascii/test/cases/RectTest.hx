package jascii.test.cases;

import jascii.geom.Rect;

class RectTest extends haxe.unit.TestCase
{
    public function test_union_horizontal():Void
    {
        var r1:Rect = new Rect(10, 10, 20, 20);
        var r2:Rect = new Rect(5, 3, 3, 30);

        var result:Rect = r1.union(r2);

        this.assertEquals(5, result.x);
        this.assertEquals(3, result.y);
        this.assertEquals(25, result.width);
        this.assertEquals(30, result.height);
    }

    public function test_union_vertical():Void
    {
        var r1:Rect = new Rect(1, 11, 20, 20);
        var r2:Rect = new Rect(5, 3, 30, 1);

        var result:Rect = r1.union(r2);

        this.assertEquals(1, result.x);
        this.assertEquals(3, result.y);
        this.assertEquals(34, result.width);
        this.assertEquals(28, result.height);
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

        for (x in 3...7) for (y in 3...7) for (w in 3...7) for (h in 3...7)
            if (x == 5 && y == 5 && w == 5 && h == 5)
                this.assertTrue(r.matches(new Rect(x, y, w, h)));
            else
                this.assertFalse(r.matches(new Rect(x, y, w, h)));
    }
}
