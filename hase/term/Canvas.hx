/* Copyright (C) 2013-2017 aszlig
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

import hase.input.Key;
import hase.term.internal.Font;
import hase.geom.Rect;

@:require(js) class Canvas implements Interface
{
    private var canvas:js.html.CanvasElement;
    private var ctx:js.html.CanvasRenderingContext2D;

    private var font:Font;
    private var font_cache:Map<Int,Int>;
    private var font_canvas:js.html.CanvasElement;

    private var key_queue:List<js.html.KeyboardEvent>;

    private var renderer:hase.term.renderer.Interface;

    public var width:Int;
    public var height:Int;

    public function new(canvas:js.html.CanvasElement)
    {
        this.canvas = canvas;

        this.key_queue = new List();
        js.Browser.window.addEventListener(
            "keypress", this.key_queue.add, false
        );

        this.renderer = new hase.term.renderer.CharRenderer(this);

        this.width = Std.int(canvas.width / Font.WIDTH);
        this.height = Std.int(canvas.height / Font.HEIGHT);

        this.ctx = canvas.getContext2d();
        this.ctx.fillStyle = "black";
        this.ctx.fillRect(0, 0, canvas.width, canvas.height);

        this.font = new Font();
        this.font_cache = new Map();
        this.font_canvas = null;
    }

    public inline function exit(code:Int):Void
        js.Browser.document.body.removeChild(this.canvas);

    public inline function get_key():Key
    {
        var key:Null<js.html.KeyboardEvent> = this.key_queue.pop();
        if (key == null)
            return None;

        return Char(key.charCode);
    }

    private inline function cursor2x(x:Int):Int
    {
#if debug
        if (x * Font.WIDTH > this.canvas.width)
            trace("X cursor value of " + x + " exceeds width of " +
                  this.canvas.width + " pixels!");
#end

        return x * Font.WIDTH;
    }

    private inline function cursor2y(y:Int):Int
    {
#if debug
        if (y * Font.HEIGHT > this.canvas.height)
            trace("Y cursor value of " + y + " exceeds height of " +
                  this.canvas.height + " pixels!");
#end

        return y * Font.HEIGHT;
    }

    private inline function add_to_font_cache(sym:hase.display.Symbol):Int
    {
        var cachedata:js.html.ImageData =
            this.ctx.createImageData(Font.WIDTH, Font.HEIGHT);

        var fgcolor:Int = hase.display.Color.get_rgb(sym.fgcolor);
        var bgcolor:Int = hase.display.Color.get_rgb(sym.bgcolor);

        var i:Int = 0;
        for (row in this.font.iter_char(sym.ordinal)) {
            for (val in row) {
                cachedata.data[i++] = val ? fgcolor >> 16 & 0xff
                                          : bgcolor >> 16 & 0xff;
                cachedata.data[i++] = val ? fgcolor >> 8  & 0xff
                                          : bgcolor >> 8  & 0xff;
                cachedata.data[i++] = val ? fgcolor       & 0xff
                                          : bgcolor       & 0xff;
                cachedata.data[i++] = 0xff;
            }
        }

        var cached:Int =
            (this.font_canvas == null ? 0 : this.font_canvas.width);

        var new_canvas:js.html.CanvasElement =
            js.Browser.document.createCanvasElement();

        new_canvas.width = cached + Font.WIDTH;
        new_canvas.height = Font.HEIGHT;

        var new_context:js.html.CanvasRenderingContext2D =
            new_canvas.getContext2d();

        if (cached > 0)
            new_context.drawImage(this.font_canvas, 0, 0);

        new_context.putImageData(cachedata, cached, 0);

        this.font_cache.set(sym.get_hash(), cached);
        this.font_canvas = new_canvas;
        return cached;
    }

    private function draw_area(rect:Rect, area:hase.display.Image):Void
    {
        area.map_(function(x:Int, y:Int, sym:hase.display.Symbol):Void {
            var cached:Int = this.font_cache.get(sym.get_hash());

            if (cached == null)
                cached = this.add_to_font_cache(sym);

            this.ctx.drawImage(this.font_canvas,
                cached, 0, Font.WIDTH, Font.HEIGHT,
                this.cursor2x(rect.x + x), this.cursor2y(rect.y + y),
                Font.WIDTH, Font.HEIGHT);
        });
    }
}
