package jascii.display;

class Image extends Sprite
{
    public var data(default, set_data):Array<Array<Int>>;

    public function new(?data:Array<Array<Int>> = null)
    {
        super();
        this.data = data;
    }

    private inline function set_data(data:Array<Array<Int>>):Array<Array<Int>>
    {
        if (data != null) {
            this.width = Lambda.fold(data, function(row:Array<Int>, acc:Int) {
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
        this.blit(this.data);
        super.update();
    }
}
