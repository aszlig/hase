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
package hase.display;

import hase.geom.PVector;
import hase.geom.Rect;

class Object
{
    public var parent:Object;
    public var children:List<Object>;

    public var x(get, set):Int;
    public var y(get, set):Int;
    public var z(default, set):Int;

    public var center_x(get, set):Int;
    public var center_y(get, set):Int;

    public var width(default, set):Int;
    public var height(default, set):Int;

    public var absolute_x(get, set):Int;
    public var absolute_y(get, set):Int;

    private var _vector:PVector;
    public var vector(get, set):PVector;
    private var _center_vector:PVector;
    public var center_vector(get, set):PVector;
    public var abs_vector(get, set):PVector;

    public var rect(get, null):Rect;
    public var abs_rect(get, null):Rect;

    public var is_dirty(get, set):Bool;
    private var _is_dirty:Bool;
    private var _dirty_vector:PVector;
    private var _dirty_center_vector:PVector;

    public var surface(default, set):Null<Surface>;
    public var is_surface:Bool;

    public var autoresize:Bool;

    public function new()
    {
        this.parent = null;
        this.children = new List();

        this._vector = new PVector(0.0, 0.0);
        this._center_vector = new PVector(0.0, 0.0);

        this.z = 0;

        this.width = 0;
        this.height = 0;

        this._is_dirty = true;
        this._dirty_vector = new PVector(0.0, 0.0);
        this._dirty_center_vector = new PVector(0.0, 0.0);

        this.is_surface = false;
        this.surface = null;

        this.autoresize = true;
    }

    public function add_child(child:Object):Object
    {
        child.parent = this;
        child.autogrow();

        if (child.z == 0)
            child.z = this.z + 1;

        if (this.is_surface)
            child.surface = cast this;
        else if (this.surface != null)
            child.surface = this.surface;

        this.children.add(child);
        this.mark_dirty();
        return child;
    }

    public function remove_child(child:Object):Object
    {
        child.parent = null;
        child.surface = null;
        this.children.remove(child);
        return child;
    }

    #if debug public #else private #end function
        mark_dirty<T>(?from:Null<T>, ?to:Null<T>):T
    {
        if ((from == null && to == null) || from != to) {
            this.is_dirty = true;
            for (child in this.children)
                child.mark_dirty();
        }

        return to;
    }

    private inline function check_dirty():Void
    {
        if (this._dirty_vector != this.vector ||
            this._dirty_center_vector != this.center_vector)
            this.mark_dirty();
    }

    private function get_is_dirty():Bool
        return this._is_dirty
            || this._dirty_vector != this.vector
            || this._dirty_center_vector != this.center_vector;

    private function set_is_dirty(val:Bool):Bool
    {
        if (!val) {
            this._dirty_vector.set_from_vector(this.vector);
            this._dirty_center_vector.set_from_vector(this.center_vector);
        }
        return this._is_dirty = val;
    }

    private inline function get_vector():PVector
        return this._vector;

    private inline function set_vector(vec:PVector):PVector
        return this.vector.set_from_vector(vec);

    private inline function get_center_vector():PVector
        return this._center_vector;

    private inline function set_center_vector(vec:PVector):PVector
        return this.center_vector.set_from_vector(vec);

    private function get_abs_vector():PVector
    {
        return this.parent == null
             ? new PVector(this.vector.x, this.vector.y)
             : this.vector + this.parent.abs_vector;
    }

    private function set_abs_vector(vec:PVector):PVector
    {
        this.vector.set_from_vector(
            this.parent == null ? vec : vec - this.parent.abs_vector
        );
        return vec;
    }

    private inline function get_rect():Rect
        return new Rect(this.x, this.y, this.width, this.height);

    private inline function get_abs_rect():Rect
        return new Rect(
            this.absolute_x, this.absolute_y, this.width, this.height
        );

    public inline function center_distance_to(other:Object):PVector
        return other.abs_vector - this.abs_vector;

    public inline function distance_to(other:Object):PVector
        return this.abs_rect.distance_to(other.abs_rect);

    private inline function get_x():Int
        return Math.round(this.vector.x);

    private function set_x(val:Int):Int
    {
        this.vector.x = val;
        this.check_dirty();
        return val;
    }

    private inline function get_y():Int
        return Math.round(this.vector.y);

    private function set_y(val:Int):Int
    {
        this.vector.y = val;
        this.check_dirty();
        return val;
    }

    private function set_z(val:Int):Int
    {
        if (val != this.z) {
            this.z = val;
            this.is_dirty = true;
            if (this.surface != null)
                this.surface.z_reorder();
        }
        return this.z;
    }

    private function autogrow_width():Void
    {
        if (this.parent == null || !this.parent.autoresize)
            return;

        if (this.x + this.width > this.parent.width)
            this.parent.width = this.x + this.width;
    }

    private function autogrow_height():Void
    {
        if (this.parent == null || !this.parent.autoresize)
            return;

        if (this.y + this.height > this.parent.height)
            this.parent.height = this.y + this.height;
    }

    private inline function get_center_x():Int
        return Math.round(this.center_vector.x);

    private function set_center_x(val:Int):Int
    {
        this.center_vector.x = val;
        this.check_dirty();
        return val;
    }

    private inline function get_center_y():Int
        return Math.round(this.center_vector.y);

    private function set_center_y(val:Int):Int
    {
        this.center_vector.y = val;
        this.check_dirty();
        return val;
    }

    private function set_width(val:Int):Int
    {
        this.width = val;
        this.autogrow_width();

        return this.mark_dirty(null, this.width);
    }

    private function set_height(val:Int):Int
    {
        this.height = val;
        this.autogrow_height();

        return this.mark_dirty(null, this.height);
    }

    private inline function get_absolute_x():Int
        return Math.round(this.abs_vector.x);

    private function set_absolute_x(val:Int):Int
    {
        var offset:Int = this.parent == null ? 0 : this.parent.absolute_x;
        this.x = val - offset;
        return val;
    }

    private inline function get_absolute_y():Int
        return Math.round(this.abs_vector.y);

    private function set_absolute_y(val:Int):Int
    {
        var offset:Int = this.parent == null ? 0 : this.parent.absolute_y;
        this.y = val - offset;
        return val;
    }

    private function set_surface(val:Null<Surface>):Null<Surface>
    {
        for (child in this.children)
            child.surface = val;

        return this.surface = val;
    }

    public function rotate_around_vec(vec:PVector, radians:Float):Void
    {
        var vecpos:PVector = new PVector(vec.x, vec.y * 2.0);
        var thispos:PVector = this.abs_vector.copy();

        // Compensate for character ratio of 1:2 in width and height
        thispos.y *= 2.0;

        var rotation:PVector = (thispos - vecpos).rotate(radians);

        // Restore the scaling of the Y axis
        rotation.y /= 2.0;
        vecpos.y /= 2.0;

        this.abs_vector = vecpos + rotation;
    }

    public inline function rotate_around(obj:Object, radians:Float):Void
        return this.rotate_around_vec(obj.abs_vector, radians);

    public inline function rotate_around_deg(obj:Object, deg:Float):Void
        return this.rotate_around(obj, hase.utils.Misc.deg2rad(deg));

    public inline function rotate_around_vec_deg(vec:PVector, deg:Float):Void
        return this.rotate_around_vec(vec, hase.utils.Misc.deg2rad(deg));

    public function autogrow():Void
    {
        this.autogrow_width();
        this.autogrow_height();
    }

    public function update(td:Float):Void
    {
        for (child in this.children)
            child.update(td);
    }

    public function toString():String
    {
        return "<Object x: " + this.x + "; y: " + this.y +
               "; z: " + this.z + ">";
    }
}
