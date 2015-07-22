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
        map2matrix<T>(m:Matrix<T>, f:Int -> Int -> T -> T):Matrix<T>
    {
        if (this.length == 1) {
            var x:Int = Std.int(this[0].x);
            var y:Int = Std.int(this[0].y);
            m.set(x, y, f(x, y, m.get(x, y)));
        } else for (i in 0...(this.length - 1)) Path.bresenham(
            this[i], this[i + 1],
            inline function(x:Int, y:Int) {
                m.set(x, y, f(x, y, m.get(x, y)));
            }, i != 0
        );

        return m;
    }

    public inline function add(x:Float, y:Float):Path
        return Path.add_pvector(new PVector(x, y));

    public inline function add_pvector(what:PVector):Path
    {
        this.push(what);
        return cast this;
    }

    public inline function get_length():Float
    {
        var result:Float = 0;

        for (i in 0...(this.length - 1))
            result += (this[i + 1] - this[i]).length;

        return result;
    }

    private static function decasteljau(points:Array<PVector>, t:Float):PVector
    {
        if (points.length == 1) {
            return points[0];
        } else {
            return Path.decasteljau([
                for (i in 0...(points.length - 1)) new PVector(
                    (1 - t) * points[i].x + t * points[i + 1].x,
                    (1 - t) * points[i].y + t * points[i + 1].y
                )
            ], t);
        }
    }

    public static function bezier(curve:Array<PVector>):Path
    {
        var steps:Int = 6000;

        var path:Array<PVector> = new Array();

        for (s in 0.range(steps)) {
            var t:Float = s / steps;
            path.push(Path.decasteljau(curve, t));
        }

        return new Path(path);
    }
}
