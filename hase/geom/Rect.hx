/* Copyright (C) 2013-2017 aszlig
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */
package hase.geom;

abstract Rect (Array<Int>)
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
        this = [x, y, width, height];

    private inline function get_x():Int
        return this[0];

    private inline function set_x(val:Int):Int
        return this[0] = val;

    private inline function get_y():Int
        return this[1];

    private inline function set_y(val:Int):Int
        return this[1] = val;

    private inline function get_width():Int
        return this[2];

    private inline function set_width(val:Int):Int
        return this[2] = val;

    private inline function get_height():Int
        return this[3];

    private inline function set_height(val:Int):Int
        return this[3] = val;

    private inline function get_left():Int
        return Rect.x;

    private inline function get_right():Int
        return Rect.x + Rect.width;

    private inline function get_top():Int
        return Rect.y;

    private inline function get_bottom():Int
        return Rect.y + Rect.height;

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

    public static inline function distance_to(r1:Rect, r2:Rect):PVector
    {
        return new PVector(
              r1.right < r2.x ? r2.x - r1.right
            : r1.x > r2.right ? r2.right - r1.x
            : 0.0,
              r1.bottom < r2.y ? r2.y - r1.bottom
            : r1.y > r2.bottom ? r2.bottom - r1.y
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

    @:op(A |= B)
    public inline static function intersection_(r1:Rect, r2:Rect):Rect
    {
        r1.impure_intersect_(r2);
        return r1;
    }

    @:op(A | B)
    public inline static function intersection(r1:Rect, r2:Rect):Null<Rect>
    {
        var r1_copy:Rect = r1.copy();
        return r1_copy.impure_intersect_(r2) ? r1_copy : null;
    }

    @:op(A & B)
    public inline static function union(r1:Rect, r2:Rect):Rect
        return Rect.union_(r1.copy(), r2);

    @:op(A &= B)
    public static function union_(r1:Rect, r2:Rect):Rect
    {
        r1.width = r2.right > r1.right ? r2.right : r1.right;
        r1.height = r2.bottom > r1.bottom ? r2.bottom : r1.bottom;
        r1.width -= r1.x = r2.x > r1.x ? r1.x : r2.x;
        r1.height -= r1.y = r2.y > r1.y ? r1.y : r2.y;
        return r1;
    }
}
