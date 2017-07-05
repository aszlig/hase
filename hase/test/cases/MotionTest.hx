/* Copyright (C) 2015-2017 aszlig
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
