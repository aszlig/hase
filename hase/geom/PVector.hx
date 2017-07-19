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

abstract PVector (Array<Float>)
{
    public var x(get, set):Float;
    public var y(get, set):Float;
    public var length(get, never):Float;

    public inline function new(x:Float, y:Float)
        this = [x, y];

    public inline function get_x():Float
        return this[0];

    public inline function set_x(val:Float):Float
        return this[0] = val;

    public inline function get_y():Float
        return this[1];

    public inline function set_y(val:Float):Float
        return this[1] = val;

    public function set(x:Float, y:Float):PVector
    {
        this[0] = x;
        this[1] = y;
        return cast this;
    }

    public function set_from_vector(vec:PVector):PVector
    {
        this[0] = vec.x;
        this[1] = vec.y;
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
