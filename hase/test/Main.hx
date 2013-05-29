package hase.test;

class Main
{
    public static function main():Void
    {
        var runner = new haxe.unit.TestRunner();
        runner.add(new hase.test.cases.SpriteTest());
        runner.add(new hase.test.cases.AnimationTest());
        runner.add(new hase.test.cases.MatrixTest());
        runner.add(new hase.test.cases.AnimationParserTest());
        runner.add(new hase.test.cases.FrameAreaParserTest());
        runner.add(new hase.test.cases.ColorTableTest());
        runner.add(new hase.test.cases.RectTest());
        runner.add(new hase.test.cases.PVectorTest());
        runner.run();
    }
}
