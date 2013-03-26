package jascii;

class Main
{
    private var root_surface:jascii.display.Surface;

    public function new()
    {
        js.Browser.window.onload = this.onload;
    }

    private function onload(e:js.html.Event):Void
    {
        var canvas:js.html.CanvasElement = cast
            js.Browser.document.getElementById("canvas");

        canvas.width = js.Browser.window.innerWidth;
        canvas.height = js.Browser.window.innerHeight;

        var tc = new TermCanvas(canvas);

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
