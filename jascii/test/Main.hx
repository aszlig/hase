package jascii.test;

class Main
{
    public static function main():Void
    {
        var runner = new haxe.unit.TestRunner();
        runner.add(new jascii.test.cases.SpriteTest());
        runner.add(new jascii.test.cases.AnimationTest());
        runner.add(new jascii.test.cases.MatrixTest());
        runner.add(new jascii.test.cases.AnimationParserTest());
        runner.add(new jascii.test.cases.FrameAreaParserTest());
        runner.add(new jascii.test.cases.ColorTableTest());
        runner.add(new jascii.test.cases.RectTest());
        runner.run();
    }
}
