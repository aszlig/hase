/* Copyright (C) 2013 aszlig
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
package;

import hase.display.Animation;

class Main implements hase.Application
{
    private var car:Animation;
    private var dragon:Animation;
    private var dragon_head:Animation;
    private var dragon_wing:Animation;
    private var delta:Float;

    public function init():Void
    {
        this.root.autoresize = false;
        this.delta = -1000;

        this.dragon = Animation.from_file("gfx/dragon.cat");
        this.dragon.x = -700;
        this.dragon.y = 8;
        this.dragon.fps = 17;
        this.dragon.loopback = true;
        this.root.add_child(this.dragon);

        this.dragon_head = Animation.from_file("gfx/dragon_head.cat");
        this.dragon_head.x = 39;
        this.dragon_head.y = -3;
        this.dragon_head.fps = 1;
        this.dragon.add_child(this.dragon_head);

        this.dragon_wing = Animation.from_file("gfx/dragon_wing_top.cat");
        this.dragon_wing.x = 34;
        this.dragon_wing.y = 2;
        this.dragon_wing.fps = 5;
        this.dragon_wing.loopback = true;
        this.dragon.add_child(this.dragon_wing);

        this.dragon_wing = Animation.from_file("gfx/dragon_wing_bottom.cat");
        this.dragon_wing.x = 38;
        this.dragon_wing.y = 2;
        this.dragon_wing.fps = 5;
        this.dragon_wing.loopback = true;
        this.dragon.add_child(this.dragon_wing);

        this.dragon_wing.z = -1;

        this.car = Animation.from_file("gfx/car.cat");
        this.car.x = -20;
        this.car.y = this.dragon.height + 4;
        this.car.fps = 10;
        this.root.add_child(this.car);
    }

    public function update(td:Float):Void
    {
        this.delta += td;

        this.car.x = Std.int(this.delta / 4000 * this.root.width);

        this.dragon.x = Std.int(this.delta / 4500 * this.root.width) - 100;
        this.dragon.y = Std.int(Math.sin(this.dragon.x / 10) * 4) + 8;

        if (this.dragon.x > this.root.width + 10)
            this.root.remove_child(this.dragon);
    }
}
