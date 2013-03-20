package jascii.views;

class Login extends jascii.display.Sprite
{
    private var car:jascii.display.Animation;
    private var dragon:jascii.display.Animation;
    private var delta:Int;

    public function new()
    {
        super();

        this.delta = 0;

        this.car = jascii.display.Animation.from_file("gfx/car.cat");
        this.car.x = 20;
        this.car.y = 25;
        this.car.factor = 5;
        this.add_child(this.car);

        this.dragon = jascii.display.Animation.from_file("gfx/dragon.cat");
        this.dragon.x = 0;
        this.dragon.y = 10;
        this.dragon.factor = 50;
        this.add_child(this.dragon);
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
