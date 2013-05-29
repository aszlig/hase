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

class Scene extends hase.display.Sprite
{
    private var car:Animation;
    private var dragon:Animation;
    private var dragon_head:Animation;
    private var dragon_wing:Animation;
    private var delta:Float;

    public function new()
    {
        super();
        this.autoresize = false;
        this.delta = -1000;
    }

    public function init():Void
    {
        this.dragon = Animation.from_file("gfx/dragon.cat");
        this.dragon.x = -700;
        this.dragon.y = 8;
        this.dragon.fps = 17;
        this.dragon.loopback = true;
        this.add_child(this.dragon);

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
        this.add_child(this.car);
    }

    public override function update(td:Float):Void
    {
        this.delta += td;
        super.update(td);

        this.car.x = Std.int(this.delta / 4000 * this.width);

        this.dragon.x = Std.int(this.delta / 4500 * this.width) - 100;
        this.dragon.y = Std.int(Math.sin(this.dragon.x / 10) * 4) + 8;

        if (this.dragon.x > this.width + 10)
            this.remove_child(this.dragon);
    }
}

class Main
{
    private var root_surface:hase.display.Surface;

    public function new()
    {
        js.Browser.window.onload = this.onload;
    }

    private function onload(e:js.html.Event):Void
    {
        var canvas:js.html.CanvasElement = cast
            js.Browser.document.getElementById("canvas");

        canvas.width = js.Browser.window.innerWidth;
        canvas.height = js.Browser.window.innerHeight;

        var tc = new hase.TermCanvas(canvas);

        this.root_surface = new hase.display.Surface(tc);

        var scene = new Scene();
        scene.width = this.root_surface.width;
        scene.height = this.root_surface.height;
        scene.init();
        this.root_surface.add_child(scene);

        var timer = new hase.Timer(this.root_surface);
        timer.start();
    }

    public static function main():Void
    {
        new Main();
    }
}
