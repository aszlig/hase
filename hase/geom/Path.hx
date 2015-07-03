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

typedef Point = {
    var x:Int;
    var y:Int;
};

private class Bresenham
{
    private var end_x:Null<Int>;
    private var end_y:Null<Int>;

    private var diff_x:Int;
    private var diff_y:Int;

    private var error:Int;

    private var x:Int;
    private var y:Int;

    public function new(x0:Int, x1:Int, y0:Int, y1:Int)
    {
        this.end_x = x1;
        this.end_y = y1;

        this.diff_x = (x0 - this.end_x).intabs();
        this.diff_y = -(y0 - this.end_y).intabs();

        this.error = this.diff_x + this.diff_y;

        this.x = x0;
        this.y = y0;
    }

    public function hasNext():Bool
        return this.end_x != null && this.end_y != null;

    public function next():Point
    {
        var result:Point = {
            x: this.x,
            y: this.y
        };

        if (this.x == this.end_x && this.y == this.end_y) {
            this.end_x = this.end_y = null;
            return result;
        }

        var eshift:Int = this.error << 1;

        if (eshift < this.diff_x) {
            this.error += this.diff_x;
            this.y += this.y.sigcmp(this.end_y);
        }

        if (eshift > this.diff_y) {
            this.error += this.diff_y;
            this.x += this.x.sigcmp(this.end_x);
        }

        return result;
    }
}

abstract Path (Array<PVector>)
{
    public inline function new(path:Array<PVector>)
        this = path;

    private inline function
        draw_pixel_line( from:PVector, to:PVector
                       , f:Int -> Int -> Void, is_cont:Bool = false
                       ):Void
    {
        var b = new Bresenham(
            Math.round(from.x), Math.round(to.x),
            Math.round(from.y), Math.round(to.y)
        );

        if (is_cont) b.next();
        for (p in b) f(p.x, p.y);
    }

    public inline function
        map2matrix<T>(m:Matrix<T>, f:Int -> Int -> T -> T):Matrix<T>
    {
        if (this.length == 1) {
            var x:Int = Std.int(this[0].x);
            var y:Int = Std.int(this[0].y);
            m.set(x, y, f(x, y, m.get(x, y)));
        } else for (i in 0...(this.length - 1)) Path.draw_pixel_line(
            this[i], this[i + 1],
            inline function(x:Int, y:Int) {
                m.set(x, y, f(x, y, m.get(x, y)));
            }, i != 0
        );

        return m;
    }
}
