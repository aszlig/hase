package jascii.test.cases;

class SpriteTest extends jascii.test.SurfaceTestCase
{
    public function test_simple():Void
    {
        var anim:jascii.display.Animation = this.create_animation([
            [ "   _._   "
            , " .'   `. "
            , " :     ; "
            , "  `-.-'  "
            , "         "
            ]
        ]);

        this.root.add_child(anim);
        this.root.update();

        this.assert_area(
            [ "   _._   "
            , " .'   `. "
            , " :     ; "
            , "  `-.-'  "
            , "         "
            ], 0, 0, 9, 5
        );
    }

    public function test_simple_move_x()
    {
        var anim:jascii.display.Animation = this.create_animation([
            [ "   _._   "
            , " .'   `. "
            , " :     ; "
            , "  `-.-'  "
            , "         "
            ]
        ]);

        this.root.add_child(anim);
        this.root.update();
        anim.x = 5;
        this.root.update();

        this.assert_area(
            [ "        _._   "
            , "      .'   `. "
            , "      :     ; "
            , "       `-.-'  "
            , "              "
            ], 0, 0, 14, 5
        );
    }
}
