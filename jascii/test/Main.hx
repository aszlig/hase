package jascii.test;

class Main
{
    public static function main():Void
    {
        var runner = new haxe.unit.TestRunner();
        runner.add(new jascii.test.cases.SpriteTest());
        runner.run();
    }
}
