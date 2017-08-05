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
package hase.term;

import hase.input.Key;
import hase.term.internal.Font;
import hase.geom.Rect;

@:require(js) class Canvas implements Interface
{
    #if debug
    // From https://goo.gl/mhxhqY minus dark colors:
    private static var DISTINCT_COLORS:Array<String> = [
        "#ffff00", "#1ce6ff", "#ff34ff", "#ff4a46", "#008941", "#006fa6",
        "#a30059", "#ffdbe5", "#7a4900", "#63ffac", "#b79762", "#004d43",
        "#8fb0ff", "#997d87", "#5a0007", "#809693", "#feffe6", "#1b4400",
        "#4fc601", "#3b5dff", "#4a3b53", "#ff2f80", "#61615a", "#ba0900",
        "#6b7900", "#00c2a0", "#ffaa92", "#ff90c9", "#b903aa", "#d16100",
        "#ddefff", "#7b4f4b", "#a1c299", "#300018", "#0aa6d8", "#013349",
        "#00846f", "#372101", "#ffb500", "#c2ffed", "#a079bf", "#cc0744",
        "#c0b9b2", "#c2ff99", "#001e09", "#00489c", "#6f0062", "#0cbd66",
        "#eec3ff", "#456d75", "#b77b68", "#7a87a1", "#788d66", "#885578",
        "#fad09f", "#ff8a9a", "#d157a0", "#bec459", "#456648", "#0086ed",
        "#886f4c", "#34362d", "#b4a8bd", "#00a6aa", "#452c2c", "#636375",
        "#a3c8c9", "#ff913f", "#938a81", "#575329", "#00fecf", "#b05b6f",
        "#8cd0ff", "#3b9700", "#04f757", "#c8a1a1", "#1e6e00", "#7900d7",
        "#a77500", "#6367a9", "#a05837", "#6b002c", "#772600", "#d790ff",
        "#9b9700", "#549e79", "#fff69f", "#201625", "#72418f", "#bc23ff",
        "#99adc0", "#3a2465", "#922329", "#5b4534", "#fde8dc", "#404e55",
        "#0089a3", "#cb7e98", "#a4e804", "#324e72", "#6a3a4c",
    ];
    #end

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

    public function clear(?sym:hase.display.Symbol):Void
    {
        this.ctx.fillStyle = "black";
        this.ctx.fillRect(0, 0, canvas.width, canvas.height);

        if (sym != null) {
            for (y in 0...this.height)
                for (x in 0...this.width)
                    this.draw_symbol(x, y, sym);
        }
    }

    private inline function cursor2x(x:Int):Int
    {
        #if debug
        if (x * Font.WIDTH > this.canvas.width)
            trace('X cursor value of ${x} at ${x * Font.WIDTH}' +
                  ' exceeds width of ${this.canvas.width} pixels!');
        #end

        return x * Font.WIDTH;
    }

    private inline function cursor2y(y:Int):Int
    {
        #if debug
        if (y * Font.HEIGHT > this.canvas.height)
            trace('Y cursor value of ${y} at ${y * Font.HEIGHT}' +
                  ' exceeds height of ${this.canvas.height} pixels!');
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

    private function draw_symbol(x:Int, y:Int, sym:hase.display.Symbol):Void
    {
        var cached:Int = this.font_cache.get(sym.get_hash());

        if (cached == null)
            cached = this.add_to_font_cache(sym);

        this.ctx.drawImage(
            this.font_canvas, cached, 0,
            Font.WIDTH, Font.HEIGHT,
            this.cursor2x(x), this.cursor2y(y),
            Font.WIDTH, Font.HEIGHT
        );
    }

    private function draw_area(rect:Rect, area:hase.display.Image):Void
    {
        area.map_(function(x:Int, y:Int, sym:hase.display.Symbol):Void {
            this.draw_symbol(rect.x + x, rect.y + y, sym);
        });

        #if debug
        if (hase.utils.Debug.show_dirty_rects) {
            var color:Int = Std.random(Canvas.DISTINCT_COLORS.length);
            this.ctx.strokeStyle = this.ctx.fillStyle =
                Canvas.DISTINCT_COLORS[color];

            this.ctx.strokeRect(
                this.cursor2x(rect.x),
                this.cursor2y(rect.y),
                area.width * Font.WIDTH,
                area.height * Font.HEIGHT
            );

            var desc:String = [
                for (name in hase.utils.Debug.current_sprites.keys())
                    '${name} (${hase.utils.Debug.current_sprites[name]})'
            ].join(", ");

            this.ctx.font = "12pt Helvetica";
            this.ctx.fillText(
                desc,
                this.cursor2x(rect.x) + 5,
                this.cursor2y(rect.y) + area.height * Font.HEIGHT - 5
            );

            hase.utils.Debug.current_sprites = new Map();
        }

        if (hase.utils.Debug.show_font_cache) {
            var stepsize:Int = Font.WIDTH * 80;
            var maxsteps:Int = Math.ceil(this.font_canvas.width / stepsize);

            var ystart:Int = this.canvas.height - maxsteps * Font.HEIGHT;

            this.ctx.strokeStyle = "red";
            this.ctx.strokeRect(
                5, ystart - 10, stepsize + 5, maxsteps * Font.HEIGHT + 5
            );

            this.ctx.fillStyle = "black";
            this.ctx.fillRect(
                5, ystart - 10, stepsize + 5, maxsteps * Font.HEIGHT + 5
            );

            for (i in 0...maxsteps) {
                this.ctx.drawImage(
                    this.font_canvas, stepsize * i, 0,
                    stepsize, Font.HEIGHT,
                    10, (ystart - 5) + Font.HEIGHT * i,
                    stepsize, Font.HEIGHT
                );
            }
        }
        #end
    }
}
