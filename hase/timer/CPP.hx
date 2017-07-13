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

    private function tick(delta:Float):Void
    {
        this.root.update(delta);
        this.on_tick(delta);
    }
}
