package jascii.test.cases;

import jascii.display.Animation;
import jascii.display.Image;
import jascii.display.Symbol;

class AnimationParserTest extends haxe.unit.TestCase
{
    private function parse_anim(data:Array<String>):Array<FrameData>
    {
        return (new jascii.utils.AnimationParser(data.join("\n"))).parse();
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

    public function test_oneframe()
    {
        var result = this.parse_anim(
            [ "|    _...._     _...._    "
            , "|  .' .-'~       ~`-. `.  "
            , "| (  (               )  ) "
            , "| (  `.             .'  ) "
            , "| `.   `.,       ,.'   .' "
            , "|   `,  .`-._ _.-'.  ,'   "
            , "|     |' _   ~   _ `|     "
            , "|     |.'*`.   .'*`.|     "
            , "|     |`-, '' `` ,-'|     "
            , "|     |    .-^-.    |     "
            , "|     `-|   `^'   |-'     "
            , "|       |_.'. .'._|       "
            , "|         ||vvv||         "
            , "|         :.^^^.:         "
            , "|         (     )         "
            ]
        );

        this.assertEquals(1, result.length);
        this.assertEquals(25, result[0].image.width);
        this.assertEquals(15, result[0].image.height);
    }

    public function test_complex_ansi_color()
    {
        var result = this.parse_anim(
            [ "plain                     | ansi                    |"
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
        this.assertEquals(15, result[0].image.height);
    }
}
