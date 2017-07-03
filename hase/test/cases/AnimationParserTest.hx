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

class AnimationParserTest extends hase.test.SurfaceTestCase
{
    private function parse_anim(data:Array<String>):Array<FrameData>
    {
        return (new hase.utils.AnimationParser(data.join("\n"))).parse();
    }

    private inline function assert_row(row:String, actual:Image, pos:Int):Void
    {
        this.assertEquals(row.length, actual.width);
        actual.map_(function(x:Int, y:Int, sym:Symbol) {
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

    public function test_different_frame_sizes():Void
    {
        var result:Array<FrameData> = this.parse_anim(
            [ "|l"
            , "|it"
            , "|le!"
            , "-"
            , "|          B"
            , "|     I"
            , "|     I"
            , "|G!"
            ]
        );

        this.assertEquals(2, result.length);

        var anim:Animation = new Animation(result);
        anim.fps = 1;

        this.root.add_child(anim);
        this.update();

        this.assert_area(
            [ "l   "
            , "it  "
            , "le! "
            , "    "
            ]
        );

        this.update();

        this.assert_area(
            [ "          B "
            , "     I      "
            , "     I      "
            , "G!          "
            , "            "
            ]
        );
    }

    public function test_different_frame_sizes_with_color():Void
    {
        var result:Array<FrameData> = this.parse_anim(
            [ ": plain                   : : red           :"
            , "| -.__,'``=.--__          | |               |"
            , "|  __ `--   `   `.   ))   | |               |"
            , "| ---:   -----.  ;__-' `. | |        555555 |"
            , "|     `-.  `--)      vv|| | |          5555 |"
            , "|          `--;; ,,''     | |               |"
            , "|               <.        |"
            , "|    __.----._    ^;,     | : green   |"
            , "|    ,'    ' .'-.__ `||;  | |         |"
            , "|              ' |,`|,'   | |  33     |"
            , "|               ,' /'     | | 3333    |"
            , "                            |     333 |"
            , ""
            , ": ansi                    :: red                     :"
            , "|                         || 22222222222222          |"
            , "|                         ||  22 222   2   22   22   |"
            , "|                         ||        999999  22222 22 |"
            , "|                    WWWW ||       1  9999      vv|| |"
            , "|                         ||          11122 2222     |"
            , "|                         ||               22        |"
            , "|                 WWW     ||    222222222            |"
            , "|                   WWW;  ||    22    2 222222       |"
            , "|                wwwwww   ||              2          |"
            , "|               ww ww     ||                         |"
            , "-"
            , ": plain          :          : ansi     :"
            , "| not that small |          :     WWWW |"
            , "| smaller        |"
            ]
        );

        this.assertEquals(2, result.length);

        var mixer:hase.utils.ColorMixer = new hase.utils.ColorMixer();
        mixer.plain = "-".code;
        mixer.red = "5".code;

        var red_dash:Symbol = mixer.merge();

        var got_it:Bool = false;

        result[0].image.map_(function(x:Int, y:Int, sym:Symbol) {
            if (y == 2 && x >= 9 && x <= 12) {
                this.assertEquals(red_dash, sym);
                got_it = true;
            }
        });

        this.assertTrue(got_it);

        var anim:Animation = new Animation(result);
        anim.fps = 1;

        this.root.add_child(anim);
        this.update();

        this.assert_area(
            [ " -.__,'``=.--__          "
            , "  __ `--   `   `.   ))   "
            , " ---:   -----.  ;__-' `. "
            , "     `-.  `--)      vv|| "
            , "          `--;; ,,''     "
            , "               <.        "
            , "    __.----._    ^;,     "
            , "    ,'    ' .'-.__ `||;  "
            , "              ' |,`|,'   "
            , "               ,' /'     "
            , "                         "
            ]
        );

        this.update();

        this.assert_area(
            [ " not that small "
            , " smaller        "
            , "                "
            ]
        );
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

    public function test_color_channels()
    {
        var result = this.parse_anim(
            [ ": plain  : red    : green  : blue   : grey   :"
            , "|        |        |        |        |        |"
            , "| red__0 | 123456 |        |        |        |"
            , "| green0 |        | 123456 |        |        |"
            , "| blue_0 |        |        | 123456 |        |"
            , "| grey_0 |        |        |        | abcdef |"
            , "| grey_1 |        |        |        | ghijkl |"
            , "| grey_2 |        |        |        | mnopqr |"
            , "| grey_3 |        |        |        | stuvwx |"
            , "| grey_4 |        |        |        | yz0123 |"
            , "|        |        |        |        |        |"
            ]
        );

        this.assertEquals(1, result.length);

        var expect:Array<Array<Int>> = [
            [ 52,  88, 124, 160, 196,  16],
            [ 22,  28,  34,  40,  46,  16],
            [ 17,  18,  19,  20,  21,  16],
            [232, 233, 234, 235, 236, 237],
            [238, 239, 240, 241, 242, 243],
            [244, 245, 246, 247, 248, 249],
            [250, 251, 252, 253, 254, 255],
            [ 16,  16,  16,  16,  16,  16],
        ];

        var max_x:Int = expect[0].length;
        var max_y:Int = expect.length;

        result[0].image.map_(function(x:Int, y:Int, sym:Symbol) {
            if (x >= 1 && x <= max_x && y >= 1 && y <= max_y)
                this.assertEquals(expect[y - 1][x - 1], sym.fgcolor);
            else
                this.assertEquals(7, sym.fgcolor);
        });
    }

    public function test_references()
    {
        var result = this.parse_anim(
            [ "+reference: !"
            , ": plain   :"
            , "|         |"
            , "| o     o |"
            , "|    !    |"
            , "| `-----' |"
            , "|         |"
            , "-"
            , "+reference: x"
            , ": plain   :"
            , "| !x    ! |"
            , "| .-----. |"
            ]
        );

        var anim:Animation = new Animation(result);
        anim.fps = 1;

        anim.x = 8;
        anim.y = 8;
        this.root.add_child(anim);

        this.update();

        this.assert_area(
            [ "         "
            , " o     o "
            , "         "
            , " `-----' "
            , "         "
            ], 4, 6
        );

        this.update();

        this.assert_area(
            [ "         "
            , "         "
            , " !     ! "
            , " .-----. "
            , "         "
            ], 6, 6
        );
    }

    public function test_references_with_color()
    {
        var result = this.parse_anim(
            [ "+reference: x"
            , ": plain   : ansi    :"
            , "|    _    |    w    |"
            , "|  (( )   |  ww w   |"
            , "|  ||/    |  www    |"
            , "| 9___)x  | rKKKK   |"
            , "|  `.`.   |  KKKK   |"
            , "|         |         |"
            ]
        );

        var anim:Animation = new Animation(result);

        anim.x = 6;
        anim.y = 3;
        this.root.add_child(anim);
        this.update();

        this.assert_area(
            [ "    _  "
            , "  (( ) "
            , "  ||/  "
            , " 9___) "
            , "  `.`. "
            , "       "
            ]
        );
    }

    public function test_references_with_coords()
    {
        var result = this.parse_anim(
            [ "+reference_x: 6"
            , "+reference_y: 3"
            , ": plain       :"
            , "|  __   ___   |"
            , "| {__}_{___}  |"
            , "|   {___}___  |"
            , "|  {__}_{___} |"
            , "|    {____}   |"
            , "|             |"
            ]
        );

        var anim:Animation = new Animation(result);

        anim.x = 6;
        anim.y = 3;
        this.root.add_child(anim);
        this.update();

        this.assert_area(
            [ "  __   ___   "
            , " {__}_{___}  "
            , "   {___}___  "
            , "  {__}_{___} "
            , "    {____}   "
            , "             "
            ]
        );
    }

    public function test_keyframes()
    {
        var result = this.parse_anim(
            [ "+key: happy"
            , ": plain   :"
            , "| o     o |"
            , "|    ^    |"
            , "| `-----' |"
            , "-"
            , "+key: happy"
            , ": plain   :"
            , "| O     O |"
            , "|    ^    |"
            , "| `-----' |"
            , "-"
            , "+key: meh"
            , ": plain   :"
            , "| o     o |"
            , "|    ^    |"
            , "| `-----. |"
            , "-"
            , "+key: meh"
            , ": plain   :"
            , "| o     o |"
            , "|    ^    |"
            , "| .-----' |"
            , "-"
            , "+key: sad"
            , ": plain   :"
            , "| o     o |"
            , "|    ^    |"
            , "| .-----. |"
            , "-"
            , "+key: sad"
            , ": plain   :"
            , "| O     O |"
            , "|    ^    |"
            , "| .-----. |"
            , "-"
            , "+key: sad"
            , ": plain   :"
            , "| X     X |"
            , "|    ^    |"
            , "| .-----. |"
            ]
        );

        var anim:Animation = new Animation(result);
        anim.fps = 1;
        anim.key = "meh";

        this.root.add_child(anim);

        this.update(2000);
        this.assert_area(
            [ " o     o "
            , "    ^    "
            , " `-----. "
            ]
        );

        this.update();
        this.assert_area(
            [ " o     o "
            , "    ^    "
            , " .-----' "
            ]
        );

        this.update();
        this.assert_area(
            [ " o     o "
            , "    ^    "
            , " `-----. "
            ]
        );

        anim.key = "happy";

        this.update();
        this.assert_area(
            [ " o     o "
            , "    ^    "
            , " `-----' "
            ]
        );

        this.update();
        this.assert_area(
            [ " O     O "
            , "    ^    "
            , " `-----' "
            ]
        );

        this.update();
        this.assert_area(
            [ " o     o "
            , "    ^    "
            , " `-----' "
            ]
        );

        anim.key = "sad";

        this.update();
        this.assert_area(
            [ " o     o "
            , "    ^    "
            , " .-----. "
            ]
        );

        this.update();
        this.assert_area(
            [ " O     O "
            , "    ^    "
            , " .-----. "
            ]
        );

        this.update();
        this.assert_area(
            [ " X     X "
            , "    ^    "
            , " .-----. "
            ]
        );

        this.update(5000);

        this.assert_area(
            [ " O     O "
            , "    ^    "
            , " .-----. "
            ]
        );
    }

    public function test_nonexisting_keyframe(?pi:haxe.PosInfos):Void
    {
        var result = this.parse_anim(
            [ "+key: existing"
            , ": plain   :"
            , "| o     o |"
            , "|    ^    |"
            , "| `-----' |"
            , "-"
            , "+key: existing"
            , ": plain   :"
            , "| O     O |"
            , "|    ^    |"
            , "| `-----' |"
            ]
        );

        var anim:Animation = new Animation(result);
        anim.fps = 1;
        anim.key = "nonexisting";

        this.root.add_child(anim);

        var thrown:Bool = true;
        try {
            this.update(2000);
            thrown = false;
        } catch (e:String) {
            this.assertEquals(e, "Unknown animation key \"nonexisting\".");
        }

        if (!thrown) {
            this.currentTest.done = true;

            this.currentTest.success = false;
            this.currentTest.error =
                "No exception thrown for nonexisting animation key.";
            this.currentTest.posInfos = pi;
            throw this.currentTest;
        }
    }

    public function test_single_keyframes():Void
    {
        var result = this.parse_anim(
            [ "+key: single"
            , ": plain    :"
            , "|  (_  _)  |"
            , "| : o^^o : |"
            , "| `._.._.' |"
            , "|  `-__-'  |"
            , "-"
            , "+key: two"
            , ": plain        :"
            , "|   __---.   . |"
            , "| ,'o;))  `-'| |"
            , "| `--___||.-.| |"
            , "|       `'   ` |"
            , "-"
            , "+key: two"
            , ": plain        :"
            , "|   __--^^   . |"
            , "| ,'o;))''`-'| |"
            , "| `--_____.-.| |"
            , "|            ` |"
            ]
        );

        var anim:Animation = new Animation(result);
        anim.fps = 1;

        this.root.add_child(anim);

        anim.key = "single";

        for (i in 0...10) {
            this.update();
            this.assert_area(
                [ "  (_  _)  "
                , " : o^^o : "
                , " `._.._.' "
                , "  `-__-'  "
                ]
            );
        }

        anim.key = "two";

        for (i in 0...10) {
            this.update();
            this.assert_area(
                [ "   __---.   . "
                , " ,'o;))  `-'| "
                , " `--___||.-.| "
                , "       `'   ` "
                ]
            );

            this.update();
            this.assert_area(
                [ "   __--^^   . "
                , " ,'o;))''`-'| "
                , " `--_____.-.| "
                , "            ` "
                ]
            );
        }
    }

    public function test_keyframes_and_other_containers():Void
    {
        var result = this.parse_anim(
            [ "+key: traffic_green"
            , ": plain  : green  :"
            , "|  .--.  |  5555  |"
            , "| | GG | | 5    5 |"
            , "| `.__.' | 555555 |"
            , "-"
            , "+key: traffic_yellow"
            , ": plain  : green  : red    :"
            , "|  .--.  |  5555  |  5555  |"
            , "| | YY | | 5    5 | 5    5 |"
            , "| `.__.' | 555555 | 555555 |"
            , "-"
            , "+key: traffic_red"
            , ": plain  : red    :"
            , "|  .--.  |  5555  |"
            , "| | RR | | 5    5 |"
            , "| `.__.' | 555555 |"
            ]
        );

        var anim:Animation = new Animation(result);
        anim.fps = 1;

        this.root.add_child(anim);

        anim.key = "traffic_green";
        this.update();
        this.assert_area(
            [ "  .--.  "
            , " | GG | "
            , " `.__.' "
            ]
        );

        this.update();
        this.assert_area(
            [ "  .--.  "
            , " | GG | "
            , " `.__.' "
            ]
        );

        anim.key = "traffic_yellow";
        this.update();
        this.update();
        this.update();
        this.update();
        this.update();
        this.update();
        this.assert_area(
            [ "  .--.  "
            , " | YY | "
            , " `.__.' "
            ]
        );

        anim.key = "traffic_red";
        this.update();
        this.update();
        this.update();
        this.update();
        this.assert_area(
            [ "  .--.  "
            , " | RR | "
            , " `.__.' "
            ]
        );
    }
}
