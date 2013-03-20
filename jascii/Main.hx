package jascii;

import js.Dom;

class Main
{
    private var tc:TermCanvas;

    public function new()
    {
        js.Lib.window.onload = this.onload;
    }

    private function onload(e:Event)
    {
        var canvas:Canvas = cast js.Lib.document.getElementById("canvas");
        canvas.width = js.Lib.window.innerWidth;
        canvas.height = js.Lib.window.innerHeight;

        this.tc = new TermCanvas(canvas);
        this.tc.onload = this.init;
        this.tc.init();
    }

    private function init():Void
    {
        var login_view = new jascii.views.Login();
        login_view.width = this.tc.width;
        login_view.height = this.tc.height;
        this.tc.add_child(login_view);

        var timer = new haxe.Timer(20);
        timer.run = this.tc.update;
    }

    public static function main():Void
    {
        new Main();
    }
}
