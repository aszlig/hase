package jascii.macro;

import jascii.macro.Types;

class Animation
{
    public static function parse_file(path:String):Array<AnimData>
    {
        var lines:Array<String> = sys.io.File.getContent(path).split("\n");

        var data:Array<AnimData> = new Array();

        for (line in lines) {
            var delim:Int = line.indexOf(" ");
            var frame_id:Null<Int> = Std.parseInt(line.substr(0, delim));
            if (frame_id == null)
                continue;

            var content:String = line.substr(delim + 1);

            var row:Array<Int> = new Array();

            for (pos in 0...content.length) {
                var char:Int = content.charCodeAt(pos);

                if (char == " ".code)
                    row.push(0);
                else
                    row.push(char);
            }

            if (data[frame_id] == null)
                data.insert(frame_id, {frame: [row], options: new Hash()});
            else
                data[frame_id].frame.push(row);
        }

        return data;
    }
}
