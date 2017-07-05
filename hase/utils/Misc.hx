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
package hase.utils;

private class RangeIter
{
    private var start:Int;
    private var end:Int;
    private var increment:Int;

    public function new(start:Int, end:Int, increment:Int)
    {
        this.start = start;
        this.end = end;
        this.increment = increment;
    }

    public inline function hasNext():Bool
        return this.increment > 0
             ? this.start < this.end
             : this.start > this.end;

    public inline function next():Int
    {
        var current:Int = this.start;
        this.start += this.increment;
        return current;
    }
}

class Misc
{
    public static function binomial(n:Int, k:Int):Int
    {
        var result:Float = 1;
        if (k < 0 || n < k) return 0;
        if (k == 0 || n == k) return 1;
        if (k > n - k) k = n - k;
        for (i in Misc.range(1, k))
            result *= (n - i + 1) / i;
        return Std.int(result);
    }

    public static inline function intabs(i:Int):Int
        return i < 0 ? -i : i;

    public static inline function signum(i:Int):Int
        return i < 0 ? -1 : i > 0 ? 1 : 0;

    public static inline function sigcmp(start:Int, end:Int):Int
        return start < end ? 1 : start > end ? -1 : 0;

    public static function
        range( start:Int, end:Int
             , increment:Int = null
             , inclusive:Bool = true
             ):RangeIter
    {
        var end_mod = inclusive ? 1 : 0;
        var real_end:Int = start <= end ? end + end_mod : end - end_mod;

        if (increment == null)
            increment = Misc.sigcmp(start, real_end);

        return new RangeIter(start, real_end, increment);
    }
}
