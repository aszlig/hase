/* Copyright (C) 2015 aszlig
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
            ], 0, 0, 9, 5
        );

        motion.force = new PVector(1.0, 1.0);
        this.update();

        this.assert_area(
            [ "         "
            , " .-.     "
            , " `-'     "
            , "         "
            , "         "
            ], 0, 0, 9, 5
        );

        this.update();

        this.assert_area(
            [ "         "
            , "         "
            , "         "
            , "   .-.   "
            , "   `-'   "
            ], 0, 0, 9, 5
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
            ], 0, 0, 9, 7
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
            ], 0, 0, 9, 9
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
            ], 0, 0, 9, 8
        );

        this.update();

        this.assert_area(
            [ "         "
            , "         "
            , "    .-.  "
            , "    `-'  "
            ], 0, 0, 9, 4
        );
    }
}
