/* Haxe ASCII Spriting Engine
 *
 * Copyright (C) 2017 aszlig
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

import hase.display.Box;
import hase.display.Symbol;

class BoxTest extends hase.test.SurfaceTestCase
{
    public function test_simple_empty():Void
    {
        var box = new Box();
        box.x = 2;
        box.y = 1;
        box.width = 20;
        box.height = 5;

        this.root.add_child(box);
        this.update();

        this.assert_area(
            [ "                        "
            , "  .------------------.  "
            , "  |                  |  "
            , "  |                  |  "
            , "  |                  |  "
            , "  `------------------'  "
            , "                        "
            ]
        );
    }

    public function test_simple_subsprite():Void
    {
        var box = new Box();
        box.x = 2;
        box.y = 1;
        box.width = 20;
        box.height = 5;

        var xxx:hase.display.Sprite = this.create_sprite(
            [ " .--          "
            , " |-  .-.  .-. "
            , " |   `-'  `-' "
            ]
        );

        box.add_content(xxx);

        this.root.add_child(box);
        this.update();

        this.assert_area(
            [ "                        "
            , "  .------------------.  "
            , "  | .--              |  "
            , "  | |-  .-.  .-.     |  "
            , "  | |   `-'  `-'     |  "
            , "  `------------------'  "
            , "                        "
            ]
        );
    }

    public function test_custom_box():Void
    {
        var box = new Box();
        box.x = 2;
        box.y = 1;
        box.width = 20;
        box.height = 5;

        box.corner_tl = new Symbol("A".code);
        box.corner_tr = new Symbol("B".code);
        box.corner_bl = new Symbol("C".code);
        box.corner_br = new Symbol("D".code);

        box.edge_left   = new Symbol("d".code);
        box.edge_right  = new Symbol("b".code);
        box.edge_top    = new Symbol("a".code);
        box.edge_bottom = new Symbol("c".code);

        this.root.add_child(box);
        this.update();

        this.assert_area(
            [ "                        "
            , "  AaaaaaaaaaaaaaaaaaaB  "
            , "  d                  b  "
            , "  d                  b  "
            , "  d                  b  "
            , "  CccccccccccccccccccD  "
            , "                        "
            ]
        );
    }

    public function test_underscore_box():Void
    {
        var box = new UnderscoreBox();
        box.x = 2;
        box.y = 0;
        box.width = 20;
        box.height = 5;

        this.root.add_child(box);
        this.update();

        this.assert_area(
            [ "   __________________   "
            , "  |                  |  "
            , "  |                  |  "
            , "  |                  |  "
            , "  |__________________|  "
            , "                        "
            ]
        );
    }

    public function test_progressbar():Void
    {
        this.terminal.width = 80;

        var box = new ProgressBar();
        box.x = 2;
        box.y = 1;
        box.width = 52;
        box.height = 3;

        box.finished = new Symbol("#".code);

        this.root.width = 60;
        this.update();

        this.root.add_child(box);

        this.update();

        this.assert_area(
            [ "                                                        "
            , "  .--------------------------------------------------.  "
            , "  |                                                  |  "
            , "  `--------------------------------------------------'  "
            , "                                                        "
            ]
        );

        box.progress = 10;
        this.update();

        this.assert_area(
            [ "                                                        "
            , "  .--------------------------------------------------.  "
            , "  |#####                                             |  "
            , "  `--------------------------------------------------'  "
            , "                                                        "
            ]
        );

        box.progress = 20;
        this.update();

        this.assert_area(
            [ "                                                        "
            , "  .--------------------------------------------------.  "
            , "  |##########                                        |  "
            , "  `--------------------------------------------------'  "
            , "                                                        "
            ]
        );

        box.progress = 50;
        this.update();

        this.assert_area(
            [ "                                                        "
            , "  .--------------------------------------------------.  "
            , "  |#########################                         |  "
            , "  `--------------------------------------------------'  "
            , "                                                        "
            ]
        );

        box.progress = 99;
        this.update();

        this.assert_area(
            [ "                                                        "
            , "  .--------------------------------------------------.  "
            , "  |################################################# |  "
            , "  `--------------------------------------------------'  "
            , "                                                        "
            ]
        );

        box.progress = 100;
        this.update();

        this.assert_area(
            [ "                                                        "
            , "  .--------------------------------------------------.  "
            , "  |##################################################|  "
            , "  `--------------------------------------------------'  "
            , "                                                        "
            ]
        );

        box.progress = 120;
        this.update();

        this.assert_area(
            [ "                                                        "
            , "  .--------------------------------------------------.  "
            , "  |##################################################|  "
            , "  `--------------------------------------------------'  "
            , "                                                        "
            ]
        );
    }
}
