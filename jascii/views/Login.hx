package jascii.views;

import jascii.display.Animation;

class Login extends jascii.display.Sprite
{
    private var car:Animation;
    private var dragon:Animation;
    private var dragon_head:Animation;
    private var dragon_wing:Animation;
    private var delta:Int;

    public function new()
    {
        super();
        this.autoresize = false;

        this.delta = 0;

        this.car = Animation.from_file("gfx/car.cat");
        this.car.x = 20;
        this.car.y = 25;
        this.car.fps = 10;
        this.add_child(this.car);

        this.dragon = Animation.from_file("gfx/dragon.cat");
        this.dragon.x = -700;
        this.dragon.y = 10;
        this.dragon.fps = 17;
        this.dragon.loopback = true;
        this.add_child(this.dragon);

        this.dragon_head = Animation.from_file("gfx/dragon_head.cat");
        this.dragon_head.x = 38;
        this.dragon_head.y = -2;
        this.dragon_head.fps = 1;
        this.dragon.add_child(this.dragon_head);

        this.dragon_wing = Animation.from_file("gfx/dragon_wing_top.cat");
        this.dragon_wing.x = 34;
        this.dragon_wing.y = 2;
        this.dragon_wing.fps = 5;
        this.dragon_wing.loopback = true;
        this.dragon.add_child(this.dragon_wing);

        this.dragon_wing = Animation.from_file("gfx/dragon_wing_bottom.cat");
        this.dragon_wing.x = 38;
        this.dragon_wing.y = 2;
        this.dragon_wing.fps = 5;
        this.dragon_wing.loopback = true;
        this.dragon.add_child(this.dragon_wing);

        this.dragon_wing.z = -1;
    }

    public override function update(td:Float):Void
    {
        super.update(td);

        if (this.delta++ > 10000)
            this.delta = 0;

        if (this.delta % 5 == 0)
            this.car.x++;

        this.dragon.x++;
        this.dragon.y = Std.int(Math.sin(this.dragon.x / 10) * 4 + 10);

        if (this.dragon.x > this.width + 10)
            this.remove_child(this.dragon);
    }
}
