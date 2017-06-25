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
package hase.geom;

using hase.utils.Misc;

abstract Path (Array<PVector>)
{
    public var length(get, never):Float;

    public inline function new(?path:Array<PVector>)
        this = path == null ? new Array() : path;

    private function bresenham( from:PVector, to:PVector
                              , f:Int -> Int -> Void
                              , is_cont:Bool = false
                              ):Void
    {
        var x:Int = Math.round(from.x);
        var y:Int = Math.round(from.y);

        var end_x:Int = Math.round(to.x);
        var end_y:Int = Math.round(to.y);

        var diff_x:Int = (x - end_x).intabs();
        var diff_y:Int = -(y - end_y).intabs();

        var error:Int = diff_x + diff_y;

        while (true) {
            if (is_cont)
                is_cont = false;
            else
                f(x, y);

            if (x == end_x && y == end_y)
                break;

            var eshift:Int = error << 1;

            if (eshift < diff_x) {
                error += diff_x;
                y += y.sigcmp(end_y);
            }

            if (eshift > diff_y) {
                error += diff_y;
                x += x.sigcmp(end_x);
            }
        }
    }

    public inline function
        rasterize<T>(m:Raster<T>, f:Int -> Int -> T -> T):Raster<T>
    {
        if (this.length == 1) {
            var x:Int = Std.int(this[0].x);
            var y:Int = Std.int(this[0].y);
            m.set(x, y, f(x, y, m.get(x, y)));
        } else for (i in 0...(this.length - 1)) Path.bresenham(
            this[i], this[i + 1],
            function(x:Int, y:Int) {
                m.set(x, y, f(x, y, m.get(x, y)));
            }, i != 0
        );

        return m;
    }

    public inline function pos_at<T>(offset:Float):PVector
    {
        var current:Float = 0.0;
        var result:PVector = this[this.length - 1];
        var len_offset:Float = Path.get_length() * offset;

        for (i in 0...(this.length - 1)) {
            var inner:PVector = this[i + 1] - this[i];
            var newlen:Float = inner.length;
            if (newlen + current >= len_offset) {
                result = this[i] + PVector.normalize(inner)
                       * (len_offset - current);
                break;
            }
            current += newlen;
        }

        return result;
    }

    public inline function add(x:Float, y:Float):Path
        return Path.add_pvector(new PVector(x, y));

    public inline function add_pvector(what:PVector):Path
    {
        this.push(what);
        return cast this;
    }

    @:op(A + B)
    public inline static function concat(a:Path, b:Path):Path
        return new Path(a.to_array().concat(b.to_array()));

    private inline function to_array():Array<PVector>
        return this;

    public inline function get_length():Float
    {
        var result:Float = 0;

        for (i in 0...(this.length - 1))
            result += (this[i + 1] - this[i]).length;

        return result;
    }

    private static function cubic_bezier( start:PVector
                                        , c1:PVector
                                        , c2:PVector
                                        , end:PVector
                                        , t:Float
                                        ):PVector
    {
        var p0:PVector = end + 3 * (c1 - c2) - start;
        var p1:PVector = 3 * (c2 - c1 - c1 + start);
        var p2:PVector = 3 * (c1 - start);
        return ((p0 * t + p1) * t + p2) * t + start;
    }

    public static function
        bezier(start:PVector, c1:PVector, c2:PVector, end:PVector):Path
    {
        var steps:Int = Math.ceil(Lambda.fold([
            start - c1,
            c2 - end,
            (start - c2) / 2,
            (c1 - end) / 2,
        ], function (a:PVector, b:Float) {
            return Math.max(a.dot_product(a), b);
        }, 1.0) * 3.0);

        var path:Array<PVector> = new Array();

        for (s in 0.range(steps)) {
            var t:Float = s / steps;
            path.push(Path.cubic_bezier(start, c1, c2, end, t));
        }

        return new Path(path);
    }
}
