/* Haxe ASCII Spriting Engine
 *
 * Copyright (C) 2013-2017 aszlig
 *
 * This program is free software: you can redistribute it and/or modify it
 * under the terms of the GNU Affero General Public License, version 3, as
 * published by the Free Software Foundation.
 *
 * This program is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 * FITNESS FOR A PARTICULAR PURPOSE. See the GNU Affero General Public License
 * for more details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 */
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
            ]
        );
    }

    public function test_zero_frames():Void
    {
        var anim:hase.display.Animation = this.create_animation([]);

        this.root.add_child(anim);
        this.update();
        this.update();
        this.update();

        anim.loopback = true;

        this.update();
        this.update();
        this.update();

        this.assert_area([]);
    }

    public function test_one_frame():Void
    {
        var anim:hase.display.Animation = this.create_animation([
            [ "   __ "
            , " /'  |"
            , "|_/| |"
            , "   | |"
            , "   |/ "
            ],
        ]);

        this.root.add_child(anim);
        this.update();
        this.update();
        this.update();

        this.assert_area(
            [ "   __ "
            , " /'  |"
            , "|_/| |"
            , "   | |"
            , "   |/ "
            ]
        );

        anim.loopback = true;

        this.update();
        this.update();
        this.update();

        this.assert_area(
            [ "   __ "
            , " /'  |"
            , "|_/| |"
            , "   | |"
            , "   |/ "
            ]
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
            ]
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
            ]
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
            ]
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
            ]
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
            ]
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
            ], 2
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
            ]
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
            ]
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
            ], 2
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
            ], 3
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
            ], 2
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
            ], 2
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
            ], 7
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
            ]
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
            ]
        );
    }
    public function test_unnecessary_single_frame_update():Void
    {
        var stickfig:hase.display.Animation = this.create_animation([
            [ "       "
            , " . o . "
            , "  `|'  "
            , "   |   "
            , "  ' `  "
            , "       "
            ]
        ]);

        this.root.add_child(stickfig);
        this.update(2000);

        this.assert_area(
            [ "       "
            , " . o . "
            , "  `|'  "
            , "   |   "
            , "  ' `  "
            , "       "
            ]
        );

        this.clear_surface();
        this.update(5000);

        this.assert_area(
            [ "       "
            , "       "
            , "       "
            , "       "
            , "       "
            , "       "
            ]
        );
    }

    public function test_unnecessary_single_frame_key_update():Void
    {
        var stickfig:hase.display.Animation = this.create_animation([
            [ "       "
            , "   o   "
            , " .-|-. "
            , "   |   "
            , "  ' `  "
            , "       "
            ],
            [ "       "
            , " . o . "
            , "  `|'  "
            , "   |   "
            , "  ' `  "
            , "       "
            ]
        ]);

        stickfig.frames[0].key = "low";
        stickfig.frames[1].key = "high";

        stickfig.key = "high";

        this.root.add_child(stickfig);
        this.update(2000);

        this.assert_area(
            [ "       "
            , " . o . "
            , "  `|'  "
            , "   |   "
            , "  ' `  "
            , "       "
            ]
        );

        this.clear_surface();
        this.update(5000);

        this.assert_area(
            [ "       "
            , "       "
            , "       "
            , "       "
            , "       "
            , "       "
            ]
        );
    }

    public function test_different_overlapping_frame_sizes():Void
    {
        var triangle_input:Array<Array<String>> = [
            [ "   ,^.   "
            , "  ,' `.  "
            , " ,'   `. "
            , ",'     `."
            , "`-------'"
            ],
            [ "        "
            , "   ,^.  "
            , "  ,' `. "
            , " ,'   `."
            , " `-----'"
            ],
            [ "       "
            , "   ,'. "
            , "  ,' `."
            , "  '---'"
            ],
            [ "      "
            , "      "
            , "   .'."
            , "   `-'"
            ]
        ];

        var tris:Array<hase.display.Animation> = [
            this.create_animation(triangle_input),
            this.create_animation(triangle_input),
            this.create_animation(triangle_input),
            this.create_animation(triangle_input),
        ];

        var bar:hase.display.Sprite = this.create_sprite(
            [ ".---."
            , "|   |"
            , "|   |"
            , "|   |"
            , "|   |"
            , "|   |"
            , "|   |"
            , "|   |"
            , "|   |"
            , "|   |"
            , "|   |"
            , "|   |"
            , "|   |"
            , "`---'"
            ]
        );

        for (tri in tris) {
            tri.x = 0;
            tri.z = 3;
        }

        bar.x = 4;
        bar.z = 1;
        bar.center_x = 2;

        this.root.add_child(bar);

        tris[0].y = 0;
        this.root.add_child(tris[0]);
        this.update();

        this.assert_area(
            [ "  .,^..  "
            , "  ,' `.  "
            , " ,'   `. "
            , ",'|   |`."
            , "`-------'"
            , "  |   |  "
            , "  |   |  "
            , "  |   |  "
            , "  |   |  "
            , "  |   |  "
            , "  |   |  "
            , "  |   |  "
            , "  |   |  "
            , "  `---'  "
            ]
        );

        tris[1].y = 3;
        this.root.add_child(tris[1]);
        this.update();

        this.assert_area(
            [ "  .---.  "
            , "  |,^.|  "
            , "  ,' `.  "
            , " ,',^.`. "
            , " `,'-`.' "
            , " ,'   `. "
            , ",'|   |`."
            , "`-------'"
            , "  |   |  "
            , "  |   |  "
            , "  |   |  "
            , "  |   |  "
            , "  |   |  "
            , "  `---'  "
            ]
        );

        tris[2].y = 5;
        this.root.add_child(tris[2]);
        this.update();

        this.assert_area(
            [ "  .---.  "
            , "  |,'.|  "
            , "  ,' `.  "
            , "  '---'  "
            , "  |,^.|  "
            , "  ,,^..  "
            , " ,,' `.. "
            , " ,'---`. "
            , ",'|   |`."
            , "`-------'"
            , "  |   |  "
            , "  |   |  "
            , "  |   |  "
            , "  `---'  "
            ]
        );

        tris[3].y = 9;
        this.root.add_child(tris[3]);
        this.update();

        this.assert_area(
            [ "  .---.  "
            , "  |   |  "
            , "  |.'.|  "
            , "  |`-'|  "
            , "  |,'.|  "
            , "  ,' `.  "
            , "  ',^.'  "
            , "  ,' `.  "
            , " ,'   `. "
            , " `-,^.-' "
            , "  ,' `.  "
            , " ,'   `. "
            , ",'|   |`."
            , "`-------'"
            ]
        );
    }

    public function test_stop_anim():Void
    {
        var anim:hase.display.Animation = this.create_animation([
            [ "                                     "
            , "                         .---------. "
            , "      .-_.-_.-_..==)   ./  H E L P | "
            , "   ,'`         .'  |  /.-----------' "
            , "  ,'       _.''    o                 "
            , " ,'      .'       /|                 "
            , "       .'         /|                 "
            , "       :          ''                 "
            , "      .'                             "
            , "     '                               "
            ],
            [ "                                     "
            , "                                     "
            , "      .-_.-_.-_.. *CRACK*            "
            , "   ,'`         ..;                   "
            , "  ,'       _.''  '|                  "
            , " ,'      .'        o                 "
            , "       .'         /|                 "
            , "       :          /|                 "
            , "      .'          ''                 "
            , "     '                               "
            ],
            [ "                                     "
            , "                                     "
            , "      .-_.-_.-_..                    "
            , "   ,'`         ..;  N                "
            , "  ,'       _.'' ,'  O                "
            , " ,'      .'     '   O                "
            , "       .'        '  O                "
            , "       :         ,  O                "
            , "      .'         '' o                "
            , "     '              o                "
            ],
        ]);

        this.root.add_child(anim);

        this.update();
        anim.stop();
        this.update();

        this.assert_area(
            [ "                                     "
            , "                         .---------. "
            , "      .-_.-_.-_..==)   ./  H E L P | "
            , "   ,'`         .'  |  /.-----------' "
            , "  ,'       _.''    o                 "
            , " ,'      .'       /|                 "
            , "       .'         /|                 "
            , "       :          ''                 "
            , "      .'                             "
            , "     '                               "
            ]
        );

        anim.fps = 1;
        this.update();
        this.assert_area(
            [ "                                     "
            , "                                     "
            , "      .-_.-_.-_.. *CRACK*            "
            , "   ,'`         ..;                   "
            , "  ,'       _.''  '|                  "
            , " ,'      .'        o                 "
            , "       .'         /|                 "
            , "       :          /|                 "
            , "      .'          ''                 "
            , "     '                               "
            ]
        );

        anim.stop();
        for (i in 0...20) {
            this.update();
            this.assert_area(
                [ "                                     "
                , "                                     "
                , "      .-_.-_.-_.. *CRACK*            "
                , "   ,'`         ..;                   "
                , "  ,'       _.''  '|                  "
                , " ,'      .'        o                 "
                , "       .'         /|                 "
                , "       :          /|                 "
                , "      .'          ''                 "
                , "     '                               "
                ]
            );
        }
    }

    public function test_loopback():Void
    {
        var anim:hase.display.Animation = this.create_animation([
            [ "   _-|-_   "
            , " .'  |  `. "
            , " :   x   : "
            , " `.     ,' "
            , "   `---'   "
            ],
            [ "   _---_   "
            , " .'     `. "
            , " :   x---- "
            , " `.     ,' "
            , "   `---'   "
            ],
            [ "   _---_   "
            , " .'     `. "
            , " :   x   : "
            , " `.  |  ,' "
            , "   `-|-'   "
            ],
            [ "   _---_   "
            , " .'     `. "
            , " ----x   : "
            , " `.     ,' "
            , "   `---'   "
            ],
        ]);

        anim.loopback = true;

        this.root.add_child(anim);

        this.update();

        this.assert_area(
            [ "   _-|-_   "
            , " .'  |  `. "
            , " :   x   : "
            , " `.     ,' "
            , "   `---'   "
            ]
        );

        this.update();
        this.update();
        this.update();

        this.assert_area(
            [ "   _---_   "
            , " .'     `. "
            , " ----x   : "
            , " `.     ,' "
            , "   `---'   "
            ]
        );

        this.update();

        this.assert_area(
            [ "   _---_   "
            , " .'     `. "
            , " :   x   : "
            , " `.  |  ,' "
            , "   `-|-'   "
            ]
        );

        this.update();

        this.assert_area(
            [ "   _---_   "
            , " .'     `. "
            , " :   x---- "
            , " `.     ,' "
            , "   `---'   "
            ]
        );

        this.update();

        this.assert_area(
            [ "   _-|-_   "
            , " .'  |  `. "
            , " :   x   : "
            , " `.     ,' "
            , "   `---'   "
            ]
        );

        this.update();

        this.assert_area(
            [ "   _---_   "
            , " .'     `. "
            , " :   x---- "
            , " `.     ,' "
            , "   `---'   "
            ]
        );
    }
}
