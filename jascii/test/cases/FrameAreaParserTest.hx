package jascii.test.cases;

import jascii.display.Image;
import jascii.display.Symbol;

class FrameAreaParserTest extends haxe.unit.TestCase
{
    private function parse(data:Array<String>):Array<Image>
    {
        var img:Image = [
            for (row in data) [for (c in 0...row.length) row.charCodeAt(c)]
        ];
        return (new jascii.utils.FrameAreaParser(img)).parse();
    }

    private inline function assert_row(row:String, actual:Image, pos:Int):Void
    {
        this.assertEquals(row.length, actual.width);
        actual.map_(inline function(x:Int, y:Int, sym:Symbol) {
            if (y == pos) this.assertEquals(new Symbol(row.charCodeAt(x)), sym);
        });
    }

    public function test_simple():Void
    {
        var result:Array<Image> = this.parse(
            [ "| XXX"
            , "| XXX"
            , "| XXX"
            ]
        );

        this.assert_row("XXX", result[0], 0);
        this.assert_row("XXX", result[0], 1);
        this.assert_row("XXX", result[0], 2);
    }

    public function test_heading():Void
    {
        var result:Array<Image> = this.parse(
            [ ": plain :"
            , "| XXX   |"
            , "| XXX   |"
            , "| XXX   |"
            ]
        );

        this.assert_row("XXX", result[0], 0);
        this.assert_row("XXX", result[0], 1);
        this.assert_row("XXX", result[0], 2);
    }
}
