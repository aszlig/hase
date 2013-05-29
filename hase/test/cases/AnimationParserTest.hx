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
package hase.test.cases;

import hase.display.Animation;
import hase.display.Image;
import hase.display.Symbol;

class AnimationParserTest extends haxe.unit.TestCase
{
    private function parse_anim(data:Array<String>):Array<FrameData>
    {
        return (new hase.utils.AnimationParser(data.join("\n"))).parse();
    }

    private inline function assert_row(row:String, actual:Image, pos:Int):Void
    {
        this.assertEquals(row.length, actual.width);
        actual.map_(inline function(x:Int, y:Int, sym:Symbol) {
            if (y == pos) this.assertEquals(new Symbol(row.charCodeAt(x)), sym);
        });
    }

    public function test_one_frame_no_color()
    {
        var result = this.parse_anim(
            [ "|XXX"
            , "|XXX"
            , "|XXX"
            ]
        );

        this.assertEquals(1, result.length);
        this.assertEquals(3, result[0].image.width);
        this.assertEquals(3, result[0].image.height);
    }

    public function test_two_frames_no_color()
    {
        var result = this.parse_anim(
            [ "|XXX"
            , "|XXX"
            , "|XXX"
            , "-"
            , "|YYY"
            , "|YYY"
            , "|YYY"
            ]
        );

        this.assertEquals(2, result.length);
        this.assertEquals(3, result[0].image.width);
        this.assertEquals(3, result[0].image.height);
        this.assertEquals(3, result[1].image.width);
        this.assertEquals(3, result[1].image.height);

        this.assert_row("XXX", result[0].image, 0);
        this.assert_row("XXX", result[0].image, 1);
        this.assert_row("XXX", result[0].image, 2);

        this.assert_row("YYY", result[1].image, 0);
        this.assert_row("YYY", result[1].image, 1);
        this.assert_row("YYY", result[1].image, 2);
    }

    public function test_oneframe_header()
    {
        var result = this.parse_anim(
            [ ": plain                   :"
            , "|    _...._     _...._    |"
            , "|  .' .-'~       ~`-. `.  |"
            , "| (  (               )  ) |"
            , "| (  `.             .'  ) |"
            , "| `.   `.,       ,.'   .' |"
            , "|   `,  .`-._ _.-'.  ,'   |"
            , "|     |' _   ~   _ `|     |"
            , "|     |.'*`.   .'*`.|     |"
            , "|     |`-, '' `` ,-'|     |"
            , "|     |    .-^-.    |     |"
            , "|     `-|   `^'   |-'     |"
            , "|       |_.'. .'._|       |"
            , "|         ||vvv||         |"
            , "|         :.^^^.:         |"
            , "|         (     )         |"
            ]
        );

        this.assertEquals(1, result.length);
        this.assertEquals(25, result[0].image.width);
        this.assertEquals(15, result[0].image.height);
    }

    public function test_complex_ansi_color()
    {
        var result = this.parse_anim(
            [ ": plain                   : ansi                    :"
            , "|    _...._     _...._    |    BBBBBB     BBBBBB    |"
            , "|  .' .-'~       ~`-. `.  |  BB BBBB       BBBB BB  |"
            , "| (  (               )  ) | B  B               B  B |"
            , "| (  `.             .'  ) | B  BB             BB  B |"
            , "| `.   `.,       ,.'   .' | BB   BBB       BBB   BB |"
            , "|   `,  .`-._ _.-'.  ,'   |   BB  ccccc ccccc  BB   |"
            , "|     |' _   ~   _ `|     |     cc K   c   K cc     |"
            , "|     |.'*`.   .'*`.|     |     cKKRKK   KKRKKc     |"
            , "|     |`-, '' `` ,-'|     |     cKKK KK KK KKKc     |"
            , "|     |    .-^-.    |     |     c    KKKKK    c     |"
            , "|     `-|   `^'   |-'     |     ccc   KKK   ccc     |"
            , "|       |_.'. .'._|       |       ccccw wcccc       |"
            , "|         ||vvv||         |         cWWWWWc         |"
            , "|         :.^^^.:         |         cWWWWWc         |"
            , "|         (     )         |         c     c         |"
            ]
        );

        this.assertEquals(1, result.length);
        this.assertEquals(25, result[0].image.width);
        this.assertEquals(15, result[0].image.height);
    }
}
