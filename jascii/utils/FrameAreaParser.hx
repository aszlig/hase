package jascii.utils;

import jascii.display.Image;
import jascii.display.Symbol;
import jascii.geom.Rect;

private class Border
{
    public var x(default, null):Int;
    public var y(default, null):Int;
    public var length(default, null):Int;
    public var headings(default, null):Array<Int>;

    public function new(x:Int, y:Int, heading:Bool = false)
    {
        this.x = x;
        this.y = y;
        this.length = 1;
        this.headings = heading ? [y] : new Array();
    }

    public function merge(border:Border):Bool
    {
        if (this.x != border.x)
            return false;

        if (this.y + this.length == border.y) {
            this.length++;
            this.headings.concat(border.headings);
            return true;
        }

        return false;
    }
}

private class BorderGroup
{
    private var index:Map<Int, Array<Int>>;
    private var borders:Array<Border>;

    public function new()
    {
        this.borders = new Array();
        this.index = new Map();
    }

    public function add(border:Border):Void
    {
        var idx:Null<Array<Int>> = this.index.get(border.x);

        if (idx != null) {
            for (i in idx)
                if (this.borders[i].merge(border))
                    return;
        }

        this.index.set(border.x, [this.borders.length]);
        this.borders.push(border);
    }

    public function get_boxes(maxwidth:Int):Array<Rect>
    {
        var biggest:Null<Border> = Lambda.fold(this.borders,
            function(b:Border, acc:Border) {
                if (acc == null) return null;
                else if (acc.headings.length > 0) return null;
                else if (b.length > acc.length) return b;
                else return acc;
            }, this.borders[0]);

        if (biggest != null)
            return [new Rect(biggest.x + 1, biggest.y,
                             maxwidth - biggest.x - 1,
                             biggest.length)];

        return new Array();
    }
}

class FrameAreaParser
{
    private var area:Image;

    public function new(area:Image)
        this.area = area;

    private function detect_boxes():Array<Rect>
    {
        var borders:BorderGroup = new BorderGroup();

        this.area.map_(inline function(x:Int, y:Int, sym:Symbol) {
            if (sym == ":".code) borders.add(new Border(x, y, true))
            else if (sym == "|".code) borders.add(new Border(x, y));
        });

        return borders.get_boxes(this.area.width);
    }

    public function parse():Array<Image>
    {
        return [for (rect in this.detect_boxes()) this.area.extract_rect(rect)];
    }
}
