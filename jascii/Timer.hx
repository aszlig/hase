package jascii;

class Timer
{
    private var interval:Int;
    private var root:jascii.display.Surface;
    private var last_time:Float;

    public function new(root:jascii.display.Surface, fps:Int = 60)
    {
        this.interval = Std.int(1000 / fps);
        this.last_time = null;
        this.root = root;
    }

    private function wrap_animation_frame(cb:Float -> Bool):Void
    {
        if (untyped window.requestAnimationFrame)
            js.Browser.window.requestAnimationFrame(cb);
        else if (untyped window.webkitRequestAnimationFrame)
            untyped window.webkitRequestAnimationFrame(cb);
        else if (untyped window.mozRequestAnimationFrame)
            untyped window.mozRequestAnimationFrame(cb);
        else
            haxe.Timer.delay(cb.bind(haxe.Timer.stamp() * 1000), this.interval);
    }

    private function anim_callback(time:Float):Bool
    {
        this.tick(time);
        this.wrap_animation_frame(this.anim_callback);
        return false;
    }

    public function run():Void
    {
        this.wrap_animation_frame(this.anim_callback);
    }

    private inline function tick(time:Float):Void
    {
        if (this.last_time == null)
            this.last_time = time;

        var delta:Float = time - this.last_time;
        this.last_time += delta;
        this.root.update(delta);
    }
}
