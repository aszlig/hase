package jascii.test.cases;

class SpriteTest extends jascii.test.SurfaceTestCase
{
    public function test_simple():Void
    {
        var circle:jascii.display.Animation = this.create_animation([
            [ "   _._   "
            , " .'   `. "
            , " :     ; "
            , "  `-.-'  "
            , "         "
            ]
        ]);

        this.root.add_child(circle);
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

    public function test_move_x()
    {
        var circle:jascii.display.Animation = this.create_animation([
            [ "   _._   "
            , " .'   `. "
            , " :     ; "
            , "  `-.-'  "
            , "         "
            ]
        ]);

        this.root.add_child(circle);
        this.root.update();
        circle.x = 5;
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

    public function test_move_y()
    {
        var circle:jascii.display.Animation = this.create_animation([
            [ "   _._   "
            , " .'   `. "
            , " :     ; "
            , "  `-.-'  "
            , "         "
            ]
        ]);

        this.root.add_child(circle);
        this.root.update();
        circle.y = 5;
        this.root.update();

        this.assert_area(
            [ "         "
            , "         "
            , "         "
            , "         "
            , "         "
            , "   _._   "
            , " .'   `. "
            , " :     ; "
            , "  `-.-'  "
            , "         "
            ], 0, 0, 9, 10
        );
    }

    public function test_overlay()
    {
        var circle:jascii.display.Animation = this.create_animation([
            [ "   _._   "
            , " .'   `. "
            , " :     ; "
            , "  `-.-'  "
            , "         "
            ]
        ]);

        var rect:jascii.display.Animation = this.create_animation([
            [ ",-------."
            , "|       |"
            , "|       |"
            , "|       |"
            , "|       |"
            , "`-------'"
            ]
        ]);

        var dot:jascii.display.Animation = this.create_animation([
            [ "     "
            , "     "
            , "    ^"
            ],
        ]);

        rect.add_child(circle);
        circle.add_child(dot);
        this.root.add_child(rect);

        circle.y = 1;
        this.root.update();

        this.assert_area(
            [ ",-------."
            , "|  _._  |"
            , "|.'   `.|"
            , "|:  ^  ;|"
            , "| `-.-' |"
            , "`-------'"
            ], 0, 0, 9, 6
        );
    }

    public function test_overlay_intersect()
    {
        var circle:jascii.display.Animation = this.create_animation([
            [ "   _._   "
            , " .'   `. "
            , " :     ; "
            , "  `-.-'  "
            , "         "
            ]
        ]);

        var rect:jascii.display.Animation = this.create_animation([
            [ ",-------."
            , "|       |"
            , "|       |"
            , "|       |"
            , "`-------'"
            ]
        ]);

        rect.add_child(circle);
        this.root.add_child(rect);

        rect.x = 4;
        rect.y = 1;

        circle.x = -4;
        circle.y = -1;

        this.root.update();

        this.assert_area(
            [ "   _._       "
            , " .' ,-`.----."
            , " :  |  ;    |"
            , "  `-.-'     |"
            , "    |       |"
            , "    `-------'"
            ], 0, 0, 13, 6
        );
    }
}
