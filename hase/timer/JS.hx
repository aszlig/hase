/* Haxe ASCII Spriting Engine
 *
 * Copyright (C) 2013-2017 aszlig
 *
 * This program is free software: you can redistribute it and/or modify it
 * under the terms of the GNU Affero General Public License, version 3, as
 * published by the Free Software Foundation.
 *
 * This program is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 * FITNESS FOR A PARTICULAR PURPOSE. See the GNU Affero General Public License
 * for more details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
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
