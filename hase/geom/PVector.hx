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
package hase.geom;

import hase.utils.Pool;

class PVectorData implements hase.iface.Renewable
{
    public var x:Float;
    public var y:Float;

    public function new(x:Float, y:Float)
    {
        this.x = x;
        this.y = y;
    }
}

abstract PVector (PVectorData)
{
    public var x(get, set):Float;
    public var y(get, set):Float;
    public var length(get, never):Float;

    public inline function new(x:Float, y:Float)
    {
        #if macro
        this = new PVectorData(x, y);
        #else
        this = Pool.alloc(PVectorData, x, y);
        #end
    }

    public inline function free():PVector
        return cast #if macro this #else Pool.free(this) #end;

    public inline function get_x():Float
        return this.x;

    public inline function set_x(val:Float):Float
        return this.x = val;

    public inline function get_y():Float
        return this.y;

    public inline function set_y(val:Float):Float
        return this.y = val;

    public function set(x:Float, y:Float):PVector
    {
        this.x = x;
        this.y = y;
        return cast this;
    }

    public function set_from_vector(vec:PVector):PVector
    {
        this.x = vec.x;
        this.y = vec.y;
        return cast this;
    }

    public inline function get_length():Float
        return Math.sqrt(PVector.x * PVector.x + PVector.y * PVector.y);

    public inline function dot_product(other:PVector):Float
        return PVector.x * other.x + PVector.y * other.y;

    public inline function cross_product(other:PVector):Float
        return PVector.x * other.y - PVector.y * other.x;

    public function normalize():PVector
        return (PVector.length == 0.0 || PVector.length == 1.0)
             ? new PVector(PVector.x, PVector.y)
             : PVector.divf(cast this, PVector.length);

    public inline function distance_to(other:PVector):Float
        return PVector.sub(cast this, other).length;

    public function rotate(radians:Float):PVector
    {
        var cv:Float = Math.cos(radians);
        var sv:Float = Math.sin(radians);
        return new PVector(
            PVector.x * cv - PVector.y * sv,
            PVector.x * sv + PVector.y * cv
        );
    }

    public inline function rotate_deg(degrees:Float):PVector
        return PVector.rotate(hase.utils.Misc.deg2rad(degrees));

    public inline function copy():PVector
        return new PVector(PVector.x, PVector.y);

    @:op(A + B)
    public static inline function add(a:PVector, b:PVector):PVector
        return new PVector(a.x + b.x, a.y + b.y);

    @:op(A - B)
    public static inline function sub(a:PVector, b:PVector):PVector
        return new PVector(a.x - b.x, a.y - b.y);

    @:commutative @:op(A * B)
    public static inline function mulf(a:PVector, b:Float):PVector
        return new PVector(a.x * b, a.y * b);

    @:op(A / B)
    public static inline function divf(a:PVector, b:Float):PVector
        return new PVector(a.x / b, a.y / b);

    @:op(-A)
    public static inline function inv(v:PVector):PVector
        return new PVector(-v.x, -v.y);

    @:op(A == B)
    public static inline function eq(a:PVector, b:PVector):Bool
        return a.x == b.x && a.y == b.y;

    @:op(A != B)
    public static inline function ne(a:PVector, b:PVector):Bool
        return !(a == b);

    @:op(A < B)
    public static inline function lt(a:PVector, b:PVector):Bool
        return a.x < b.x && a.y < b.y;

    @:op(A <= B)
    public static inline function le(a:PVector, b:PVector):Bool
        return a.x <= b.x && a.y <= b.y;

    @:op(A > B)
    public static inline function gt(a:PVector, b:PVector):Bool
        return a.x > b.x && a.y > b.y;

    @:op(A >= B)
    public static inline function ge(a:PVector, b:PVector):Bool
        return a.x >= b.x && a.y >= b.y;
}
