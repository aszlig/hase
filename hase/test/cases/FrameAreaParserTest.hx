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

import hase.display.Image;
import hase.display.Symbol;

import hase.utils.ParserTypes;

class FrameAreaParserTest extends haxe.unit.TestCase
{
    private function parse(data:Array<String>):Array<Container>
    {
        var img:Image = hase.geom.Raster.from_2d_array([
            for (row in data) [for (c in 0...row.length) row.charCodeAt(c)]
        ], 0);
        return (new hase.utils.FrameAreaParser(img)).parse();
    }

    private inline function assert_row(row:String, actual:Image, pos:Int):Void
    {
        this.assertEquals(row.length, actual.width);
        this.assertFalse(pos >= actual.height);
        actual.map_(inline function(x:Int, y:Int, sym:Symbol) {
            if (y == pos) this.assertEquals(new Symbol(row.charCodeAt(x)), sym);
        });
    }

    public function test_simple():Void
    {
        var result:Array<Container> = this.parse(
            [ "| XXX"
            , "| XXX"
            , "| XXX"
            ]
        );

        this.assertEquals(3, result[0].body.height);
        this.assert_row(" XXX", result[0].body, 0);
        this.assert_row(" XXX", result[0].body, 1);
        this.assert_row(" XXX", result[0].body, 2);
    }

    public function test_heading():Void
    {
        var result:Array<Container> = this.parse(
            [ ":red:"
            , "|XXX|"
            , "|XXX|"
            , "|XXX|"
            ]
        );

        this.assertEquals(3, result[0].body.height);
        this.assert_row("XXX", result[0].body, 0);
        this.assert_row("XXX", result[0].body, 1);
        this.assert_row("XXX", result[0].body, 2);
    }

    public function test_two_headings():Void
    {
        var result:Array<Container> = this.parse(
            [ ":green:blue:"
            , "|AAA  |BBB |"
            , "|AAA  |BBB |"
            , "|AAA  |BBB |"
            ]
        );

        this.assertEquals(3, result[0].body.height);
        this.assert_row("AAA  ", result[0].body, 0);
        this.assert_row("AAA  ", result[0].body, 1);
        this.assert_row("AAA  ", result[0].body, 2);

        this.assertEquals(3, result[1].body.height);
        this.assert_row("BBB ", result[1].body, 0);
        this.assert_row("BBB ", result[1].body, 1);
        this.assert_row("BBB ", result[1].body, 2);
    }

    public function test_two_separate_headings():Void
    {
        var result:Array<Container> = this.parse(
            [ ":green: :blue:"
            , "|AAA  | |BBB |"
            , "|AAA  | |BBB |"
            , "|AAA  | |BBB |"
            ]
        );

        this.assertEquals(3, result[0].body.height);
        this.assert_row("AAA  ", result[0].body, 0);
        this.assert_row("AAA  ", result[0].body, 1);
        this.assert_row("AAA  ", result[0].body, 2);

        this.assertEquals(3, result[1].body.height);
        this.assert_row("BBB ", result[1].body, 0);
        this.assert_row("BBB ", result[1].body, 1);
        this.assert_row("BBB ", result[1].body, 2);
    }

    public function test_two_separate_headings_vertical():Void
    {
        var result:Array<Container> = this.parse(
            [ ":green:"
            , "|AAA  |"
            , "|AAA  |"
            , "|AAA  |"
            , "       "
            , ":blue: "
            , "|BBB | "
            , "|BBB | "
            , "|BBB | "
            ]
        );

        this.assertEquals(3, result[0].body.height);
        this.assert_row("AAA  ", result[0].body, 0);
        this.assert_row("AAA  ", result[0].body, 1);
        this.assert_row("AAA  ", result[0].body, 2);

        this.assertEquals(3, result[1].body.height);
        this.assert_row("BBB ", result[1].body, 0);
        this.assert_row("BBB ", result[1].body, 1);
        this.assert_row("BBB ", result[1].body, 2);
    }

    public function test_two_separate_headings_diagonal():Void
    {
        var result:Array<Container> = this.parse(
            [ ":green:       "
            , "|AAA  |       "
            , "|AAA  | :blue:"
            , "|AAA  | |BBB |"
            , "        |BBB |"
            , "        |BBB |"
            ]
        );

        this.assertEquals(3, result[0].body.height);
        this.assert_row("AAA  ", result[0].body, 0);
        this.assert_row("AAA  ", result[0].body, 1);
        this.assert_row("AAA  ", result[0].body, 2);

        this.assertEquals(3, result[1].body.height);
        this.assert_row("BBB ", result[1].body, 0);
        this.assert_row("BBB ", result[1].body, 1);
        this.assert_row("BBB ", result[1].body, 2);
    }

    public function test_two_containers_with_little_noise():Void
    {
        var result:Array<Container> = this.parse(
            [ "yes, i am a noisy line!"
            , " :green:               "
            , " |AAA  |               "
            , " |AAA  |               "
            , " |AAA  |               "
            , "i am another noisy line"
            , "         :blue:        "
            , " N I     |BBB |        "
            , "  O S    |BBB |        "
            , "     E   |BBB |        "
            ]
        );

        this.assertEquals(3, result[0].body.height);
        this.assert_row("AAA  ", result[0].body, 0);
        this.assert_row("AAA  ", result[0].body, 1);
        this.assert_row("AAA  ", result[0].body, 2);

        this.assertEquals(3, result[1].body.height);
        this.assert_row("BBB ", result[1].body, 0);
        this.assert_row("BBB ", result[1].body, 1);
        this.assert_row("BBB ", result[1].body, 2);
    }

    public function test_two_containers_with_lots_of_noise():Void
    {
        var result:Array<Container> = this.parse(
            [ "   ,----------.           ,-."
            , "   |          | ,-. Y     |O|"
            , "   | :green:  | | | o <-. `-'"
            , "   | |AAA  |  | | | |   |    "
            , "  ' `|AAA  |  | | `-'   |    "
            , "     |AAA  |  | |:blue: I'm  "
            , " .------.     | ||BBB | a    "
            , " |      `-----' ||BBB | snake"
            , " |              ||BBB | !    "
            , " |  hello, I am |            "
            , " |              | some noise "
            , " `--------------'            "
            ]
        );

        this.assertEquals(3, result[0].body.height);
        this.assert_row("AAA  ", result[0].body, 0);
        this.assert_row("AAA  ", result[0].body, 1);
        this.assert_row("AAA  ", result[0].body, 2);

        this.assertEquals(3, result[1].body.height);
        this.assert_row("BBB ", result[1].body, 0);
        this.assert_row("BBB ", result[1].body, 1);
        this.assert_row("BBB ", result[1].body, 2);
    }

    public function test_four_headings():Void
    {
        var result:Array<Container> = this.parse(
            [ ":plain:ansi:red:green:"
            , "|AAA  |BBB |CCC|DDD  |"
            , "|AAA  |BBB |CCC|DDD  |"
            , "|AAA  |BBB |CCC|DDD  |"
            ]
        );

        this.assertEquals(3, result[0].body.height);
        this.assert_row("AAA  ", result[0].body, 0);
        this.assert_row("AAA  ", result[0].body, 1);
        this.assert_row("AAA  ", result[0].body, 2);

        this.assertEquals(3, result[1].body.height);
        this.assert_row("BBB ", result[1].body, 0);
        this.assert_row("BBB ", result[1].body, 1);
        this.assert_row("BBB ", result[1].body, 2);

        this.assertEquals(3, result[2].body.height);
        this.assert_row("CCC", result[2].body, 0);
        this.assert_row("CCC", result[2].body, 1);
        this.assert_row("CCC", result[2].body, 2);

        this.assertEquals(3, result[3].body.height);
        this.assert_row("DDD  ", result[3].body, 0);
        this.assert_row("DDD  ", result[3].body, 1);
        this.assert_row("DDD  ", result[3].body, 2);
    }

    public function test_difficult_headings():Void
    {
        var result:Array<Container> = this.parse(
            [ ":red:red:plain:"
            , "|:|:|||||:xxx:|"
            , "||:|||||||XXX||"
            , "|:|:|:::||XXX||"
            ]
        );

        this.assertEquals(3, result[0].body.height);
        this.assert_row(":|:", result[0].body, 0);
        this.assert_row("|:|", result[0].body, 1);
        this.assert_row(":|:", result[0].body, 2);

        this.assertEquals(3, result[1].body.height);
        this.assert_row("|||", result[1].body, 0);
        this.assert_row("|||", result[1].body, 1);
        this.assert_row(":::", result[1].body, 2);

        this.assertEquals(3, result[2].body.height);
        this.assert_row(":xxx:", result[2].body, 0);
        this.assert_row("|XXX|", result[2].body, 1);
        this.assert_row("|XXX|", result[2].body, 2);
    }
}
