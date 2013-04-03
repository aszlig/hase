package jascii.geom;

class Rect
{
    public var x:Int;
    public var y:Int;
    public var width:Int;
    public var height:Int;

    public function new(x:Int, y:Int, width:Int, height:Int)
    {
        this.x = x;
        this.y = y;
        this.width = width;
        this.height = height;
    }

    public function union(other:Rect):Rect
    {
        var x = other.x > this.x ? this.x : other.x;
        var y = other.y > this.y ? this.y : other.y;
        var width = other.x + other.width > this.x + this.width
                  ? other.x + other.width : this.x + this.width;
        var height = other.y + other.height > this.y + this.height
                   ? other.y + other.height : this.y + this.height;
        return new Rect(x, y, width - x, height - y);
    }

    public function intersects(other:Rect):Bool
    {
        return (
            ((this.x >= other.x && this.x < other.x + other.width)  ||
             (other.x >= this.x && other.x < this.x + this.width))  &&
            ((this.y >= other.y && this.y < other.y + other.height) ||
             (other.y >= this.y && other.y < this.y + this.height))
        );
    }

    public function toString():String
    {
        return "<Rectangle x: " + this.x + "; y: " + this.y +
               "; width: " + this.width + "; height: " + this.height + ">";
    }
}
