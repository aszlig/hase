package jascii.test;

class SurfaceTestCase extends haxe.unit.TestCase
{
    var root:jascii.display.Surface;
    var test_canvas:jascii.test.TestCanvas;

    public override function setup():Void
    {
        this.test_canvas = new jascii.test.TestCanvas();
        this.root = new jascii.display.Surface(this.test_canvas);
    }

    public function create_image(data:Array<String>):Array<Array<Int>>
    {
        var img:Array<Array<Int>> = new Array();

        for (row in data) {
            var introw:Array<Int> = new Array();

            for (x in 0...row.length)
                introw.push(row.charCodeAt(x) == " ".code
                            ? 0 : row.charCodeAt(x));

            img.push(introw);
        }

        return img;
    }

    public function
        create_animation(frames:Array<Array<String>>):jascii.display.Animation
    {
        var new_frames:Array<Array<Array<Int>>> = new Array();

        for (frame in frames)
            new_frames.push(this.create_image(frame));

        return new jascii.display.Animation(new_frames);
    }

    private function format_expect(expect:Array<String>, got:Array<String>)
    {
        var ewidth:Int = expect[0].length;
        var eheight:Int = expect.length;

        var gwidth:Int = got[0].length;
        var gheight:Int = got.length;

        var eheader:String = "," + StringTools.rpad("", "-", ewidth) + ".";
        var gheader:String = "," + StringTools.rpad("", "-", gwidth) + ".";

        var efooter:String = "`" + StringTools.rpad("", "-", ewidth) + "'";
        var gfooter:String = "`" + StringTools.rpad("", "-", gwidth) + "'";

        var out:String = "\n";
        out += StringTools.rpad(" Expected:", " ", ewidth + 4) + "Got:";
        out += "\n" + eheader + " " + gheader + "\n";

        for (y in 0...gheight)
            out += "|" + expect[y] + "| |" + got[y] + "|\n";

        out += efooter + " " + gfooter;

        return out;
    }

    public function assert_area( expect:Array<String>
                               , x:Int, y:Int
                               , width:Int, height:Int
                               , ?pi:haxe.PosInfos
                               ):Void
    {
        this.currentTest.done = true;

        var fraction:Array<String> =
            this.test_canvas.extract(x, y, width, height);

        var match:Bool = true;

        var maxlen:Int = fraction.length > expect.length
                       ? fraction.length : expect.length;

        for (i in 0...maxlen)
            if (expect[i] != fraction[i])
                match = false;

        if (!match) {
            currentTest.success = false;
            currentTest.error = this.format_expect(expect, fraction);
            currentTest.posInfos = pi;
            throw currentTest;
        };
    }
}
