package jascii;

import js.html.RequestAnimationFrameCallback;

typedef FrameHandler = RequestAnimationFrameCallback -> Void;

class Timer
{
    private var interval:Int;
    private var root:jascii.display.Surface;
    private var last_time:Float;
    private var running:Bool;

    private var req_anim_frame:FrameHandler;

    public function new(root:jascii.display.Surface, fps:Int = 60)
    {
        this.interval = Std.int(1000 / fps);
        this.root = root;

        var raf:Null<FrameHandler> = null;

        if (js.Browser.window != null)
            raf = this.get_frame_handler();

        this.req_anim_frame = raf != null ? raf : this.legacy_timer;
    }

    private inline function get_frame_handler():Null<FrameHandler>
    {
        // What a mess! Cross-browser fuckery at its best!
        if (untyped window.requestAnimationFrame)
            return js.Browser.window.requestAnimationFrame;
        else if (untyped js.Browser.window.webkitRequestAnimationFrame)
            return untyped js.Browser.window.webkitRequestAnimationFrame
                .bind(js.Browser.window);
        else if (untyped js.Browser.window.mozRequestAnimationFrame)
            return untyped js.Browser.window.mozRequestAnimationFrame
                .bind(js.Browser.window);
        else if (untyped js.Browser.window.msRequestAnimationFrame)
            return untyped js.Browser.window.msRequestAnimationFrame
                .bind(js.Browser.window);
        else if (untyped js.Browser.window.oRequestAnimationFrame)
            return untyped js.Browser.window.oRequestAnimationFrame
                .bind(js.Browser.window);
        else
            return null;
    }

    private inline function legacy_timer(cb:RequestAnimationFrameCallback):Void
        haxe.Timer.delay(cb.bind(haxe.Timer.stamp() * 1000), this.interval);

    private function loop(time:Float):Bool
    {
        if (!this.running)
            return true;

        this.req_anim_frame(this.loop);

        if (this.last_time == null) {
            this.tick(0);
        } else {
            var delta:Float = time - this.last_time;
            if (delta < this.interval * 10)
                this.tick(delta);
        }

        this.last_time = time;

        return !this.running;
    }

    public inline function start():Void
    {
        this.running = true;
        this.last_time = null;
        this.req_anim_frame(this.loop);
    }

    public inline function stop():Void
        this.running = false;

    private inline function tick(delta:Float)
    {
        this.root.update(delta);
    }
}
