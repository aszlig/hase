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

        @:new_only {
            this.forces   = new List();
            this.velocity = new PVector(0.0, 0.0);
            this.force    = new PVector(0.0, 0.0);
            this.delta    = new PVector(0.0, 0.0);
            this.mass     = 1.0;
        }
        @:renew_only this.reset();
    }

    public function reset():Void
    {
        this.velocity.set(0.0, 0.0);
        this.force.set(0.0, 0.0);
        this.delta.set(0.0, 0.0);
        this.mass = 1.0;

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

        var force:PVector = this.force.copy();
        var timediff:Float = td / 1000;

        for (f in this.forces) {
            switch (f) {
                case Following(target, eagerness, stop_radius, into):
                    var dist:PVector = into
                                     ? this.parent.center_distance_to(target)
                                     : this.parent.distance_to(target);
                    dist = dist.free() - this.delta;

                    // FIXME: This is not nice, because if we have too much
                    // acceleration, we might surpass the destination.
                    if (dist.length <= stop_radius) {
                        var dv:PVector = dist + this.velocity;
                        var vs:PVector = this.velocity * stop_radius;
                        var ds:PVector = dv - vs;
                        dv.free();
                        vs.free();
                        var dm:PVector = ds * this.mass;
                        ds.free();
                        dm = dm.free() / timediff;
                        dm = dm.free() / stop_radius;
                        dm = dm.free() + force;
                        force.free();
                        force = dm;
                    } else {
                        var de:PVector = dist * eagerness;
                        de = de.free() + force;
                        force.free();
                        force = de;
                    }
                    dist.free();
            }
        }

        var fm:PVector = force / this.mass;
        fm = fm.free() * timediff;
        fm = fm.free() + this.velocity;
        this.velocity.set_from_vector(fm);
        fm.free();

        var base:PVector = this.parent.abs_vector;
        var db:PVector = base + this.velocity;
        db = db.free() - base;
        base.free();
        db = db.free() + this.delta;
        this.delta.set_from_vector(db);
        db.free();

        this.move();
    }
}
