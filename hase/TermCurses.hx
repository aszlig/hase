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
package hase;

typedef TermSize = {
    var width:Int;
    var height:Int;
};

@:headerCode("#include <sys/ioctl.h>")
@:headerCode("#include <unistd.h>")

@:require(cpp) class TermCurses implements hase.display.ISurfaceProvider
{
    public var width:Int;
    public var height:Int;

    private var output:haxe.io.Output;

    public function new()
    {
        var ts:TermSize = this.get_termsize();

        this.width = ts.width;
        this.height = ts.height;

        this.output = Sys.stdout();
        this.write_csi("2J");
    }

    private inline function get_termsize():TermSize
    {
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
    }

    private function write_csi(sequence:String):Void
    {
        this.output.writeInt8(27);
        this.output.writeString("[" + sequence);
    }

    public function draw_char(x:Int, y:Int, sym:hase.display.Symbol):Void
    {
        this.write_csi('$y;${x}f');
        this.output.writeInt8(sym.ordinal);
    }
}
