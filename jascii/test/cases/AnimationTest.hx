package jascii.test.cases;

class AnimationTest extends jascii.test.SurfaceTestCase
{
    public function test_simple_animate()
    {
        var anim:jascii.display.Animation = this.create_animation([
            [ "   _._   "
            , " .'   `. "
            , " :     ; "
            , "  `-.-'  "
            , "         "
            ],
            [ " _     _ "
            , "  `. ,'  "
            , "   ,'.   "
            , " -'   `- "
            , "         "
            ]
        ]);

        this.root.add_child(anim);
        this.root.update();
        this.root.update();

        this.assert_area(
            [ " _     _ "
            , "  `. ,'  "
            , "   ,'.   "
            , " -'   `- "
            , "         "
            ], 0, 0, 9, 5
        );
    }

    public function test_animate_grow()
    {
        var anim:jascii.display.Animation = this.create_animation([
            [ "   _._   "
            , " .'   `. "
            , " :     ; "
            , "  `-.-'  "
            , "         "
            ],
            [ "             "
            , " -.       ,- "
            , "   `.   ,'   "
            , "     `.'     "
            , "    ,' `.    "
            , " _,'     `._ "
            , "             "
            , "             "
            ]
        ]);

        this.root.add_child(anim);
        this.root.update();
        this.root.update();

        this.assert_area(
            [ "             "
            , " -.       ,- "
            , "   `.   ,'   "
            , "     `.'     "
            , "    ,' `.    "
            , " _,'     `._ "
            , "             "
            , "             "
            ], 0, 0, 13, 8
        );
    }

    public function test_animate_shrink()
    {
        var anim:jascii.display.Animation = this.create_animation([
            [ "   _._   "
            , " .'   `. "
            , " :     ; "
            , "  `-.-'  "
            , "         "
            ],
            [ "X"
            ]
        ]);

        this.root.add_child(anim);
        this.root.update();
        this.root.update();

        this.assert_area(
            [ "X        "
            , "         "
            , "         "
            , "         "
            , "         "
            ], 0, 0, 9, 5
        );
    }

    public function test_animate_resize_move()
    {
        var anim:jascii.display.Animation = this.create_animation([
            [ "   _._   "
            , " .'   `. "
            , " :     ; "
            , "  `-.-'  "
            , "         "
            ],
            [ "X"
            ],
            [ "             "
            , " -.       ,- "
            , "   `.   ,'   "
            , "     `.'     "
            , "    ,' `.    "
            , " _,'     `._ "
            , "             "
            , "             "
            ]
        ]);

        this.root.add_child(anim);
        this.root.update();
        anim.x += 4;
        anim.y += 2;
        this.root.update();

        this.assert_area(
            [ "         "
            , "         "
            , "    X    "
            , "         "
            , "         "
            ], 0, 0, 9, 5
        );

        anim.x += 1;
        this.root.update();

        this.assert_area(
            [ "                  "
            , "                  "
            , "                  "
            , "      -.       ,- "
            , "        `.   ,'   "
            , "          `.'     "
            , "         ,' `.    "
            , "      _,'     `._ "
            , "                  "
            , "                  "
            ], 0, 0, 18, 10
        );
    }
}
