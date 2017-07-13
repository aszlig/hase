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
package;

import hase.display.Animation;
import hase.display.Motion;
import hase.geom.PVector;
import hase.input.Key;

class Example implements hase.Application
{
    private var car:Animation;
    private var dragon:Animation;
    private var dragon_head:Animation;
    private var dragon_wing:Animation;

    private var car_motion:Motion;
    private var dragon_motion:Motion;

    public function init():Void
    {
        this.root.autoresize = false;

        this.dragon = Animation.from_file("gfx/dragon.cat");
        this.dragon.x = (this.root.width - this.dragon.width) >> 1;
        this.dragon.y = (this.root.height - this.dragon.width) >> 2;
        this.dragon.fps = 17;
        this.dragon.loopback = true;

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

        this.dragon_motion = new Motion();
        this.dragon_motion.mass = 1000.0;
        this.dragon.add_child(this.dragon_motion);

        this.root.add_child(this.dragon);

        this.car = Animation.from_file("gfx/car.cat");
        this.car.x = (this.root.width - this.car.width) >> 1;
        this.car.y = Std.int((this.root.height - this.car.height) * 0.75);
        this.car.fps = 10;

        this.car_motion = new Motion();
        this.car_motion.mass = 1.5;
        this.car.add_child(this.car_motion);

        this.root.add_child(this.car);
        this.dragon_motion.follow(this.car, 10, 20, true);
    }

    public inline function on_keypress(k:Key):Void
    {
        switch (k) {
            case Char("a".code):            this.car_motion.force.x = -10;
            case Char("o".code | "s".code): this.car_motion.force.y =  10;
            case Char("e".code | "d".code): this.car_motion.force.x =  10;
            case Char(",".code | "w".code): this.car_motion.force.y = -10;
            case Char("q".code):            this.exit();
            default:
        }
    }

    public function update(td:Float):Void
    {
        this.car_motion.force *= 0.9 * (td / 100);
    }
}
