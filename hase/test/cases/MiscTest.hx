/* Copyright (C) 2015 aszlig
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
}
