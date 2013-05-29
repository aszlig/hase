package hase.display;

interface ISurface
{
    public function draw_char(x:Int, y:Int, sym:Symbol):Void;
    // XXX: These should be handled by events (such as resize).
    public var width:Int;
    public var height:Int;
}
