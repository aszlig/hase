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
package hase.display;

import hase.geom.PVector;

class Motion extends Object
{
    /* characters per second */
    public var accel:PVector;
    public var velocity:PVector;

    private var delta:PVector;

    public function new()
    {
        super();
        this.accel    = new PVector(0.0, 0.0);
        this.velocity = new PVector(0.0, 0.0);
        this.delta    = new PVector(0.0, 0.0);
    }

    private inline function move():Void
    {
        while (Math.abs(this.delta.x) >= 1.0) {
            var diff:Int = this.delta.x < 0 ? -1 : 1;
            this.delta.x -= diff;
            this.parent.center_x -= diff;
        }

        while (Math.abs(this.delta.y) >= 1.0) {
            var diff:Int = this.delta.y < 0 ? -1 : 1;
            this.delta.y -= diff;
            this.parent.center_y -= diff;
        }
    }

    public override function update(td:Float):Void
    {
        super.update(td);

        if (this.accel != new PVector(0.0, 0.0) && this.parent != null) {
            this.velocity += this.accel * (td / 1000);

            var base:PVector = new PVector(
                this.parent.center_x,
                this.parent.center_y
            );

            this.delta += (base + this.velocity) - base;
            this.move();
        }
    }
}
