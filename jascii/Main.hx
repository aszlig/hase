package jascii;

import js.Dom;

class Main
{
    private var root_surface:jascii.display.Surface;

    public function new()
    {
        js.Lib.window.onload = this.onload;
    }

    private function onload(e:Event)
    {
        var canvas:Canvas = cast js.Lib.document.getElementById("canvas");
        canvas.width = js.Lib.window.innerWidth;
        canvas.height = js.Lib.window.innerHeight;

        var tc = new TermCanvas(canvas);
        tc.onload = function() this.init(tc);
        tc.init();
    }

    private function init(tc:TermCanvas):Void
    {
        this.root_surface = new jascii.display.Surface(tc);

        var login_view = new jascii.views.Login();
        login_view.width = this.root_surface.width;
        login_view.height = this.root_surface.height;
        this.root_surface.add_child(login_view);

        var timer = new haxe.Timer(20);
        timer.run = this.root_surface.update;
    }

    public static function main():Void
    {
        new Main();
    }
}
