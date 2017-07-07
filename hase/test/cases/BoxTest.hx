/* Copyright (C) 2017 aszlig
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
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
