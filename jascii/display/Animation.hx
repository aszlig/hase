package jascii.display;

import haxe.macro.Expr;

class Animation extends Sprite
{
    private var frames:Array<Array<Array<Int>>>;
    private var current:Int;

    private var td:Int;
    public var factor:Int;

    public var loopback:Bool;

    public function new(?frames = null)
    {
        super();

        if (frames == null)
            frames = new Array();

        this.frames = frames;
        this.current = 0;

        this.td = 0;
        this.factor = 1;

        this.loopback = false;

        this.grow_sprite();
    }

    @:macro public static function from_file(path:String):Expr
    {
        var lines:Array<String> = sys.io.File.getContent(path).split("\n");

        var frames:Array<Array<Array<Int>>> = new Array();

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

            if (frames[frame_id] == null)
                frames.insert(frame_id, [row]);
            else
                frames[frame_id].push(row);
        }

        var expr_array:Array<Expr> = new Array();

        for (frame in frames) {
            var row_array:Array<Expr> = new Array();

            for (row in frame) {
                var col_array:Array<Expr> = new Array();

                for (col in row) {
                    col_array.push({
                        expr: EConst(CInt(Std.string(col))),
                        pos: haxe.macro.Context.currentPos()
                    });
                }

                row_array.push({
                    expr: EArrayDecl(col_array),
                    pos: haxe.macro.Context.currentPos()
                });
            }

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

    private inline function grow_sprite():Void
    {
        var width:Int = 0;
        var height:Int = 0;

        for (frame in this.frames) {
            var new_width = Lambda.fold(
                frame,
                function(row:Array<Int>, acc:Int)
                    return row.length > acc ? row.length : acc,
                0
            );

            width = new_width > width ? new_width : width;
            height = frame.length > height ? frame.length : height;
        }

        if (width > this.width)
            this.width = width;

        if (height > this.height)
            this.height = height;
    }

    public inline function add_frame(frame:Array<Array<Int>>):Array<Array<Int>>
    {
        this.frames.push(frame);
        this.grow_sprite();
        return frame;
    }

    public override function update():Void
    {
        if (this.frames.length == 0)
            return;

        this.blit(this.frames[
            this.current < 0 ? -this.current : this.current
        ]);

        super.update();

        if (++this.td >= this.factor) {
            if (++this.current >= this.frames.length) {
                if (this.loopback)
                    this.current = -this.frames.length + 1;
                else
                    this.current = 0;
            }

            this.td = 0;
        }
    }
}
