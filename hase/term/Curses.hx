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
package hase.term;

#if cpp
import hase.term.internal.RawTerm;
#end

typedef TermSize = {
    var width:Int;
    var height:Int;
};

@:require(cpp || neko) class Curses implements Interface
{
    public var width:Int;
    public var height:Int;

    private var output:haxe.io.Output;
    private var buffer:StringBuf;

    private var last_x:Int;
    private var last_y:Int;
    private var last_fg:Null<Int>;
    private var last_bg:Null<Int>;

    public function new()
    {
        this.output = Sys.stdout();

        var ts:TermSize = this.get_termsize();

        this.width = ts.width;
        this.height = ts.height;

        this.init_term();

        this.last_x = this.last_y = 0;
        this.last_fg = this.last_bg = null;
    }

    private inline function init_term():Void
    {
        #if cpp
        RawTerm.setraw();
        RawTerm.add_cleanup(inline function(signal:Int) {
            this.exit(1);
        });
        #end

        this.begin_op();

        this.buffer.add("\x1b7");
        this.write_csi("2J");
        this.write_csi("?25l");
        this.write_csi("0;0f");

        this.flush_op();
    }

    public inline function exit(code:Int):Void
    {
        this.begin_op();

        this.write_csi("?25h");
        this.write_csi("2J");
        this.buffer.add("\x1b8");

        this.flush_op();

        #if cpp
        RawTerm.unsetraw();
        RawTerm.remove_cleanups();
        RawTerm.exit_now(code);
        #end
    }

    private inline function get_termsize():TermSize
    {
        #if cpp
        untyped {
            __cpp__("static struct winsize ws");
            var rval = __cpp__("ioctl(STDOUT_FILENO, TIOCGWINSZ, &ws)");
            if (rval != 0)
                throw "Unable to get terminal size!";

            return {
                width: __cpp__("ws.ws_col"),
                height: __cpp__("ws.ws_row"),
            };
        };
        #else
        var lines:Null<String> = Sys.getEnv("LINES");
        var columns:Null<String> = Sys.getEnv("COLUMNS");

        if (lines == null || columns == null) {
            this.begin_op();
            this.write_csi("1000;1000H");
            this.write_csi("6n");
            this.flush_op();
            if (Sys.getChar(false) == 0x1b) {
                // Not using getChar && getChar because order of evaluation
                // might be backend-specific!
                if (Sys.getChar(false) == "[".code) {
                    lines = "";
                    columns = "";
                    var char:Int = 0;
                    while ((char = Sys.getChar(false)) != ";".code)
                        lines += String.fromCharCode(char);

                    while ((char = Sys.getChar(false)) != "R".code)
                        columns += String.fromCharCode(char);
                }
            }

            if (lines == null || columns == null)
                throw "Unable to get terminal size!";
        }

        return {
            width: Std.parseInt(columns),
            height: Std.parseInt(lines),
        };
        #end
    }

    private function begin_op():Void
    {
        this.buffer = new StringBuf();
    }

    private function flush_op():Void
    {
        this.output.writeString(this.buffer.toString());
    }

    private function write_csi(sequence:String):Void
    {
        this.buffer.add("\x1b[" + sequence);
    }

    private inline function set_color(?fg:Int, ?bg:Int):Void
    {
        var mods:Array<String> = [];

        if (fg != null && fg != this.last_fg) {
            mods.push("38;5;" + fg);
            this.last_fg = fg;
        }

        if (bg != null && bg != this.last_bg) {
            mods.push("48;5;" + bg);
            this.last_bg = bg;
        }

        if (mods.length > 0)
            this.write_csi(mods.join(";") + "m");
    }

    public function draw_char(x:Int, y:Int, sym:hase.display.Symbol):Void
    {
        this.begin_op();

        if (this.last_y != y || this.last_x != x)
            this.write_csi('${y + 1};${x + 1}f');

        this.set_color(sym.fgcolor, sym.bgcolor);
        this.buffer.addChar(sym.ordinal);

        this.last_x = x >= this.width ? x : x + 1;
        this.last_y = y;

        this.flush_op();
    }
}
