package jascii.display;

class Object
{
    public var x(default, set_x):Int;
    public var y(default, set_y):Int;
    public var width(default, set_width):Int;
    public var height(default, set_height):Int;

    public var parent:ObjectContainer;
    public var surface(get_surface, null):ISurface;

    public var dirty:Bool;

    public function new()
    {
        this.x = 0;
        this.y = 0;
        this.width = 0;
        this.height = 0;

        this.parent = null;

        this.dirty = true;
    }

    private inline function set_x(val:Int):Int
    {
        this.dirty = true;
        return this.x = val;
    }

    private inline function set_y(val:Int):Int
    {
        this.dirty = true;
        return this.y = val;
    }

    private inline function set_width(val:Int):Int
    {
        this.dirty = true;
        return this.width = val;
    }

    private inline function set_height(val:Int):Int
    {
        this.dirty = true;
        return this.height = val;
    }

    private function get_surface():ISurface
    {
        if (this.parent == null)
            return cast this;
        else
            return this.parent.surface;
    }

    public function update():Void
    {
        this.dirty = false;
    }
}
