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
package hase.utils;

import hase.display.Image;
import hase.display.Symbol;
import hase.geom.Rect;

import hase.utils.ParserTypes;

private typedef Box = {
    var headers:Array<Rect>;
    var body:Rect;
};

private class Border
{
    public var x(default, null):Int;
    public var y(default, null):Int;
    public var length(default, null):Int;
    public var headings(default, null):Array<Int>;

    public var content_x(get, null):Int;
    public var content_y(get, null):Int;
    public var content_length(get, null):Int;

    public function new(x:Int, y:Int, heading:Bool = false)
    {
        this.x = x;
        this.y = y;
        this.length = 1;
        this.headings = heading ? [y] : new Array();
    }

    public function merge(border:Border):Bool
    {
        if (this.x != border.x)
            return false;

        if (this.headings.length > 0 && border.headings.length > 0 &&
            this.length > this.headings.length)
            return false;

        if (this.y + this.length == border.y) {
            this.length += border.length;
            this.headings.concat(border.headings);
            return true;
        }

        return false;
    }

    private inline function get_content_x():Int
        return this.x;

    private inline function get_content_y():Int
        return this.y + this.headings.length;

    private inline function get_content_length():Int
        return this.length - this.headings.length;
}

private class BorderGroup
{
    private var index:Map<Int, Array<Int>>;
    private var borders:Array<Border>;

    public function new()
    {
        this.borders = new Array();
        this.index = new Map();
    }

    public function add(border:Border):Void
    {
        var idx:Null<Array<Int>> = this.index.get(border.x);

        if (idx != null) {
            for (i in idx)
                if (this.borders[i].merge(border))
                    return;
        }

        this.index.set(border.x, [this.borders.length]);
        this.borders.push(border);
    }

    private function get_single_box(maxwidth:Int):Null<Box>
    {
        var biggest:Null<Border> = Lambda.fold(this.borders,
            function(b:Border, acc:Border) {
                if (acc == null) return null;
                else if (acc.headings.length > 0) return null;
                else if (b.x < acc.x) return b;
                else if (b.length > acc.length) return b;
                else return acc;
            }, this.borders[0]);

        return biggest == null ? null : {
            headers: new Array(),
            body: new Rect(biggest.x + 1, biggest.y,
                           maxwidth - biggest.x - 1,
                           biggest.length)
        };
    }

    private function get_real_borders():Array<Border>
    {
        var real_borders:Array<Border> = new Array();

        for (current in this.borders) {
            var bcount:Int = Lambda.count(this.borders, function(b:Border) {
                return current.y == b.y && current.length == b.length;
            });

            if (bcount >= 2)
                real_borders.push(current);
        }

        return real_borders;
    }

    private function get_box_rect(box:Box):Rect
    {
        var area:Rect = box.body;
        for (hdr in box.headers)
            area = area.union(hdr);
        return area;
    }

    private function remove_inner(boxes:Array<Box>):Array<Box>
    {
        var outer:Array<Box> = new Array();

        var rects:Array<Rect> = [for (b in boxes) this.get_box_rect(b)];

        for (box in boxes) {
            var area:Rect = this.get_box_rect(box);

            if (area.width <= 0 || area.height <= 0)
                continue;

            var intersections:Int = Lambda.count(rects, function(r:Rect) {
                return !area.matches(r) && area.intersects(r) && area.y > r.y;
            });

            if (intersections == 0)
                outer.push(box);
        }

        return outer;
    }

    private function
        find_matching_border(left:Border, haystack:Array<Border>):Null<Border>
    {
        for (needle in haystack) {
            if (left.x >= needle.x) continue;
            if (left.y != needle.y) continue;
            if (left.length != needle.length) continue;
            if (left.headings.length != needle.headings.length) continue;

            var same_headings:Bool = true;

            for (i in 0...left.headings.length) {
                if (left.headings[i] != needle.headings[i]) {
                    same_headings = false;
                    break;
                }
            }

            if (!same_headings) continue;

            return needle;
        }

        return null;
    }

    public function get_boxes(maxwidth:Int):Array<Box>
    {
        var single_box:Box = this.get_single_box(maxwidth);
        if (single_box != null)
            return [single_box];

        var boxparts:Array<Border> =
            [for (b in this.get_real_borders()) if (b.headings.length > 0) b];

        boxparts.sort(function(a:Border, b:Border)
                      return Reflect.compare(a.x, b.x));

        var boxes:Array<Box> = new Array();

        for (l in 0...boxparts.length) {
            var left:Border = boxparts[l];
            var right:Null<Border> = this.find_matching_border(left, boxparts);

            if (right == null)
                continue;

            boxes.push({
                headers: [
                    for (h in left.headings)
                    new Rect(left.x + 1, h, right.x - left.x - 1, 1)
                ],
                body: new Rect(
                    left.content_x + 1, left.content_y,
                    right.content_x - left.content_x - 1,
                    right.content_length
                )
            });
        }

        return this.remove_inner(boxes);
    }
}

class FrameAreaParser
{
    private var area:Image;

    public function new(area:Image)
        this.area = area;

    private function parse_boxes():Array<Box>
    {
        var borders:BorderGroup = new BorderGroup();

        this.area.map_(function(x:Int, y:Int, sym:Symbol) {
            if (sym == ":".code) borders.add(new Border(x, y, true))
            else if (sym == "|".code) borders.add(new Border(x, y));
        });

        return borders.get_boxes(this.area.width);
    }

    public function parse_header(header:Rect):Null<Header>
    {
        var raw:Array<Array<Symbol>> =
            this.area.extract_rect(header).to_2d_array();

        var plain:String = StringTools.trim(
            [for (r in raw) [for (c in r) c.toString()].join("")].join("")
        );

        return switch (plain) {
            case "plain": Variant(Plain);
            case "ansi": Variant(Color16);
            case "red": Variant(ColorRed);
            case "green": Variant(ColorGreen);
            case "blue": Variant(ColorBlue);
            case "grey": Variant(ColorGrey);
            default: null;
        };
    }

    public function parse():Array<Container>
    {
        var result:Array<Container> = new Array();

        for (box in this.parse_boxes()) {
            var headers:Array<Header> = new Array();
            var invalid_header:Bool = false;

            for (h in box.headers) {
                var header:Null<Header> = this.parse_header(h);
                if (header == null) invalid_header = true;
                else headers.push(header);
            }

            if (invalid_header)
                continue;

            result.push({
                headers: headers,
                body: this.area.extract_rect(box.body)
            });
        }

        return result;
    }
}
