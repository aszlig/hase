/* Haxe ASCII Spriting Engine
 *
 * Copyright (C) 2015-2017 aszlig
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

import hase.display.Motion;
import hase.geom.PVector;

class MotionTest extends hase.test.SurfaceTestCase
{
    public function test_simple():Void
    {
        var ball:hase.display.Sprite = this.create_sprite(
            [ ".-."
            , "`-'"
            ]
        );

        var motion:Motion = new Motion();
        ball.add_child(motion);

        this.root.add_child(ball);

        this.update();

        this.assert_area(
            [ ".-.      "
            , "`-'      "
            , "         "
            , "         "
            , "         "
            ]
        );

        motion.force = new PVector(1.0, 1.0);
        this.update();

        this.assert_area(
            [ "         "
            , " .-.     "
            , " `-'     "
            , "         "
            , "         "
            ]
        );

        this.update();

        this.assert_area(
            [ "         "
            , "         "
            , "         "
            , "   .-.   "
            , "   `-'   "
            ]
        );

        motion.force = new PVector(-1.0, 0.0);
        this.update();

        this.assert_area(
            [ "         "
            , "         "
            , "         "
            , "         "
            , "         "
            , "    .-.  "
            , "    `-'  "
            ]
        );

        this.update();

        this.assert_area(
            [ "         "
            , "         "
            , "         "
            , "         "
            , "         "
            , "         "
            , "         "
            , "    .-.  "
            , "    `-'  "
            ]
        );

        motion.force = new PVector(0.0, -3.0);
        this.update();

        this.assert_area(
            [ "         "
            , "         "
            , "         "
            , "         "
            , "         "
            , "         "
            , "    .-.  "
            , "    `-'  "
            ]
        );

        this.update();

        this.assert_area(
            [ "         "
            , "         "
            , "    .-.  "
            , "    `-'  "
            ]
        );
    }

    public function test_follow_into():Void
    {
        var ball:hase.display.Sprite = this.create_sprite(
            [ ".-."
            , "`-'"
            ]
        );

        var square:hase.display.Sprite = this.create_sprite(
            [ " _ "
            , "|_|"
            ]
        );

        var motion:Motion = new Motion();
        motion.mass = 30;
        motion.follow(square, 1, 5, true);
        ball.add_child(motion);

        ball.z = 10;
        square.x = 37;
        square.y = 1;

        this.root.add_child(ball);
        this.root.add_child(square);

        this.update();

        this.assert_area(
            [ " .-.                                    "
            , " `-'                                  _ "
            , "                                     |_|"
            , "                                        "
            , "                                        "
            ]
        );

        this.update();

        this.assert_area(
            [ "   .-.                                  "
            , "   `-'                                _ "
            , "                                     |_|"
            , "                                        "
            , "                                        "
            ]
        );

        this.update();

        this.assert_area(
            [ "       .-.                              "
            , "       `-'                            _ "
            , "                                     |_|"
            , "                                        "
            , "                                        "
            ]
        );

        this.update();
        this.update();
        this.update();
        this.update();

        // we should now be in range for the slow down
        this.assert_area(
            [ "                             .-.        "
            , "                             `-'      _ "
            , "                                     |_|"
            , "                                        "
            , "                                        "
            ]
        );

        this.update();

        this.assert_area(
            [ "                                    .-. "
            , "                                    `-' "
            , "                                     |_|"
            , "                                        "
            , "                                        "
            ]
        );

        this.update();

        this.assert_area(
            [ "                                        "
            , "                                     .-."
            , "                                     `-'"
            , "                                        "
            , "                                        "
            ]
        );

        // make sure that we have enough updates to check
        // whether the ball stays at its destination and
        // also doesn't surpass it.
        for (_ in 0...50) {
            this.assert_msg(
                ball.x >= 0,
                'Ball x is below 0: ${ball.x}'
            );
            this.assert_msg(
                ball.x <= square.x,
                'Ball x surpassed square x: ${ball.x} > ${square.x}'
            );
            this.assert_msg(
                ball.y <= square.y,
                'Ball y surpassed square y: ${ball.y} > ${square.y}'
            );
            this.update();
        }

        this.assert_area(
            [ "                                        "
            , "                                     .-."
            , "                                     `-'"
            , "                                        "
            , "                                        "
            ]
        );
    }

    public function test_follow():Void
    {
        var ball:hase.display.Sprite = this.create_sprite(
            [ ".-."
            , "`-'"
            ]
        );

        var square:hase.display.Sprite = this.create_sprite(
            [ " _ "
            , "|_|"
            ]
        );

        var motion:Motion = new Motion();
        motion.mass = 30;
        motion.follow(square, 1, 5, false);
        ball.add_child(motion);

        ball.width = 3;
        ball.height = 2;
        ball.z = 10;

        square.width = 3;
        square.height = 2;
        square.x = 37;
        square.y = 1;

        this.root.add_child(ball);
        this.root.add_child(square);

        for (_ in 0...10) {
            this.assert_msg(
                ball.x >= 0,
                'Ball x is below 0: ${ball.x}'
            );
            this.assert_msg(
                ball.x + ball.width <= square.x,
                'Ball x + width surpassed square x: ' +
                '${ball.x + ball.width} > ${square.x}'
            );
            this.assert_msg(
                ball.y <= square.y,
                'Ball y surpassed square y: ${ball.y} > ${square.y}'
            );
            this.update();
        }

        this.assert_area(
            [ "                                  .-.   "
            , "                                  `-' _ "
            , "                                     |_|"
            , "                                        "
            , "                                        "
            ]
        );
    }
}
