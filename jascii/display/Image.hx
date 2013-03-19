package jascii.display;

class Image extends Sprite
{
    public var data(default, set_data):Array<String>;

    public function new(?data:Array<String> = null)
    {
        super();
        this.data = data;
    }

    private inline function set_data(data:Array<String>):Array<String>
    {
        if (data != null) {
            this.width = Lambda.fold(data, function(row:String, acc:Int) {
                return row.length > acc ? row.length : acc;
            }, 0);
            this.height = data.length;
        } else {
            this.width = 0;
            this.height = 0;
        }

        this.dirty = true;
        return this.data = data;
    }

    public override function update():Void
    {
        super.update();
        this.draw_block(this.x, this.y, this.data);
    }
}
