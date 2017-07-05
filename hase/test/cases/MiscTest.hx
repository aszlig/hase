/* Copyright (C) 2015-2017 aszlig
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
