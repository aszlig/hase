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
    public var x(get, never):Int;
    public var y(get, never):Int;
    public var width(get, never):Int;
    public var height(get, never):Int;

    public var left(get, never):Int;
    public var right(get, never):Int;
    public var top(get, never):Int;
    public var bottom(get, never):Int;

    public inline function new(x:Int, y:Int, width:Int, height:Int)
        this = [x, y, width, height];

    private inline function get_x():Int
        return this[0];

    private inline function get_y():Int
        return this[1];

    private inline function get_width():Int
        return this[2];

    private inline function get_height():Int
        return this[3];

    private inline function get_left():Int
        return Rect.x;

    private inline function get_right():Int
        return Rect.x + Rect.width;

    private inline function get_top():Int
        return Rect.y;

    private inline function get_bottom():Int
        return Rect.y + Rect.height;

    public function union(other:Rect):Rect
    {
        var x:Int = other.x > Rect.x ? Rect.x : other.x;
        var y:Int = other.y > Rect.y ? Rect.y : other.y;
        var width:Int = other.right > Rect.right
                      ? other.right : Rect.right;
        var height:Int = other.bottom > Rect.bottom
                       ? other.bottom : Rect.bottom;

        return new Rect(x, y, width - x, height - y);
    }

    public inline function intersects(other:Rect):Bool
    {
        return Rect.x < other.right
            && Rect.right > other.x
            && Rect.y < other.bottom
            && Rect.bottom > other.y;
    }

    public inline function matches(other:Null<Rect>):Bool
    {
        return other != null
            && Rect.x == other.x
            && Rect.y == other.y
            && Rect.width == other.width
            && Rect.height == other.height;
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

    @:op(A & B)
    public static function intersection(r1:Rect, r2:Rect):Null<Rect>
    {
        var x:Int = r1.x > r2.x ? r1.x : r2.x;
        var y:Int = r1.y > r2.y ? r1.y : r2.y;

        var right:Int = r1.right < r2.right
                      ? r1.right : r2.right;
        var bottom:Int = r1.bottom < r2.bottom
                       ? r1.bottom : r2.bottom;

        return (right - x < 1 || bottom - y < 1) ? null :
           new Rect(x, y, right - x, bottom - y);
    }
}
