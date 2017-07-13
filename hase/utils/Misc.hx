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
