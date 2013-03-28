package jascii.display;

import haxe.macro.Expr;
import jascii.macro.Types;

typedef AnimOptions = {
    ?refpoint_x:Int,
    ?refpoint_y:Int,
};

class Animation extends Sprite
{
    private var frames:Array<Image>;
    private var frame_options:Array<AnimOptions>;
    private var current:Int;

    private var td:Int;
    public var factor:Int;

    public var loopback:Bool;

    public function new( ?frames:Array<Image>
                       , ?options:Array<AnimOptions>)
    {
        super();

        if (frames == null)
            frames = new Array();

        this.frames = [for (x in frames) x];
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
            width = frame.width > width ? frame.width : width;
            height = frame.height > height ? frame.height : height;
        }

        if (width > this.width)
            this.width = width;

        if (height > this.height)
            this.height = height;
    }

    public inline function add_frame(frame:Image):Image
    {
        this.frames.push(frame);
        this.grow_sprite();
        return frame;
    }

    private function set_frame_options(opts:AnimOptions):Void
    {
        if (opts.refpoint_x != null && opts.refpoint_y != null) {
            this.center_x = opts.refpoint_x;
            this.center_y = opts.refpoint_y;
        } else {
            this.center_x = 0;
            this.center_y = 0;
        }
    }

    public override function update():Void
    {
        super.update();

        if (this.frames.length == 0)
            return;

        var frame_id:Int = this.current < 0 ? -this.current : this.current;

        if (this.frame_options != null)
            this.set_frame_options(this.frame_options[frame_id]);

        this.blit(this.frames[frame_id]);

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

    macro public static function from_file(path:String):Expr
    {
        var data:Array<AnimData> =
            jascii.utils.AnimationParser.parse_file(path);

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
                        expr: item.options.get(key),
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

        return macro new Animation(
            $a{frames_array},
            $a{opts_array}
        );
    }
}
