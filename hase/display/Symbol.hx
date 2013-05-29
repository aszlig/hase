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
package hase.display;

abstract Symbol(Int) from Int
{
    public var ordinal(get, set):Int;
    public var fgcolor(get, set):Int;
    public var bgcolor(get, set):Int;

    public inline function new(ord:Int, ?fg:Int, ?bg:Int)
        this = (bg != null ? (1 << 26) | bg << 16 : 0)
             | (fg != null ? (1 << 25) | fg << 8  : 0)
             | ord;

    private inline function get_ordinal():Int
        return this & 0xff;

    private inline function set_ordinal(ord:Int):Int
        return this |= ord;

    private inline function get_fgcolor():Int
        return this >> 25 & 1 == 1 ? (this & 0xff00) >> 8 : 7;

    private inline function set_fgcolor(fg:Int):Int
        return this |= fg == 7 ? 0 : (1 << 25) | (fg << 8);

    private inline function get_bgcolor():Int
        return this >> 26 & 1 == 1 ? (this & 0xff0000) >> 16 : 0;

    private inline function set_bgcolor(bg:Int):Int
        return this |= bg == 0 ? 0 : (1 << 26) | (bg << 16);

    public inline function is_alpha():Bool
        return this & 0xff == 0;

    public inline function get_hash():Int
        return this;

    @:to public inline function toString():String
        return String.fromCharCode(this & 0xff);
}
