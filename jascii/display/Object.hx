package jascii.display;

class Object
{
    public var x(default, set_x):Int;
    public var y(default, set_y):Int;
    public var width(default, set_width):Int;
    public var height(default, set_height):Int;

    public var absolute_x(get_absolute_x, null):Int;
    public var absolute_y(get_absolute_y, null):Int;

    public var parent:ObjectContainer;
    public var surface(get_surface, null):Surface;

    public var autoresize:Bool;
    public var dirty:Bool;

    public function new()
    {
        this.x = 0;
        this.y = 0;
        this.width = 0;
        this.height = 0;

        this.parent = null;

        this.autoresize = true;
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

    private function autogrow_width():Void
    {
        if (this.parent == null || !this.parent.autoresize)
            return;

        if (this.x + this.width > this.parent.width)
            this.parent.width = this.x + this.width;
    }

    private function autogrow_height():Void
    {
        if (this.parent == null || !this.parent.autoresize)
            return;

        if (this.y + this.height > this.parent.height)
            this.parent.height = this.y + this.height;
    }

    private function set_width(val:Int):Int
    {
        this.dirty = true;

        this.width = val;
        this.autogrow_width();

        return this.width;
    }

    private function set_height(val:Int):Int
    {
        this.dirty = true;

        this.height = val;
        this.autogrow_height();

        return this.height;
    }

    private function get_absolute_x():Int
    {
        return this.x + (this.parent == null ? 0 : this.parent.absolute_x);
    }

    private function get_absolute_y():Int
    {
        return this.y + (this.parent == null ? 0 : this.parent.absolute_y);
    }

    private function get_surface():Surface
    {
        if (this.parent == null)
            return cast this;
        else
            return this.parent.surface;
    }

    public function autogrow():Void
    {
        this.autogrow_width();
        this.autogrow_height();
    }

    public function update():Void
    {
        this.dirty = false;
    }
}
