package jascii.display;

class Object
{
    public var parent:Object;
    public var children:Array<Object>;

    public var x(default, set):Int;
    public var y(default, set):Int;
    public var z(default, set):Int;

    public var center_x(default, set):Int;
    public var center_y(default, set):Int;

    public var width(default, set):Int;
    public var height(default, set):Int;

    public var absolute_x(get, null):Int;
    public var absolute_y(get, null):Int;

    public var is_dirty:Bool;

    public var surface(default, set):Surface;
    public var is_surface:Bool;

    public var autoresize:Bool;

    public function new()
    {
        this.parent = null;
        this.children = new Array();

        this.x = 0;
        this.y = 0;
        this.z = 0;

        this.center_x = 0;
        this.center_y = 0;

        this.width = 0;
        this.height = 0;

        this.is_dirty = true;

        this.is_surface = false;
        this.surface = null;

        this.autoresize = true;
    }

    public inline function add_child(child:Object):Object
    {
        child.parent = this;
        child.autogrow();
        child.z = this.z + 1;

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
        child.surface = null;
        this.children.remove(child);
        return child;
    }

    private inline function set_dirty<T>(?val:T):T
    {
        this.is_dirty = true;
        for (child in this.children)
            child.set_dirty();
        return val;
    }

    private inline function set_x(val:Int):Int
        return this.set_dirty(this.x = val);

    private inline function set_y(val:Int):Int
        return this.set_dirty(this.y = val);

    private inline function set_z(val:Int):Int
    {
        this.z = this.set_dirty(val);
        if (this.surface != null) this.surface.z_reorder();
        return this.z;
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

    private inline function set_center_x(val:Int):Int
        return this.set_dirty(this.center_x = val);

    private inline function set_center_y(val:Int):Int
        return this.set_dirty(this.center_y = val);

    private inline function set_width(val:Int):Int
    {
        this.width = val;
        this.autogrow_width();

        return this.set_dirty(this.width);
    }

    private inline function set_height(val:Int):Int
    {
        this.height = val;
        this.autogrow_height();

        return this.set_dirty(this.height);
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
        for (child in this.children)
            child.surface = val;

        return this.surface = val;
    }

    public function autogrow():Void
    {
        this.autogrow_width();
        this.autogrow_height();
    }

    public function update(td:Float):Void
    {
        for (child in this.children)
            child.update(td);
    }

    public function toString():String
    {
        return "<Object x: " + this.x + "; y: " + this.y +
               "; z: " + this.z + ">";
    }
}
