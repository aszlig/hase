package jascii.utils;

import jascii.display.Animation;
import jascii.display.Image;
import jascii.display.Symbol;

class AnimationParser
{
    private var data:Array<String>;

    public function new(data:String)
        this.data = data.split("\n");

    private function apply_refchar(frame:FrameData, refchar:Symbol):FrameData
    {
        frame.image = frame.image.map(
            inline function(x:Int, y:Int, sym:Symbol) {
                if (sym == refchar) {
                    frame.refpoint_x = x;
                    frame.refpoint_y = y;
                    return new Symbol(0);
                }

                return sym;
            }
        );

        return frame;
    }

    private function flood_fill(x:Int, y:Int, img:Image):Image
    {
        var queue:Array<{ x:Int, y:Int }> = new Array();

        queue.push({ x: x, y: y });

        while (queue.length > 0) {
            var current:{ x:Int, y:Int } = queue.pop();
            var x = current.x;
            var y = current.y;

            if (img.get(x, y) == " ".code) {
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

    private function apply_alpha(image:Image):Image
    {
        // start from one of the corners
        for (x in [0, image.width - 1])
            for (y in [0, image.height - 1])
                if (image.get(x, y) == " ".code)
                    return this.flood_fill(x, y, image);

        return image;
    }

    public function parse():Array<FrameData>
    {
        var frames:Array<FrameData> = new Array();
        var refchars:Array<Null<Symbol>> = new Array();

        var refchar:Null<Int> = null;

        for (line in this.data) {
            var delim:Int = line.indexOf(" ");
            var until_space:String = line.substr(0, delim);
            var frame_id:Null<Int> = Std.parseInt(until_space);

            if (frame_id == null) {
                if (StringTools.endsWith(until_space, ":")) {
                    var value:String = line.substr(delim + 1);
                    switch (line.substr(0, delim - 1)) {
                        case "reference": refchar = value.charCodeAt(0);
                    }
                }
                continue;
            }

            var content:String = line.substr(delim + 1);

            var row:Array<Symbol> = new Array();

            for (pos in 0...content.length)
                row.push(content.charCodeAt(pos));

            if (frames[frame_id] == null) {
                refchars.push(refchar);
                refchar = null;
                frames.insert(frame_id, {image: [row]});
            } else {
                frames[frame_id].image.add_row(row);
            }
        }

        for (i in 0...frames.length)
            if (refchars[i] != null)
                frames[i] = this.apply_refchar(frames[i], refchars[i]);

        for (i in 0...frames.length)
            frames[i].image = this.apply_alpha(frames[i].image);

        return frames;
    }

    public static function parse_file(path:String):Array<FrameData>
    {
        return new AnimationParser(sys.io.File.getContent(path)).parse();
    }
}
