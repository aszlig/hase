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

class RectData implements hase.iface.Renewable
{
    public var x:Int;
    public var y:Int;
    public var w:Int;
    public var h:Int;

    public function new(x:Int, y:Int, w:Int, h:Int)
    {
        this.x = x;
        this.y = y;
        this.w = w;
        this.h = h;
    }
}

abstract Rect (RectData)
{
    public var x(get, set):Int;
    public var y(get, set):Int;
    public var width(get, set):Int;
    public var height(get, set):Int;

    public var left(get, never):Int;
    public var right(get, never):Int;
    public var top(get, never):Int;
    public var bottom(get, never):Int;

    public inline function new(x:Int, y:Int, width:Int, height:Int)
    {
        #if macro
        this = new RectData(x, y, width, height);
        #else
        this = Pool.alloc(RectData, x, y, width, height);
        #end
    }

    public inline function free():Rect
        return cast #if macro this #else Pool.free(this) #end;

    private inline function get_x():Int
        return this.x;

    private inline function set_x(val:Int):Int
        return this.x = val;

    private inline function get_y():Int
        return this.y;

    private inline function set_y(val:Int):Int
        return this.y = val;

    private inline function get_width():Int
        return this.w;

    private inline function set_width(val:Int):Int
        return this.w = val;

    private inline function get_height():Int
        return this.h;

    private inline function set_height(val:Int):Int
        return this.h = val;

    private inline function get_left():Int
        return Rect.x;

    private inline function get_right():Int
        return Rect.x + Rect.width;

    private inline function get_top():Int
        return Rect.y;

    private inline function get_bottom():Int
        return Rect.y + Rect.height;

    public function set(x:Int, y:Int, width:Int, height:Int):Rect
    {
        this.x = x;
        this.y = y;
        this.w = width;
        this.h = height;
        return cast this;
    }

    public inline function set_from_rect(other:Rect):Rect
        return Rect.set(other.x, other.y, other.width, other.height);

    public inline function copy():Rect
        return new Rect(Rect.x, Rect.y, Rect.width, Rect.height);

    public inline function intersects(other:Rect):Bool
    {
        return Rect.x < other.right
            && Rect.right > other.x
            && Rect.y < other.bottom
            && Rect.bottom > other.y;
    }

    public inline function contains(x:Int, y:Int):Bool
    {
        return Rect.x <= x && Rect.right > x
            && Rect.y <= y && Rect.bottom > y;
    }

    public inline function distance_to(other:Rect):PVector
    {
        return new PVector(
              Rect.right < other.x ? other.x - Rect.right
            : Rect.x > other.right ? other.right - Rect.x
            : 0.0,
              Rect.bottom < other.y ? other.y - Rect.bottom
            : Rect.y > other.bottom ? other.bottom - Rect.y
            : 0.0
        );
    }

    @:op(A == B)
    public inline static function equals(r1:Rect, r2:Rect):Bool
        return r1.x == r2.x
            && r1.y == r2.y
            && r1.width == r2.width
            && r1.height == r2.height;

    @:op(A != B)
    public inline static function not_equal(r1:Rect, r2:Rect):Bool
        return !(r1 == r2);


    @:op(A > B)
    public inline static function includes(r1:Rect, r2:Rect):Bool
        return r2.x > r1.x && r2.y > r1.y
            && r2.right < r1.right
            && r2.bottom < r1.bottom;

    @:op(A >= B)
    public inline static function includes_match(r1:Rect, r2:Rect):Bool
        return r2.x >= r1.x && r2.y >= r1.y
            && r2.right <= r1.right
            && r2.bottom <= r1.bottom;

    @:op(A < B)
    public inline static function includes_neg(r1:Rect, r2:Rect):Bool
        return r2 > r1;

    @:op(A <= B)
    public inline static function includes_match_neg(r1:Rect, r2:Rect):Bool
        return r2 >= r1;

    public function impure_intersect_(other:Rect):Bool
    {
        var x:Int = Rect.x > other.x ? Rect.x : other.x;
        var y:Int = Rect.y > other.y ? Rect.y : other.y;

        var right:Int = Rect.right < other.right
                      ? Rect.right : other.right;
        var bottom:Int = Rect.bottom < other.bottom
                       ? Rect.bottom : other.bottom;

        if (right - x < 1 || bottom - y < 1)
            return false;

        Rect.width = right - (Rect.x = x);
        Rect.height = bottom - (Rect.y = y);
        return true;
    }

    @:op(A | B)
    public static function intersection(r1:Rect, r2:Rect):Null<Rect>
    {
        var r1_copy:Rect = r1.copy();

        if (r1_copy.impure_intersect_(r2)) {
            return r1_copy;
        } else {
            r1_copy.free();
            return null;
        }
    }

    public inline function intersection_(other:Rect):Rect
    {
        Rect.impure_intersect_(other);
        return cast this;
    }

    @:op(A & B)
    public inline static function union(r1:Rect, r2:Rect):Rect
        return r1.copy().union_(r2);

    public inline function union_(other:Rect):Rect
        return Rect.union_values_(other.x, other.y, other.width, other.height);

    public function union_values_(x, y, width, height):Rect
    {
        Rect.width = x + width > Rect.right ? x + width : Rect.right;
        Rect.height = y + height > Rect.bottom ? y + height : Rect.bottom;
        Rect.width -= Rect.x = x > Rect.x ? Rect.x : x;
        Rect.height -= Rect.y = y > Rect.y ? Rect.y : y;
        return cast this;
    }
}
