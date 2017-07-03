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
package hase.utils;

import hase.display.Symbol;

class ColorMixer
{
    public var plain:Int;
    public var red:Int;
    public var green:Int;
    public var blue:Int;
    public var grey:Int;
    public var ansi:Int;

    public function new()
    {
        this.plain = 0;
        this.red = 0;
        this.green = 0;
        this.blue = 0;
        this.grey = 0;
        this.ansi = 0;
    }

    private function ord_to_6cube(ord:Int):Int
    {
        if (ord < "0".code || ord > "5".code)
            return 0;

        return ord - "0".code;
    }

    private function get_6cube():Int
    {
        var red:Int   = this.ord_to_6cube(this.red);
        var green:Int = this.ord_to_6cube(this.green);
        var blue:Int  = this.ord_to_6cube(this.blue);

        return 16 + (red * 36) + (green * 6) + blue;
    }

    private function get_fgcolor():Int
    {
        return switch (this.grey) {
            case "a".code: 232;
            case "b".code: 233;
            case "c".code: 234;
            case "d".code: 235;
            case "e".code: 236;
            case "f".code: 237;
            case "g".code: 238;
            case "h".code: 239;
            case "i".code: 240;
            case "j".code: 241;
            case "k".code: 242;
            case "l".code: 243;
            case "m".code: 244;
            case "n".code: 245;
            case "o".code: 246;
            case "p".code: 247;
            case "q".code: 248;
            case "r".code: 249;
            case "s".code: 250;
            case "t".code: 251;
            case "u".code: 252;
            case "v".code: 253;
            case "w".code: 254;
            case "x".code: 255;
            default:
                switch (this.ansi) {
                    case "k".code: 0;
                    case "r".code: 1;
                    case "g".code: 2;
                    case "y".code: 3;
                    case "b".code: 4;
                    case "m".code: 5;
                    case "c".code: 6;
                    case "w".code: 7;
                    case "K".code: 8;
                    case "R".code: 9;
                    case "G".code: 10;
                    case "Y".code: 11;
                    case "B".code: 12;
                    case "M".code: 13;
                    case "C".code: 14;
                    case "W".code: 15;
                    default: this.get_6cube();
                }
        }
    }

    public function merge():Symbol
    {
        return new Symbol(this.plain, this.get_fgcolor());
    }
}
