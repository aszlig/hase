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

    public function test_complex_character_changes():Void
    {
        var weed:hase.display.Animation = this.create_animation([
            [ "           "
            , " `. `, .'  "
            , "   `.' ,`  "
            , "   .','    "
            , "           "
            ],
            [ "      . .  "
            , "   :  ; ;  "
            , "   `.' ,`  "
            , "   .','    "
            , "           "
            ],
            [ "     `. .  "
            , "   :' ; ;  "
            , "   `.' ,`  "
            , "     ''    "
            , "           "
            ],
            [ "    .`..   "
            , "    : ;:   "
            , "    :' :   "
            , "     ''    "
            , "           "
            ],
            [ "     `..   "
            , "  : : ; .' "
            , "   `:' :   "
            , "     ''    "
            , "           "
            ],
            [ "  .   . :  "
            , "  `. `. ;  "
            , "   `.' ,`  "
            , "    `,'    "
            , "           "
            ],
            [ "  . .   .  "
            , "  `. : `.  "
            , "   `.' ,`  "
            , "   .'.'    "
            , "           "
            ]
        ]);

        weed.loopback = true;
        weed.x = 8;
        weed.y = 3;
        weed.z = 3;

        this.root.add_child(weed);

        var branch:hase.display.Animation = this.create_animation([
            [ "                                 "
            , "        _                        "
            , "   __ .' )                       "
            , "  `. `.`-`.        _____.-----.  "
            , "    `~~~- _`------'          ,`  "
            , "   .--'`-' `------.__________,`  "
            , "   `---'                         "
            , "                                 "
            ],
            [ "                                 "
            , "         .-.                     "
            , "     .'. :,'                     "
            , "     : `-`.        ___________   "
            , "      `--._`------'          ,`  "
            , "     .'`-' `------._____     ,`  "
            , "     `--'               `-----'  "
            , "                                 "
            ]
        ]);

        branch.loopback = true;
        branch.z = 1;

        this.root.add_child(branch);

        this.update();

        this.assert_area(
            [ "                                 "
            , "        _                        "
            , "   __ .' )                       "
            , "  `. `.`-`.        _____.-----.  "
            , "    `~~~-`.``,-.'-'          ,`  "
            , "   .--'`-' `.'-,`-.__________,`  "
            , "   `---'   .','                  "
            , "                                 "
            , "                                 "
            , "                                 "
            ]
        );

        weed.x -= 1;
        this.update();

        this.assert_area(
            [ "                                 "
            , "         .-.                     "
            , "     .'. :,'                     "
            , "     : `-`.  . .   ___________   "
            , "      `--.:`-;-;--'          ,`  "
            , "     .'`-'`.'-,`--._____     ,`  "
            , "     `--' .','          `-----'  "
            , "                                 "
            , "                                 "
            , "                                 "
            ]
        );

        weed.x -= 3;
        weed.y += 2;
        branch.x += 3;
        this.update();

        this.assert_area(
            [ "                                 "
            , "           _                     "
            , "      __ .' )                    "
            , "     `. `.`-`.        _____.-----"
            , "       `~~~- _`------'          ,"
            , "      .--`.-. `------.__________,"
            , "      `:'-; ;                    "
            , "       `.' ,`                    "
            , "         ''                      "
            , "                                 "
            ]
        );

        weed.x -= 3;
        weed.y += 2;
        weed.fps = 20;
        branch.y -= 1;
        this.update();

        this.assert_area(
            [ "            .-.                  "
            , "        .'. :,'                  "
            , "        : `-`.        ___________"
            , "         `--._`------'          ,"
            , "        .'`-' `------._____     ,"
            , "        `--'               `-----"
            , "                                 "
            , "   .   . :                       "
            , "   `. `. ;                       "
            , "    `.' ,`                       "
            , "     `,'                         "
            ]
        );

        weed.y -= 2;
        weed.x += 4;
        this.update();

        this.assert_area(
            [ "           _                     "
            , "      __ .' )                    "
            , "     `. `.`-`.        _____.-----"
            , "       `~~~- _`------'          ,"
            , "      .--'`-' `------.__________,"
            , "      `---'. .                   "
            , "        :  ; ;                   "
            , "        `.' ,`                   "
            , "        .','                     "
            , "                                 "
            , "                                 "
            ]
        );

        weed.y -= 2;
        weed.x += 4;
        branch.x -= 1;
        this.update();

        this.assert_area(
            [ "           .-.                   "
            , "       .'. :,'                   "
            , "       : `-`.        ___________ "
            , "        `--._.`..---'          ,`"
            , "       .'`-' :-;:---._____     ,`"
            , "       `--'  :' :         `-----'"
            , "              ''                 "
            , "                                 "
            , "                                 "
            , "                                 "
            , "                                 "
            ]
        );

        weed.y -= 1;
        weed.x += 4;
        branch.x -= 1;
        branch.y += 1;
        this.update();

        this.assert_area(
            [ "                                 "
            , "         _                       "
            , "    __ .' )    .   . :           "
            , "   `. `.`-`.   `. `._;___.-----. "
            , "     `~~~- _`---`.'',`        ,` "
            , "    .--'`-' `----`,'__________,` "
            , "    `---'                        "
            , "                                 "
            , "                                 "
            , "                                 "
            , "                                 "
            ]
        );

        weed.x += 4;
        branch.x -= 2;
        this.update();

        this.assert_area(
            [ "                                 "
            , "        .-.                      "
            , "    .'. :,'            . .       "
            , "    : `-`.        __:__;_;___    "
            , "     `--._`------'  `.' ,`  ,`   "
            , "    .'`-' `------.__.','    ,`   "
            , "    `--'               `-----'   "
            , "                                 "
            , "                                 "
            , "                                 "
            , "                                 "
            ]
        );

        weed.y += 3;
        this.update();

        this.assert_area(
            [ "                                 "
            , "       _                         "
            , "  __ .' )                        "
            , " `. `.`-`.        _____.-----.   "
            , "   `~~~- _`------'          ,`   "
            , "  .--'`-' `------.___.`..___,`   "
            , "  `---'              : ;:        "
            , "                     :' :        "
            , "                      ''         "
            , "                                 "
            , "                                 "
            ]
        );

        weed.y += 3;
        weed.x -= 10;
        branch.y += 3;
        this.update();

        this.assert_area(
            [ "                                 "
            , "                                 "
            , "                                 "
            , "                                 "
            , "        .-.                      "
            , "    .'. :,'                      "
            , "    : `-`.        ___________    "
            , "     `--._`------'          ,`   "
            , "    .'`-'.`--.-:-._____     ,`   "
            , "    `--' `. `. ;       `-----'   "
            , "          `.' ,`                 "
            , "           `,'                   "
            , "                                 "
            , "                                 "
            ]
        );
    }

    public function test_character_grow_shrink():Void
    {
        var dashes:hase.display.Animation = this.create_animation([
            [ "|   |   |"
            ],
            [ "| | |"
            ],
            [ "-"
            , "-"
            , "-"
            , " "
            ],
            [ "-"
            , " "
            , "-"
            , " "
            , "-"
            ]
        ]);

        dashes.x = dashes.y = 1;
        dashes.loopback = true;

        this.root.add_child(dashes);

        var stars:hase.display.Animation = this.create_animation([
            [ "*      "
            , "   *   "
            , "      *"
            ],
            [ "      *"
            , "   *   "
            , "*      "
            , "       "
            ],
            [ "*"
            , " "
            , "*"
            , " "
            , "*"
            ],
            [ " * "
            , " * "
            , " * "
            , " * "
            , " * "
            ],
        ]);

        stars.x = stars.y = 1;
        stars.loopback = true;

        this.root.add_child(stars);

        this.update(3000);

        this.assert_area(
            [ "                        "
            , " *                      "
            , " -                      "
            , " *                      "
            , "                        "
            , " *                      "
            , "                        "
            , "                        "
            , "                        "
            ]
        );

        dashes.x = 5;
        dashes.y = 2;

        stars.x = 8;
        stars.y = 2;

        this.update();

        this.assert_area(
            [ "                        "
            , "                        "
            , "     -   *              "
            , "         *              "
            , "     -   *              "
            , "         *              "
            , "     -   *              "
            , "                        "
            , "                        "
            ]
        );

        stars.fps = 2;
        stars.x = 6;

        this.update();

        this.assert_area(
            [ "                        "
            , "                        "
            , "     -*                 "
            , "     -   *              "
            , "     -      *           "
            , "                        "
            , "                        "
            , "                        "
            , "                        "
            ]
        );

        stars.y -= 1;
        stars.x += 1;
        stars.fps = 1;

        dashes.x -= 3;
        dashes.y += 3;

        this.update();

        this.assert_area(
            [ "                        "
            , "             *          "
            , "          *             "
            , "       *                "
            , "                        "
            , "  | | |                 "
            , "                        "
            , "                        "
            , "                        "
            ]
        );

        stars.x -= 2;
        dashes.fps = 2;
        dashes.y -= 2;
        dashes.x += 2;
        this.update();
        dashes.x += 4;
        this.update();

        this.assert_area(
            [ "                        "
            , "      *                 "
            , "      *                 "
            , "      * -               "
            , "      * -               "
            , "      * -               "
            , "                        "
            , "                        "
            , "                        "
            ]
        );

        this.update(2000);
        dashes.fps = 0;
        dashes.y -= 1;
        stars.x += 1;
        stars.y += 2;
        this.update();

        this.assert_area(
            [ "                        "
            , "                        "
            , "        -               "
            , "      * -               "
            , "        -*              "
            , "            *           "
            , "                        "
            , "                        "
            , "                        "
            ]
        );
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
