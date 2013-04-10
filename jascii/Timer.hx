package jascii;

class Timer
{
    private var interval:Int;
    private var root:jascii.display.Surface;
    private var last_time:Float;

    public function new(root:jascii.display.Surface, fps:Int = 60)
    {
        this.interval = Std.int(1000 / fps);
        this.root = root;
    }

    private function anim_callback(time:Float):Bool
    {
        this.tick(time);
        js.Browser.window.requestAnimationFrame(this.anim_callback);
        return false;
    }

    public function run():Void
    {
        if (js.Browser.window.requestAnimationFrame != null) {
            this.last_time = 0;
            js.Browser.window.requestAnimationFrame(this.anim_callback);
        } else {
            this.last_time = haxe.Timer.stamp() * 1000;
            var timer:haxe.Timer = new haxe.Timer(this.interval);
            timer.run = inline function() this.tick(haxe.Timer.stamp() * 1000);
        }
    }

    private inline function tick(time:Float):Void
    {
        var delta:Float = time - this.last_time;
        this.last_time += delta;
        this.root.update(delta);
    }
}
