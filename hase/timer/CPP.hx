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
package hase.timer;

class CPP
{
    private var interval:Int;
    private var root:hase.display.Surface;
    private var last_time:Null<Float>;
    private var running:Bool;

    public function new(root:hase.display.Surface, fps:Int = 60)
    {
        this.interval = Std.int(1000 / fps);
        this.root = root;
    }

    private function loop():Void
    {
        while (this.running) {
            Sys.sleep(this.interval / 1000);
            var time = haxe.Timer.stamp() * 1000;

            if (this.last_time == null) {
                this.tick(0);
            } else {
                var delta:Float = time - this.last_time;
                if (delta < this.interval * 10)
                    this.tick(delta);
            }

            this.last_time = time;
        }
    }

    public inline function start():Void
    {
        this.running = true;
        this.last_time = null;
        // XXX: detach!
        this.loop();
    }

    public inline function stop():Void
        this.running = false;

    public dynamic function on_tick(delta:Float):Void {}

    private inline function tick(delta:Float):Void
    {
        this.root.update(delta);
        this.on_tick(delta);
    }
}
