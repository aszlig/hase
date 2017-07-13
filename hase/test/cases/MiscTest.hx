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
}
