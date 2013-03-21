package jascii.display;

class ObjectContainer extends Object
{
    public var children:Array<Object>;

    public function new()
    {
        super();
        this.children = new Array();
    }

    public inline function add_child(child:Object):Object
    {
        child.parent = this;
        child.autogrow();
        this.children.push(child);
        return child;
    }

    public inline function remove_child(child:Object):Object
    {
        child.parent = null;
        this.children.remove(child);
        return child;
    }

    public override function update():Void
    {
        for (child in this.children)
            if (child.dirty)
                child.update();
    }
}
