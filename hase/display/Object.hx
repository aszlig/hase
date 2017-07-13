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
    public var children:Array<Object>;

    public var x(default, set):Int;
    public var y(default, set):Int;
    public var z(default, set):Int;

    public var center_x(default, set):Int;
    public var center_y(default, set):Int;

    public var width(default, set):Int;
    public var height(default, set):Int;

    public var absolute_x(get, null):Int;
    public var absolute_y(get, null):Int;

    public var vector(get, set):PVector;
    public var center_vector(get, null):PVector;
    public var abs_vector(get, null):PVector;

    public var rect(get, null):Rect;
    public var abs_rect(get, null):Rect;

    public var is_dirty:Bool;

    public var surface(default, set):Null<Surface>;
    public var is_surface:Bool;

    public var autoresize:Bool;

    public function new()
    {
        this.parent = null;
        this.children = new Array();

        this.x = 0;
        this.y = 0;
        this.z = 0;

        this.center_x = 0;
        this.center_y = 0;

        this.width = 0;
        this.height = 0;

        this.is_dirty = true;

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

        this.children.push(child);
        this.set_dirty();
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
        set_dirty<T>(?from:Null<T>, ?to:Null<T>):T
    {
        if ((from == null && to == null) || from != to) {
            this.is_dirty = true;
            for (child in this.children)
                child.set_dirty();
        }

        return to;
    }

    private inline function get_vector():PVector
        return new PVector(this.x, this.y);

    private inline function set_vector(vec:PVector):PVector
    {
        this.x = Std.int(vec.x);
        this.y = Std.int(vec.y);
        return vec;
    }

    private inline function get_center_vector():PVector
        return new PVector(this.center_x, this.center_y);

    private inline function get_abs_vector():PVector
        return new PVector(this.absolute_x, this.absolute_y);

    private inline function get_rect():Rect
        return new Rect(this.x, this.y, this.width, this.height);

    private inline function get_abs_rect():Rect
        return new Rect(
            this.absolute_x, this.absolute_y, this.width, this.height
        );

    public inline function center_distance_to(other:Object):PVector
        return other.abs_vector - this.abs_vector;

    public inline function distance_to(other:Object):PVector
        return Rect.distance_to(this.abs_rect, other.abs_rect);

    private inline function set_x(val:Int):Int
        return this.x = this.set_dirty(this.x, val);

    private inline function set_y(val:Int):Int
        return this.y = this.set_dirty(this.y, val);

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

    private inline function set_center_x(val:Int):Int
        return this.center_x = this.set_dirty(this.center_x, val);

    private inline function set_center_y(val:Int):Int
        return this.center_y = this.set_dirty(this.center_y, val);

    private function set_width(val:Int):Int
    {
        this.width = val;
        this.autogrow_width();

        return this.set_dirty(null, this.width);
    }

    private function set_height(val:Int):Int
    {
        this.height = val;
        this.autogrow_height();

        return this.set_dirty(null, this.height);
    }

    private function get_absolute_x():Int
    {
        return this.x + (this.parent == null ? 0 : this.parent.absolute_x);
    }

    private function get_absolute_y():Int
    {
        return this.y + (this.parent == null ? 0 : this.parent.absolute_y);
    }

    private function set_surface(val:Null<Surface>):Null<Surface>
    {
        for (child in this.children)
            child.surface = val;

        return this.surface = val;
    }

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
