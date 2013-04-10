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

    public function test_move_x():Void
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

    public function test_move_y():Void
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

    public function test_overlay():Void
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

    public function test_overlay_double_update():Void
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

        rect.add_child(circle);
        this.root.add_child(rect);

        circle.y = 1;
        this.root.update();
        this.root.update();

        this.assert_area(
            [ ",-------."
            , "|  _._  |"
            , "|.'   `.|"
            , "|:     ;|"
            , "| `-.-' |"
            , "`-------'"
            ], 0, 0, 9, 6
        );
    }

    public function test_overlay_intersect():Void
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

    public function test_centering():Void
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

        circle.center_x = 4;
        circle.center_y = 1;

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

    public function test_move_around_multiple():Void
    {
        var circle:jascii.display.Animation = this.create_animation([
            [ "         "
            , "   _._   "
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

        var tri:jascii.display.Animation = this.create_animation([
            [ "     .     "
            , "   ,' `.   "
            , " ,'     `. "
            , "`---------'"
            ]
        ]);

        rect.add_child(circle);
        rect.add_child(tri);
        this.root.add_child(rect);

        rect.x += 4;
        tri.y += 5;

        this.root.update();

        rect.x += 4;
        circle.y += 5;

        this.root.update();

        rect.x += 2;

        this.root.update();

        circle.x -= 5;

        this.root.update();

        tri.x += 5;
        circle.y -= 3;
        circle.x += 9;

        this.root.update();

        this.assert_area(
            [ " ,-------.       "
            , " |       |       "
            , " |       |       "
            , " |      _._      "
            , " `----.'-' `.    "
            , "      :    .;    "
            , "       `-.-'`.   "
            , "       ,'     `. "
            , "      `---------'"
            ], 9, 0, 17, 9
        );
    }
}
