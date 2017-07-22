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
package hase.test.cases;

import hase.display.Symbol;
import hase.geom.Raster;

import hase.macro.ParserTypes;

class FrameAreaParserTest extends haxe.unit.TestCase
{
    private function parse(data:Array<String>):Array<Container>
    {
        var img:Raster<Symbol> = Raster.from_2d_array([
            for (row in data) [for (c in 0...row.length) row.charCodeAt(c)]
        ], 0);
        return (new hase.macro.FrameAreaParser(img)).parse();
    }

    private inline function
        assert_row(row:String, actual:Raster<Symbol>, pos:Int):Void
    {
        this.assertEquals(row.length, actual.width);
        this.assertFalse(pos >= actual.height);
        actual.map_(function(x:Int, y:Int, sym:Symbol) {
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

    public function test_three_vertical_boxes():Void
    {
        var result:Array<Container> = this.parse(
            [ ": red :"
            , "| AAA |"
            , "| AAA |"
            , "| AAA |"
            , ":green:"
            , "| BBB |"
            , "| BBB |"
            , "| BBB |"
            , ""
            , ":blue :"
            , "| CCC |"
            , "| CCC |"
            , "| CCC |"
            ]
        );

        this.assertEquals(3, result[0].body.height);
        this.assert_row(" AAA ", result[0].body, 0);
        this.assert_row(" AAA ", result[0].body, 1);
        this.assert_row(" AAA ", result[0].body, 2);

        this.assertEquals(3, result[1].body.height);
        this.assert_row(" BBB ", result[1].body, 0);
        this.assert_row(" BBB ", result[1].body, 1);
        this.assert_row(" BBB ", result[1].body, 2);

        this.assertEquals(3, result[2].body.height);
        this.assert_row(" CCC ", result[2].body, 0);
        this.assert_row(" CCC ", result[2].body, 1);
        this.assert_row(" CCC ", result[2].body, 2);
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
