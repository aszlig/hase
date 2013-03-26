package jascii.macro;

import haxe.macro.Expr;
import jascii.macro.Types;

class Animation
{
    public static function apply_options(data:AnimData):AnimData
    {
        if (data.raw_options.exists("reference")) {
            var refchar:Int = data.raw_options.get("reference").charCodeAt(0);
            for (y in 0...data.frame.length) {
                for (x in 0...data.frame[y].length) {
                    if (data.frame[y][x] != refchar)
                        continue;

                    data.raw_options.remove("reference");
                    data.options.set("refpoint_x", EConst(CInt(Std.string(x))));
                    data.options.set("refpoint_y", EConst(CInt(Std.string(y))));
                    data.frame[y][x] = 0;
                }
            }
        }

        return data;
    }

    public static function
        flood_fill(x:Int, y:Int, frame:Array<Array<Int>>):Array<Array<Int>>
    {
        var queue:Array<{ x:Int, y:Int }> = new Array();

        queue.push({ x: x, y: y });

        while (queue.length > 0) {
            var current:{ x:Int, y:Int } = queue.pop();
            var x = current.x;
            var y = current.y;

            if (frame[y][x] == " ".code) {
                frame[y][x] = 0;

                if (x < frame[y].length - 1)
                    queue.push({ x: x + 1, y: y });
                if (x > 0)
                    queue.push({ x: x - 1, y: y });
                if (y < frame.length - 1)
                    queue.push({ x: x, y: y + 1 });
                if (y > 0)
                    queue.push({ x: x, y: y - 1 });
            }
        }

        return frame;
    }

    public static function
        apply_alpha(frame:Array<Array<Int>>):Array<Array<Int>>
    {
        // start from one of the corners
        for (y in [0, frame.length - 1])
            for (x in [0, frame[y].length - 1])
                if (frame[y][x] == " ".code)
                    return Animation.flood_fill(x, y, frame);

        return frame;
    }

    public static function parse_file(path:String):Array<AnimData>
    {
        var lines:Array<String> = sys.io.File.getContent(path).split("\n");

        var data:Array<AnimData> = new Array();

        var kvmap:Hash<String> = new Hash();

        for (line in lines) {
            var delim:Int = line.indexOf(" ");
            var until_space:String = line.substr(0, delim);
            var frame_id:Null<Int> = Std.parseInt(until_space);
            if (frame_id == null) {
                if (StringTools.endsWith(until_space, ":")) {
                    var key:String = line.substr(0, delim - 1);
                    var value:String = line.substr(delim + 1);
                    kvmap.set(key, value);
                }
                continue;
            }

            var content:String = line.substr(delim + 1);

            var row:Array<Int> = new Array();

            for (pos in 0...content.length)
                row.push(content.charCodeAt(pos));

            if (data[frame_id] == null)
                data.insert(frame_id, {
                    frame: [row],
                    raw_options: kvmap,
                    options: new Hash()
                });
            else
                data[frame_id].frame.push(row);

            kvmap = new Hash();
        }

        for (i in 0...data.length)
            data[i] = Animation.apply_options(data[i]);

        for (i in 0...data.length)
            data[i].frame = Animation.apply_alpha(data[i].frame);

        return data;
    }
}