/* Copyright (C) 2013 aszlig
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

    public inline function get_length():Float
        return Math.sqrt(PVector.x * PVector.x + PVector.y * PVector.y);

    public inline function dot_product(other:PVector):Float
        return PVector.x * other.x + PVector.y * other.y;

    public inline function cross_product(other:PVector):Float
        return PVector.x * other.y - PVector.y * other.x;

    public inline static function normalize(v:PVector):PVector
        return (v.length == 0.0 || v.length == 1.0) ? v : v / v.length;

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
