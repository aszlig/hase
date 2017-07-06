/* Copyright (C) 2013-2017 aszlig
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

typedef FrameCallback = Float -> Void;
typedef FrameHandler = FrameCallback -> Void;

class JS
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

    private inline function legacy_timer(cb:FrameCallback):Void
        haxe.Timer.delay(cb.bind(haxe.Timer.stamp() * 1000), this.interval);

    private function loop():Void
    {
        var me = this;

        // What a mess! Cross-browser fuckery at its best!
        var frame_handler = untyped
            window.requestAnimationFrame ||
            window.webkitRequestAnimationFrame ||
            window.mozRequestAnimationFrame ||
            window.msRequestAnimationFrame ||
            window.oRequestAnimationFrame ||
            me.legacy_timer;

        untyped {
            __js__("function real_loop(time) {");

            if (!me.running)
                __js__("return true");

            if (me.last_time == null) {
                me.tick(0);
            } else {
                var delta:Float = time - me.last_time;
                if (delta < me.interval * 10)
                    me.tick(delta);
            }

            me.last_time = time;

            frame_handler(real_loop);

            __js__("return !{0}", me.running);

            __js__("}");
        }

        untyped frame_handler(untyped real_loop);
    }

    public inline function start():Void
    {
        this.running = true;
        this.last_time = null;
        this.loop();
    }

    public inline function stop():Void
        this.running = false;

    public dynamic function on_tick(delta:Float):Void {}

    private function tick(delta:Float):Void
    {
        this.root.update(delta);
        this.on_tick(delta);
    }
}
