/* Haxe ASCII Spriting Engine
 *
 * Copyright (C) 2015-2017 aszlig
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

using hase.utils.Misc;

class MiscTest extends haxe.unit.TestCase
{
    public function test_binomial():Void
    {
        this.assertEquals(10, 5.binomial(3));
        this.assertEquals(120, 10.binomial(3));
        this.assertEquals(210, 10.binomial(4));
        this.assertEquals(45, 10.binomial(8));
        this.assertEquals(19600, 50.binomial(3));
    }

    public function test_binomial_ones():Void
    {
        this.assertEquals(1, 5.binomial(5));
        this.assertEquals(1, 9.binomial(0));
    }

    public function test_binomial_zeroes():Void
    {
        this.assertEquals(0, 2.binomial(3));
        this.assertEquals(0, (-1).binomial(3));
        this.assertEquals(0, 2.binomial(-1));
    }

    public function test_intabs():Void
    {
        this.assertEquals(0, 0.intabs());
        this.assertEquals(3, 3.intabs());
        this.assertEquals(3, (-3).intabs());
        this.assertEquals(1024, (-1024).intabs());
    }

    public function test_signum():Void
    {
        this.assertEquals(0, 0.signum());
        this.assertEquals(1, 3.signum());
        this.assertEquals(-1, (-3).signum());
        this.assertEquals(-1, (-1024).signum());
    }

    public function test_sigcmp():Void
    {
        this.assertEquals(0, 0.sigcmp(0));
        this.assertEquals(1, 5.sigcmp(10));
        this.assertEquals(-1, 10.sigcmp(5));
    }

    private function assert_range(expect:Array<Int>, result:Iterator<Int>)
    {
        var str_result:String = [for (i in result) i].toString();
        this.assertEquals(expect.toString(), str_result);
    }

    public function test_range_singleton():Void
    {
        this.assert_range([], 4.range(4, null, false));
        this.assert_range([4], 4.range(4));
    }

    public function test_range_exclusive():Void
    {
        this.assert_range([0, 1, 2, 3, 4], 0.range(5, null, false));
        this.assert_range([5, 4, 3, 2, 1], 5.range(0, null, false));
    }

    public function test_range_inclusive():Void
    {
        this.assert_range([0, 1, 2, 3, 4, 5], 0.range(5));
        this.assert_range([5, 4, 3, 2, 1, 0], 5.range(0));
    }

    public function test_range_negative():Void
    {
        this.assert_range([0, -1, -2, -3, -4, -5], 0.range(-5));
        this.assert_range([-2, -3, -4, -5, -6], (-2).range(-7, null, false));
    }

    public function test_range_custom_increment():Void
    {
        this.assert_range([0, 2, 4], 0.range(5, 2, true));
        this.assert_range([0, 2, 4], 0.range(6, 2, false));
        this.assert_range([0, 2, 4, 6], 0.range(6, 2, true));
        this.assert_range([0, -2, -4], 0.range(-5, -2, true));
    }

    public function test_range_invalid():Void
    {
        this.assert_range([], 0.range(-5, 2, true));
        this.assert_range([], 0.range(5, -2, true));
        this.assert_range([], (-5).range(0, -2, false));
        this.assert_range([], 5.range(0, 2, false));
        this.assert_range([], 0.range(5, 0, false));
    }

    public function test_rad2deg():Void
    {
        this.assertEquals(0.0,   0.rad2deg());
        this.assertEquals(3000,  Std.int(0.5235987756.rad2deg() * 100.0));
        this.assertEquals(4500,  Std.int(0.7853981634.rad2deg() * 100.0));
        this.assertEquals(6000,  Std.int(1.0471975512.rad2deg() * 100.0));
        this.assertEquals(9000,  Std.int(1.5707963268.rad2deg() * 100.0));
        this.assertEquals(12000, Std.int(2.0943951024.rad2deg() * 100.0));
        this.assertEquals(13500, Std.int(2.3561944902.rad2deg() * 100.0));
        this.assertEquals(15000, Std.int(2.6179938780.rad2deg() * 100.0));
        this.assertEquals(18000, Std.int(3.1415926536.rad2deg() * 100.0));
        this.assertEquals(27000, Std.int(4.7123889804.rad2deg() * 100.0));
        this.assertEquals(36000, Std.int(6.2831853072.rad2deg() * 100.0));
    }

    public function test_deg2rad():Void
    {
        this.assertEquals(0.0, 0.deg2rad());
        this.assertEquals(52,  Std.int(30.deg2rad()  * 100.0));
        this.assertEquals(78,  Std.int(45.deg2rad()  * 100.0));
        this.assertEquals(104, Std.int(60.deg2rad()  * 100.0));
        this.assertEquals(157, Std.int(90.deg2rad()  * 100.0));
        this.assertEquals(209, Std.int(120.deg2rad() * 100.0));
        this.assertEquals(235, Std.int(135.deg2rad() * 100.0));
        this.assertEquals(261, Std.int(150.deg2rad() * 100.0));
        this.assertEquals(314, Std.int(180.deg2rad() * 100.0));
        this.assertEquals(471, Std.int(270.deg2rad() * 100.0));
        this.assertEquals(628, Std.int(360.deg2rad() * 100.0));
    }
}
