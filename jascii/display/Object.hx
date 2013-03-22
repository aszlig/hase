package jascii.display;

class Object
{
    public var parent:Object;
    public var children:Array<Object>;

    public var x(default, set_x):Int;
    public var y(default, set_y):Int;
    public var z(default, set_z):Int;
    public var width(default, set_width):Int;
    public var height(default, set_height):Int;

    public var absolute_x(get_absolute_x, null):Int;
    public var absolute_y(get_absolute_y, null):Int;

    public var surface(default, set_surface):Surface;

    public var autoresize:Bool;
    public var dirty(default, set_dirty):Bool;

    public var is_surface:Bool;

    public function new()
    {
        this.parent = null;
        this.children = new Array();

        this.x = 0;
        this.y = 0;
        this.z = 0;
        this.width = 0;
        this.height = 0;

        this.autoresize = true;
        this.dirty = true;

        this.is_surface = false;
        this.surface = null;
    }

    public inline function add_child(child:Object):Object
    {
        child.parent = this;
        child.autogrow();

        if (this.is_surface)
            child.surface = cast this;
        else if (this.surface != null)
            child.surface = this.surface;

        this.children.push(child);
        return child;
    }

    public inline function remove_child(child:Object):Object
    {
        child.parent = null;
        this.children.remove(child);
        return child;
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

    private inline function set_z(val:Int):Int
    {
        this.dirty = true;
        return this.z = val;
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

    private function set_dirty(val:Bool):Bool
    {
        if (val)
            for (child in this.children)
                child.dirty = true;

        return this.dirty = val;
    }

    private function get_absolute_x():Int
    {
        return this.x + (this.parent == null ? 0 : this.parent.absolute_x);
    }

    private function get_absolute_y():Int
    {
        return this.y + (this.parent == null ? 0 : this.parent.absolute_y);
    }

    private function set_surface(val:Surface):Surface
    {
        if (val != null)
            for (child in this.children)
                child.surface = val;

        return this.surface = val;
    }

    public function autogrow():Void
    {
        this.autogrow_width();
        this.autogrow_height();
    }

    public function update():Void
    {
        for (child in this.children)
            child.update();
    }

    public function toString():String
    {
        return "<Object x: " + this.x + "; y: " + this.y +
               "; z: " + this.z + ">";
    }
}
