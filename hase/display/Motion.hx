/* Haxe ASCII Spriting Engine
 *
 * Copyright (C) 2015-2017 aszlig
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
package hase.display;

import hase.geom.PVector;

enum Force {
    Following(target:Object, eagerness:Float, break_at:Float, into:Bool);
}

class Motion extends Object
{
    public var velocity:PVector;
    public var force:PVector;
    public var mass:Float;

    private var delta:PVector;
    private var forces:List<Force>;

    public function new()
    {
        super();
        this.forces = new List();
        this.reset();
    }

    public function reset():Void
    {
        this.velocity = new PVector(0.0, 0.0);
        this.force    = new PVector(0.0, 0.0);
        this.delta    = new PVector(0.0, 0.0);
        this.mass     = 1.0;

        this.forces.clear();
    }

    private function move():Void
    {
        while (Math.abs(this.delta.x) >= 1.0) {
            var diff:Int = this.delta.x < 0 ? -1 : 1;
            this.delta.x -= diff;
            this.parent.x += diff;
        }

        while (Math.abs(this.delta.y) >= 1.0) {
            var diff:Int = this.delta.y < 0 ? -1 : 1;
            this.delta.y -= diff;
            this.parent.y += diff;
        }
    }

    public inline function follow( target:Object, eagerness:Float
                                 , stop_radius:Float, into:Bool = false
                                 ):Void
        this.forces.add(Following(target, eagerness, stop_radius, into));

    public function unfollow(target:Object):Void
    {
        for (f in this.forces) {
            switch (f) {
                case Following(target, _, _, _): this.forces.remove(f);
                default:
            }
        }
    }

    public function unfollow_all():Void
    {
        for (f in this.forces) {
            switch (f) {
                case Following(_, _, _, _): this.forces.remove(f);
                default:
            }
        }
    }

    public override function update(td:Float):Void
    {
        super.update(td);

        // nothing to move at all
        if (this.parent == null)
            return;

        var force:PVector = this.force;
        var timediff:Float = td / 1000;

        for (f in this.forces) {
            switch (f) {
                case Following(target, eagerness, stop_radius, into):
                    var dist:PVector =
                        (into ? this.parent.center_distance_to(target)
                              : this.parent.distance_to(target)
                        ) - this.delta;

                    // FIXME: This is not nice, because if we have too much
                    // acceleration, we might surpass the destination.
                    if (dist.length <= stop_radius) {
                        force += ((dist + this.velocity)
                               - this.velocity * stop_radius)
                               * this.mass / timediff / stop_radius;
                    } else {
                        force += dist * eagerness;
                    }
            }
        }

        this.velocity += (force / this.mass) * timediff;
        var base:PVector = this.parent.abs_vector;
        this.delta += (base + this.velocity) - base;
        this.move();
    }
}
