package jascii;

class Timer
{
    private var interval:Int;
    private var root:jascii.display.Surface;

    public function new(root:jascii.display.Surface, fps:Int = 60)
    {
        this.interval = Std.int(1000 / fps);
        this.root = root;
    }

    private function anim_callback(td:Float):Bool
    {
        this.tick(td);
        js.Browser.window.requestAnimationFrame(this.anim_callback);
        return false;
    }

    public function run():Void
    {
        if (js.Browser.window.requestAnimationFrame != null)
            js.Browser.window.requestAnimationFrame(this.anim_callback);
        else {
            var timer:haxe.Timer = new haxe.Timer(this.interval);
            var last:Float = haxe.Timer.stamp();

            timer.run = inline function() {
                var delta:Float = haxe.Timer.stamp() - last;
                last += delta;
                this.tick(delta);
            };
        }
    }

    private inline function tick(td:Float):Void
        this.root.update(td);
}
