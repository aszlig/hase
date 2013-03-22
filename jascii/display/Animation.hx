package jascii.display;

import haxe.macro.Expr;
import jascii.macro.Types;

typedef AnimOptions = {
    ?reference:String,
};

class Animation extends Sprite
{
    private var frames:Array<Array<Array<Int>>>;
    private var frame_options:Array<AnimOptions>;
    private var current:Int;

    private var td:Int;
    public var factor:Int;

    public var loopback:Bool;

    public function new(?frames = null, ?options:Array<AnimOptions>)
    {
        super();

        if (frames == null)
            frames = new Array();

        this.frames = frames;
        this.frame_options = options;
        this.current = 0;

        this.td = 0;
        this.factor = 1;

        this.loopback = false;

        this.grow_sprite();
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
        super.update();

        if (this.frames.length == 0)
            return;

        this.blit(this.frames[
            this.current < 0 ? -this.current : this.current
        ]);

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

    @:macro public static function from_file(path:String):Expr
    {
        var data:Array<AnimData> = jascii.macro.Animation.parse_file(path);

        var frames_array:Array<Expr> = new Array();
        var opts_array:Array<Expr> = new Array();

        for (item in data) {
            var row_array:Array<Expr> = new Array();

            for (row in item.frame) {
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

            frames_array.push({
                expr: EArrayDecl(row_array),
                pos: haxe.macro.Context.currentPos()
            });

            var opt_fields:Array<{field:String, expr:Expr}> = new Array();

            for (key in item.options.keys()) {
                opt_fields.push({
                    field: key,
                    expr: {
                        expr: EConst(CString(item.options.get(key))),
                        pos: haxe.macro.Context.currentPos()
                    }
                });
            }

            var opts:Expr = {
                expr: EObjectDecl(opt_fields),
                pos: haxe.macro.Context.currentPos()
            };

            opts_array.push(opts);
        }

        var frames_expr:Expr = {
            expr: EArrayDecl(frames_array),
            pos: haxe.macro.Context.currentPos()
        };

        var options_expr:Expr = {
            expr: EArrayDecl(opts_array),
            pos: haxe.macro.Context.currentPos()
        };

        return {
            expr: ENew({
                name: "Animation",
                pack: ["jascii", "display"],
                params: []
            }, [frames_expr, options_expr]),
            pos: haxe.macro.Context.currentPos()
        };
    }
}
