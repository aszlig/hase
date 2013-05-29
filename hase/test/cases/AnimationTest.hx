package hase.test.cases;

class AnimationTest extends hase.test.SurfaceTestCase
{
    public function test_simple_animate():Void
    {
        var anim:hase.display.Animation = this.create_animation([
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
        this.update();
        this.update();

        this.assert_area(
            [ " _     _ "
            , "  `. ,'  "
            , "   ,'.   "
            , " -'   `- "
            , "         "
            ], 0, 0, 9, 5
        );
    }

    public function test_animate_grow():Void
    {
        var anim:hase.display.Animation = this.create_animation([
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
        this.update();
        this.update();

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

    public function test_animate_shrink():Void
    {
        var anim:hase.display.Animation = this.create_animation([
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
        this.update();
        this.update();

        this.assert_area(
            [ "X        "
            , "         "
            , "         "
            , "         "
            , "         "
            ], 0, 0, 9, 5
        );
    }

    public function test_animate_resize_move():Void
    {
        var anim:hase.display.Animation = this.create_animation([
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
        this.update();
        anim.x += 4;
        anim.y += 2;
        this.update();

        this.assert_area(
            [ "         "
            , "         "
            , "    X    "
            , "         "
            , "         "
            ], 0, 0, 9, 5
        );

        anim.x += 1;
        this.update();

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

    public function test_animate_overlay():Void
    {
        var anim:hase.display.Animation = this.create_animation([
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

        var bat:hase.display.Animation = this.create_animation([
            [ "  _       _  "
            , ",' '`o o'` `."
            , ":','^^^^^`,`:"
            ]
        ]);

        anim.add_child(bat);
        anim.x = 4;
        bat.y = 2;
        bat.x = -2;
        this.root.add_child(anim);

        this.update();

        this.assert_area(
            [ "       _._       "
            , "     .'   `.     "
            , "    _:     ;_    "
            , "  ,' '`o.o'` `.  "
            , "  :','^^^^^`,`:  "
            , "                 "
            ], 0, 0, 17, 6
        );

        bat.y += 1;
        bat.x += 2;
        this.update();

        this.assert_area(
            [ "                 "
            , "   -.       ,-   "
            , "     `.   ,'     "
            , "    _  `.'  _    "
            , "  ,' '`o o'` `.  "
            , "  :','^^^^^`,`:  "
            , "                 "
            ], 2, 0, 17, 7
        );
    }

    public function test_overlay_intersect():Void
    {
        var circle:hase.display.Animation = this.create_animation([
            [ "   _._   "
            , " .'   `. "
            , " :     ; "
            , "  `-.-'  "
            , "         "
            ],
            [ "   .-.   "
            , " ,'   `. "
            , " :     ; "
            , " `.   ,' "
            , "   `-'   "
            ]
        ]);

        var rect:hase.display.Animation = this.create_animation([
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

        this.update();
        this.update();

        this.assert_area(
            [ "   .-.       "
            , " ,' ,-`.----."
            , " :  |  ;    |"
            , " `. | ,'    |"
            , "   `-'      |"
            , "    `-------'"
            ], 0, 0, 13, 6
        );
    }

    public function test_move_slow_anim():Void
    {
        var bird:hase.display.Animation = this.create_animation([
            [ "      __ "
            , " `.__(o_>"
            , "   (___) "
            , "    ||   "
            , "    LL   "
            ],
            [ "  ,  ,_    "
            , "  |__(O`'' "
            , "   (___)^^ "
            , "    ||     "
            , "    ^^     "
            ]
        ]);

        var balloon:hase.display.Animation = this.create_animation([
            [ " ,-. "
            , ":   :"
            , " `.' "
            , "  :  "
            , "  :  "
            ],
            [ "  ,-. "
            , " :   :"
            , " ,'-' "
            , ":     "
            , "      "
            ],
        ]);

        bird.add_child(balloon);
        this.root.add_child(bird);

        bird.fps = 0.5;
        balloon.fps = 0.5;

        balloon.x += 10;

        this.update();

        this.assert_area(
            [ "      __   ,-. "
            , " `.__(o_> :   :"
            , "   (___)   `.' "
            , "    ||      :  "
            , "    LL      :  "
            , "               "
            ], 0, 0, 15, 6
        );

        bird.x += 2;

        this.update();

        this.assert_area(
            [ "      __   ,-. "
            , " `.__(o_> :   :"
            , "   (___)   `.' "
            , "    ||      :  "
            , "    LL      :  "
            , "               "
            ], 2, 0, 15, 6
        );

        balloon.x += 3;

        this.update();

        this.assert_area(
            [ " ,  ,_        ,-. "
            , " |__(O`''    :   :"
            , "  (___)^^    ,'-' "
            , "   ||       :     "
            , "   ^^             "
            , "                  "
            ], 3, 0, 18, 6
        );
    }

    public function test_move_around_multiple():Void
    {
        var bullet:hase.display.Animation = this.create_animation([
            [ "     "
            , " ==> "
            , "     "
            ],
            [ "        "
            , " ~~~==> "
            , "        "
            ]
        ]);

        var shooter:hase.display.Animation = this.create_animation([
            [ "         "
            , "  o      "
            , " |`-x~~  "
            , " ||      "
            , "/'|      "
            , "         "
            ],
            [ "     ~~~ "
            , "  o   ~  "
            , " |`-x~~  "
            , " ||      "
            , "/'|      "
            , "         "
            ]
        ]);

        shooter.add_child(bullet);
        this.root.add_child(shooter);

        shooter.x = 4;
        shooter.y = 0;

        bullet.x = 6;
        bullet.y = 1;

        this.update();

        this.assert_area(
            [ "             "
            , "    o        "
            , "   |`-x~~==> "
            , "   ||        "
            , "  /'|        "
            , "             "
            ], 2, 0, 13, 6
        );

        bullet.x += 4;

        this.update();

        this.assert_area(
            [ "       ~~~          "
            , "    o   ~           "
            , "   |`-x~~    ~~~==> "
            , "   ||               "
            , "  /'|               "
            , "                    "
            ], 2, 0, 20, 6
        );

        shooter.x += 5;

        this.update();

        this.assert_area(
            [ "                 "
            , "    o            "
            , "   |`-x~~    ==> "
            , "   ||            "
            , "  /'|            "
            , "                 "
            ], 7, 0, 17, 6
        );
    }

    public function test_unnecessary_update():Void
    {
        var shooter:hase.display.Animation = this.create_animation([
            [ "         "
            , "  o      "
            , " |`-x~~  "
            , " ||      "
            , "/'|      "
            , "         "
            ],
            [ "     ~~~ "
            , "  o   ~  "
            , " |`-x~~  "
            , " ||      "
            , "/'|      "
            , "         "
            ]
        ]);

        shooter.fps = 0.5;

        this.root.add_child(shooter);
        this.update();

        this.assert_area(
            [ "         "
            , "  o      "
            , " |`-x~~  "
            , " ||      "
            , "/'|      "
            , "         "
            ], 0, 0, 9, 6
        );

        this.clear_surface();
        this.update();

        this.assert_area(
            [ "         "
            , "         "
            , "         "
            , "         "
            , "         "
            , "         "
            ], 0, 0, 9, 6
        );
    }
}
