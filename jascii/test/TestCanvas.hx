package jascii.test;

class TestCanvas implements jascii.display.ISurface
{
    public var width:Int;
    public var height:Int;

    private var area:Array<jascii.display.Symbol>;

    public function new()
    {
        this.width = 40;
        this.height = 15;

        this.area = new Array();

        for (i in 0...(this.width * this.height))
            this.area.push(new jascii.display.Symbol(" ".code));
    }

    public function draw_char(x:Int, y:Int, sym:jascii.display.Symbol):Void
    {
        this.area[y * this.width + x] = sym;
    }

    public function extract(x:Int, y:Int, width:Int, height:Int):Array<String>
    {
        var out:Array<String> = new Array();
        var buf:String = "";

        for (c in 0...this.area.length) {
            if (c > 0 && c % this.width == 0 && buf.length > 0) {
                out.push(buf);
                buf = "";
            }

            var cur_x:Int = c % this.width;
            var cur_y:Int = Std.int(c / this.width);

            if (cur_x < x || cur_x >= x + width)
                continue;

            if (cur_y < y || cur_y >= y + height)
                continue;

            buf += String.fromCharCode(this.area[c].ordinal);
        }

        return out;
    }

    public function toString():String
    {
        var out:String = "\n,";

        out += StringTools.rpad("", "-", this.width) + ".\n|";

        for (c in 0...this.area.length) {
            if (c > 0 && c % this.width == 0)
                out += "|\n|";

            out += String.fromCharCode(this.area[c].ordinal);
        }

        out += "|\n`" + StringTools.rpad("", "-", this.width) + "'";

        return out;
    }
}
