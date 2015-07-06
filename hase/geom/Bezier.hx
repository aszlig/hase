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

class Bezier
{
    private var curve:Array<PVector>;

    public function new(curve:Array<PVector>)
        this.curve = curve;

    public function bezier(points:Array<PVector>, t:Float):PVector
    {
        if (points.length == 1) {
            return points[0];
        } else {
            return this.bezier([for (i in 0...(points.length - 1)) new PVector(
                (1 - t) * points[i].x + t * points[i + 1].x,
                (1 - t) * points[i].y + t * points[i + 1].y
            )], t);
        }
    }

    public function
        map2matrix<T>(m:Matrix<T>, f:Int -> Int -> T -> T):Matrix<T>
    {
        var steps:Int = 6000;

        var path:Array<PVector> = new Array();

        for (s in 0.range(steps)) {
            var t:Float = s / steps;
            path.push(this.bezier(this.curve, t));
        }

        return new Path(path).map2matrix(m, f);
    }
}
