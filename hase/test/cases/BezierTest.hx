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

import hase.display.Symbol;
import hase.geom.Path;
import hase.geom.PVector;

class BezierTest extends hase.test.SurfaceTestCase
{
    public function
        assert_bezier(curve:Array<PVector>, expect:Array<String>):Void
    {
        var b = Path.bezier(curve);
        var area:hase.display.Sprite = this.create_sprite([]);
        b.map2matrix(area.ascii, inline function(x:Int, y:Int, v:Symbol) {
            return new Symbol("x".code);
        });
        this.root.add_child(area);
        this.update();
        this.assert_area(expect);
    }

    public function test_line_vertical():Void
    {
        this.assert_bezier(
            [ new PVector(1, 6)
            , new PVector(1, -9)
            , new PVector(1, 14)
            , new PVector(1, 9)
            ],
            [ "   "
            , " x "
            , " x "
            , " x "
            , " x "
            , " x "
            , " x "
            , " x "
            , " x "
            , " x "
            , " x "
            , "   "
            ]
        );
    }

    public function test_line_horizontal():Void
    {
        this.assert_bezier(
            [ new PVector(6, 1)
            , new PVector(-9, 1)
            , new PVector(14, 1)
            , new PVector(9, 1)
            ],
            [ "            "
            , " xxxxxxxxxx "
            , "            "
            ]
        );
    }

    public function test_line_diagonal():Void
    {
        this.assert_bezier(
            [ new PVector(6, 6)
            , new PVector(-9, -9)
            , new PVector(14, 14)
            , new PVector(9, 9)
            ],
            [ "            "
            , " x          "
            , "  x         "
            , "   x        "
            , "    x       "
            , "     x      "
            , "      x     "
            , "       x    "
            , "        x   "
            , "         x  "
            , "          x "
            , "            "
            ]
        );
    }

    public function test_ribbon():Void
    {
        this.assert_bezier(
            [ new PVector(0, 12)
            , new PVector(40, -4)
            , new PVector(-20, -4)
            , new PVector(20, 12)
            ],
            [ "       xxxxxxx       "
            , "      xx     xx      "
            , "      x       x      "
            , "      x       x      "
            , "      xx     xx      "
            , "       xx   xx       "
            , "        xx xx        "
            , "         xxx         "
            , "        xxxxx        "
            , "      xxx   xxx      "
            , "    xxx       xxx    "
            , " xxxx           xxxx "
            , "xx                 xx"
            ]
        );
    }

    public function test_s():Void
    {
        this.assert_bezier(
            [ new PVector(13, 1)
            , new PVector(-20, 7)
            , new PVector(34, 7)
            , new PVector(1, 13)
            ],
            [ "               "
            , "          xxxx "
            , "      xxxxx    "
            , "   xxxx        "
            , "  xx           "
            , "  xx           "
            , "   xxx         "
            , "     xxxxx     "
            , "         xxx   "
            , "           xx  "
            , "           xx  "
            , "        xxxx   "
            , "    xxxxx      "
            , " xxxx          "
            , "               "
            ]
        );
    }

    public function test_inconspicuous_wave():Void
    {
        this.assert_bezier(
            [ new PVector(0, 4)
            , new PVector(7, -12)
            , new PVector(9, -5)
            , new PVector(10, 26)
            , new PVector(11, -5)
            , new PVector(13, -12)
            , new PVector(20, 4)
            ],
            [ "  xxxxxxx   xxxxxxx  "
            , " xx     xx xx     xx "
            , " x       x x       x "
            , "xx       xxx       xx"
            , "x         x         x"
            ]
        );
    }

    public function test_cusp_down():Void
    {
        this.assert_bezier(
            [ new PVector(1, 1)
            , new PVector(21, 11)
            , new PVector(11, 11)
            , new PVector(11, 1)
            ],
            [ "                "
            , " xx        x    "
            , "  xxx      x    "
            , "    xxx    x    "
            , "      xxx  x    "
            , "        xx xx   "
            , "         xxxx   "
            , "           xxx  "
            , "            xx  "
            , "              x "
            , "                "
            ]
        );
    }
}
