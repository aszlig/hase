package jascii.display;

import haxe.macro.Expr;

class Animation extends Image
{
    private var frames:Array<Array<String>>;
    private var current:Int;

    private var td:Int;
    public var factor:Int;

    public function new(?frames = null)
    {
        super();

        if (frames == null)
            frames = new Array();

        this.frames = frames;
        this.current = 0;

        this.td = 0;
        this.factor = 1;
    }

    @:macro public static function from_file(path:String):Expr
    {
        var lines:Array<String> = sys.io.File.getContent(path).split("\n");

        var frames:Array<Array<String>> = new Array();

        for (line in lines) {
            var delim:Int = line.indexOf(" ");
            var frame_id:Null<Int> = Std.parseInt(line.substr(0, delim));
            if (frame_id == null)
                continue;

            var content:String = line.substr(delim + 1);

            if (frames[frame_id] == null)
                frames.insert(frame_id, [content]);
            else
                frames[frame_id].push(content);
        }

        var expr_array:Array<Expr> = new Array();

        for (frame in frames) {
            var row_array:Array<Expr> = new Array();

            for (row in frame)
                row_array.push({
                    expr: EConst(CString(row)),
                    pos: haxe.macro.Context.currentPos()
                });


            expr_array.push({
                expr: EArrayDecl(row_array),
                pos: haxe.macro.Context.currentPos()
            });
        }

        var frames_expr:Expr = {
            expr: EArrayDecl(expr_array),
            pos: haxe.macro.Context.currentPos()
        };

        return {
            expr: ENew({
                name: "Animation",
                pack: ["jascii", "display"],
                params: []
            }, [frames_expr]),
            pos: haxe.macro.Context.currentPos()
        };
    }

    public inline function add_frame(frame:Array<String>):Array<String>
    {
        this.frames.push(frame);
        return frame;
    }

    public override function update():Void
    {
        if (this.frames.length == 0)
            return;

        this.data = this.frames[this.current];
        super.update();

        if (++this.td >= this.factor) {
            if (++this.current >= this.frames.length)
                this.current = 0;

            this.td = 0;
        }
    }
}
