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
package hase.utils;

import hase.display.Animation;
import hase.display.Image;
import hase.display.Symbol;
import hase.geom.Raster;

import hase.utils.ParserTypes;

class AnimationParser
{
    private static var attr_re:EReg = ~/^([^:]+): *(.+)$/;
    private static var frame_re:EReg = ~/^[-=].*$/gm;

    private var framedata:Array<String>;

    public function new(data:String)
        this.framedata = AnimationParser.frame_re.split(data);

    private function apply_refchar(frame:FrameData, refchar:Symbol):FrameData
    {
        frame.image = frame.image.map(
            function(x:Int, y:Int, sym:Symbol) {
                if (sym.ordinal == refchar.ordinal) {
                    frame.refpoint_x = x;
                    frame.refpoint_y = y;
                    return new Symbol(0, sym.fgcolor, sym.bgcolor);
                }

                return sym;
            }, 0
        );

        return frame;
    }

    private function
        flood_fill(x:Int, y:Int, img:Raster<Symbol>):Raster<Symbol>
    {
        var queue:Array<{ x:Int, y:Int }> = new Array();

        queue.push({ x: x, y: y });

        while (queue.length > 0) {
            var current:{ x:Int, y:Int } = queue.pop();
            var x = current.x;
            var y = current.y;

            if (img.get(x, y).ordinal == " ".code) {
                img.set(x, y, 0);

                if (x < img.width - 1)
                    queue.push({ x: x + 1, y: y });
                if (x > 0)
                    queue.push({ x: x - 1, y: y });
                if (y < img.height - 1)
                    queue.push({ x: x, y: y + 1 });
                if (y > 0)
                    queue.push({ x: x, y: y - 1 });
            }
        }

        return img;
    }

    private function apply_alpha(image:Raster<Symbol>):Raster<Symbol>
    {
        // start from one of the corners
        for (x in [0, image.width - 1])
            for (y in [0, image.height - 1])
                if (image.get(x, y).ordinal == " ".code)
                    return this.flood_fill(x, y, image);

        return image;
    }

    private function parse_header(data:String):Header
    {
        var r:EReg = AnimationParser.attr_re;
        // attributes
        if (r.match(data)) {
            var maybe_int:Null<Int> =
                Std.parseInt(r.matched(2));
            if (maybe_int != null)
                return IntAttr(r.matched(1), maybe_int);
            else if (r.matched(2).length == 1)
                return ChrAttr(r.matched(1),
                               new Symbol(r.matched(2).charCodeAt(0)));
            else
                return StrAttr(r.matched(1), r.matched(2));
        // variants
        } else {
            var variant:Variant = switch (StringTools.trim(data)) {
                case "plain": Plain;
                case "ansi": Color16;
                case "red": ColorRed;
                case "green": ColorGreen;
                case "blue": ColorBlue;
                case "grey": ColorGrey;
                default: throw 'Unable to parse header "$data"!';
            };

            return Variant(variant);
        }
    }

    private function parse_frame(data:String):Array<Container>
    {
        var global_headers:Array<Header> = new Array();
        var container_data:Array<String> = new Array();

        for (line in data.split("\n")) {
            if (StringTools.startsWith(line, "+"))
                global_headers.push(this.parse_header(line.substr(1)));
            else if (line.indexOf("|") != -1 || line.indexOf(":") != -1)
                container_data.push(line);
        }

        var container_area:Raster<Symbol> = Raster.from_2d_array([
            for (line in container_data)
                [for (c in 0...line.length) line.charCodeAt(c)]
        ], 0);

        var containers:Array<Container> = new Array();

        for (c in (new FrameAreaParser(container_area).parse())) {
            containers.push({
                headers: global_headers.copy().concat(c.headers),
                body: c.body,
            });
        }

        return containers;
    }

    private function merge_containers(containers:Array<Container>):Container
    {
        if (containers.length == 1)
            return containers[0];

        var merged:Raster<ColorMixer> = Raster.from_2d_array([
            for (y in 0...containers[0].body.height)
                [for (x in 0...containers[0].body.width) new ColorMixer()]
        ], new ColorMixer());

        var headers:Array<Header> = new Array();

        for (container in containers) {
            for (header in container.headers) {
                headers.push(header);

                var merger = function(cm:ColorMixer, sym:Symbol):ColorMixer {
                    switch (header) {
                        case Variant(Plain):      cm.plain = sym.ordinal;
                        case Variant(Color16):    cm.ansi  = sym.ordinal;
                        case Variant(ColorRed):   cm.red   = sym.ordinal;
                        case Variant(ColorGreen): cm.green = sym.ordinal;
                        case Variant(ColorBlue):  cm.blue  = sym.ordinal;
                        case Variant(ColorGrey):  cm.grey  = sym.ordinal;
                        default:
                    };

                    return cm;
                };

                merged = merged.zip(container.body, merger, new ColorMixer());
            }
        }

        return {
            headers: headers,
            body: merged.map(
                function(x, y, cm:ColorMixer) return cm.merge(), 0
            )
        }
    }

    public function parse():Array<FrameData>
    {
        var frames:Array<FrameData> = new Array();

        var parsed:Array<Array<Container>> =
            [for (f in this.framedata) this.parse_frame(f)];

        for (frame in parsed) {
            var merged:Container = merge_containers(frame);

            var framedata:FrameData = {
                image: merged.body
            };

            for(header in merged.headers) {
                switch (header) {
                    case ChrAttr("reference", c):
                        framedata = this.apply_refchar(framedata, c);
                    case IntAttr("reference_x", xref):
                        framedata.refpoint_x = xref;
                    case IntAttr("reference_y", yref):
                        framedata.refpoint_y = yref;
                    case StrAttr("key", key):
                        framedata.key = key;
                    default:
                }
            }

            framedata.image = this.apply_alpha(framedata.image);

            frames.push(framedata);
        }

        return frames;
    }

    #if macro
    public static function parse_file(path:String):Array<FrameData>
    {
        return new AnimationParser(sys.io.File.getContent(path)).parse();
    }
    #end
}
