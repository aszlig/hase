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

class Color
{
    public static function get_rgb(xterm:Int):Int
    {
        return switch (xterm) {
            case  0: 0x000000;
            case  1: 0xcd0000;
            case  2: 0x00cd00;
            case  3: 0xcdcd00;
            case  4: 0x0000ee;
            case  5: 0xcd00cd;
            case  6: 0x00cdcd;
            case  7: 0xe5e5e5;
            case  8: 0x7f7f7f;
            case  9: 0xff0000;
            case 10: 0x00ff00;
            case 11: 0xffff00;
            case 12: 0x5c5cff;
            case 13: 0xff00ff;
            case 14: 0x00ffff;
            case 15: 0xffffff;
            case c if (c >= 16 && c < 232):
                var base:Int  = xterm - 16;
                var red:Int   = Std.int(base / 36) % 6;
                var green:Int = Std.int(base /  6) % 6;
                var blue:Int  =         base       % 6;
                (red   > 0 ? (red   * 40 + 55) << 16 : 0) |
                (green > 0 ? (green * 40 + 55) <<  8 : 0) |
                (blue  > 0 ? (blue  * 40 + 55)       : 0);
            default:
                var level:Int = (xterm - 232) * 10 + 8;
                level << 16 | level << 8 | level;
        }
    }
}
