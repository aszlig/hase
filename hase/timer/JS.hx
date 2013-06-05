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

import js.html.RequestAnimationFrameCallback;
typedef FrameHandler = RequestAnimationFrameCallback -> Void;

class JS
{
    private var interval:Int;
    private var root:hase.display.Surface;
    private var last_time:Null<Float>;
    private var running:Bool;

    private var req_anim_frame:FrameHandler;

    public function new(root:hase.display.Surface, fps:Int = 60)
    {
        this.interval = Std.int(1000 / fps);
        this.root = root;

        var raf:Null<FrameHandler> = null;

        if (js.Browser.window != null)
            raf = this.get_frame_handler();

        this.req_anim_frame = raf != null ? raf : this.legacy_timer;
    }

    private inline function get_frame_handler():Null<FrameHandler>
    {
        // What a mess! Cross-browser fuckery at its best!
        if (untyped window.requestAnimationFrame)
            return js.Browser.window.requestAnimationFrame;
        else if (untyped js.Browser.window.webkitRequestAnimationFrame)
            return untyped js.Browser.window.webkitRequestAnimationFrame
                .bind(js.Browser.window);
        else if (untyped js.Browser.window.mozRequestAnimationFrame)
            return untyped js.Browser.window.mozRequestAnimationFrame
                .bind(js.Browser.window);
        else if (untyped js.Browser.window.msRequestAnimationFrame)
            return untyped js.Browser.window.msRequestAnimationFrame
                .bind(js.Browser.window);
        else if (untyped js.Browser.window.oRequestAnimationFrame)
            return untyped js.Browser.window.oRequestAnimationFrame
                .bind(js.Browser.window);
        else
            return null;
    }

    private inline function legacy_timer(cb:RequestAnimationFrameCallback):Void
        haxe.Timer.delay(cb.bind(haxe.Timer.stamp() * 1000), this.interval);

    private function loop(time:Float):Bool
    {
        if (!this.running)
            return true;

        if (this.last_time == null) {
            this.tick(0);
        } else {
            var delta:Float = time - this.last_time;
            if (delta < this.interval * 10)
                this.tick(delta);
        }

        this.last_time = time;

        this.req_anim_frame(this.loop);

        return !this.running;
    }

    public inline function start():Void
    {
        this.running = true;
        this.last_time = null;
        this.req_anim_frame(this.loop);
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
