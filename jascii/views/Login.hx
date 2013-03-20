package jascii.views;

import jascii.display.Animation;

class Login extends jascii.display.Sprite
{
    private var car:Animation;
    private var dragon:Animation;
    private var dragon_head:Animation;
    private var delta:Int;

    public function new()
    {
        super();

        this.delta = 0;

        this.car = Animation.from_file("gfx/car.cat");
        this.car.x = 20;
        this.car.y = 25;
        this.car.factor = 5;
        this.add_child(this.car);

        this.dragon = Animation.from_file("gfx/dragon.cat");
        this.dragon.x = 0;
        this.dragon.y = 10;
        this.dragon.factor = 8;
        this.dragon.loopback = true;
        this.add_child(this.dragon);

        this.dragon_head = Animation.from_file("gfx/dragon_head.cat");
        this.dragon_head.x = 38;
        this.dragon_head.y = 2;
        this.dragon_head.factor = 50;
        this.dragon.add_child(this.dragon_head);
    }

    public override function update():Void
    {
        super.update();

        if (this.delta++ > 10000)
            this.delta = 0;

        if (this.delta % 5 == 0)
            this.car.x++;

        if (this.delta % 8 == 0)
            this.dragon.x++;

        if (this.dragon.x > this.width)
            this.remove_child(this.dragon);
    }
}
