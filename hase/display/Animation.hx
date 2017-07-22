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
package hase.display;

import haxe.macro.Expr;

typedef FrameData = {
    image:hase.geom.Raster<Symbol>,
    ?refpoint_x:Int,
    ?refpoint_y:Int,
    ?key:String,
};

class Animation extends Sprite
{
    @:allow(hase.test.cases.AnimationTest)
    private var frames:Array<FrameData>;

    public var current:Int; // XXX: make this private and refactor

    private var td:Null<Float>;
    private var shift:Null<Float>;

    public var fps(default, set):Float;
    public var key:Null<String>;

    public var loopback:Bool;

    public function new(?data:Array<FrameData>)
    {
        super();

        if (data == null)
            this.frames = new Array();
        else
            this.frames = data;

        this.current = 0;

        this.td = null;
        this.fps = 1;
        this.key = null;

        this.loopback = false;

        this.grow_sprite();
    }

    private inline function set_fps(fps:Float):Float
    {
        this.shift = 1000 / fps;
        return this.fps = fps;
    }

    private function grow_sprite():Void
    {
        var width:Int = 0;
        var height:Int = 0;

        for (frame in this.frames) {
            width = frame.image.width > width ? frame.image.width : width;
            height = frame.image.height > height ? frame.image.height : height;
        }

        if (width > this.width)
            this.width = width;

        if (height > this.height)
            this.height = height;
    }

    public inline function add_frame(frame:FrameData):FrameData
    {
        this.frames.push(frame);
        this.grow_sprite();
        return frame;
    }

    private inline function set_frame_options(frame:FrameData):Void
    {
        if (frame.refpoint_x != null && frame.refpoint_y != null) {
            this.center_x = frame.refpoint_x;
            this.center_y = frame.refpoint_y;
        }
    }

    private function find_next_keyframe():Int
    {
        var frame_id:Int = this.current + 1;
        if (frame_id >= this.frames.length) frame_id = 0;
        while (this.frames[frame_id].key != this.key) {
            if (++frame_id >= this.frames.length)
                frame_id = 0;

            if (frame_id == this.current) {
                if (this.frames[frame_id].key != this.key)
                    throw 'Unknown animation key "${this.key}".';
                else
                    break;
            }
        }
        return frame_id;
    }

    private inline function increment_current():Int
        return this.current = this.key != null
                            ? this.find_next_keyframe()
                            : this.current + 1;

    private function switch_frame():Void
    {
        var frame_id:Int = this.current < 0 ? -this.current : this.current;
        this.set_frame_options(this.frames[frame_id]);

        if (this.ascii == null)
            this.ascii = Image.from_raster(this.frames[frame_id].image);
        else
            this.ascii.merge_raster(this.frames[frame_id].image);
    }

    public function stop():Void
        this.shift = null;

    public override function update(td:Float):Void
    {
        if (this.frames.length == 0 || this.shift == null) {
            super.update(td);
            return;
        }

        if (this.td == null) {
            this.td = td;
            this.switch_frame();
        } else {
            this.td += td;
        }

        while (this.td > this.shift) {
            if (this.increment_current() >= this.frames.length) {
                if (this.loopback)
                    this.current = this.frames.length > 1
                                 ? -this.frames.length + 2
                                 : 0;
                else
                    this.current = 0;
            }

            this.td -= this.shift;
            this.switch_frame();
        }

        super.update(td);
    }

    macro public static function load_framedata(path:String):Expr
    {
        var data:Array<FrameData> =
            hase.macro.AnimationParser.parse_file(path);

        var raw_data:Dynamic = [for (fd in data) {
            raw_image: fd.image.to_2d_array(),
            refpoint_x: fd.refpoint_x,
            refpoint_y: fd.refpoint_y,
            key: fd.key,
        }];

        return macro [for (fd in $v{raw_data}) {
            image: hase.geom.Raster.from_2d_array(fd.raw_image, 0),
            refpoint_x: fd.refpoint_x,
            refpoint_y: fd.refpoint_y,
            key: fd.key,
        }];
    }

    macro public static function from_file(path:String):Expr
        return macro new Animation(Animation.load_framedata($v{path}));
}
