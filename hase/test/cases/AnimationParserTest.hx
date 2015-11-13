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

        result[0].image.map_(inline function(x:Int, y:Int, sym:Symbol) {
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
        anim.key = "happy";

        this.root.add_child(anim);

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

        anim.key = "meh";

        this.update();
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

        this.update();
        this.update();
        this.update();
        this.update();
        this.update();

        this.assert_area(
            [ " O     O "
            , "    ^    "
            , " .-----. "
            ]
        );
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
}
