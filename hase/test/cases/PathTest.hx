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

class PathTest extends hase.test.SurfaceTestCase
{
    public function
        assert_path(path:Array<PVector>, expect:Array<String>):Void
    {
        var b = new Path(path);
        var area:hase.display.Sprite = this.create_sprite([]);

        var syms:List<Int> = Lambda.fold([
            "a".code..."z".code,
            "A".code..."Z".code,
            "0".code..."9".code,
            "a".code..."z".code,
            "A".code..."Z".code,
            "0".code..."9".code,
        ], inline function(a:IntIterator, b:List<Int>) {
            for (i in a) b.add(i);
            b.add(b.last() + 1);
            return b;
        }, new List());

        b.map2matrix(area.ascii, inline function(x:Int, y:Int, v:Symbol) {
            this.assertTrue(syms.length > 0);
            return new Symbol(syms.pop());
        });
        this.root.add_child(area);
        this.update();
        this.assert_area(expect);
    }

    public function test_null():Void
    {
        this.assert_path([], []);
    }

    public function test_point():Void
    {
        this.assert_path(
            [new PVector(1, 1)],
            [ "   "
            , " a "
            , "   "
            ]
        );
    }

    public function test_vertical():Void
    {
        this.assert_path(
            [ new PVector(1, 1)
            , new PVector(1, 10)
            ],
            [ "   "
            , " a "
            , " b "
            , " c "
            , " d "
            , " e "
            , " f "
            , " g "
            , " h "
            , " i "
            , " j "
            , "   "
            ]
        );

        this.assert_path(
            [ new PVector(1, 10)
            , new PVector(1, 1)
            ],
            [ "   "
            , " j "
            , " i "
            , " h "
            , " g "
            , " f "
            , " e "
            , " d "
            , " c "
            , " b "
            , " a "
            , "   "
            ]
        );
    }

    public function test_horizontal():Void
    {
        this.assert_path(
            [ new PVector(1, 1)
            , new PVector(10, 1)
            ],
            [ "            "
            , " abcdefghij "
            , "            "
            ]
        );

        this.assert_path(
            [ new PVector(10, 1)
            , new PVector(1, 1)
            ],
            [ "            "
            , " jihgfedcba "
            , "            "
            ]
        );
    }

    public function test_diagonal():Void
    {
        this.assert_path(
            [ new PVector(1, 1)
            , new PVector(20, 11)
            ],
            [ "                      "
            , " a                    "
            , "  bc                  "
            , "    de                "
            , "      fg              "
            , "        hi            "
            , "          jk          "
            , "            lm        "
            , "              no      "
            , "                pq    "
            , "                  rs  "
            , "                    t "
            , "                      "
            ]
        );

        this.assert_path(
            [ new PVector(20, 1)
            , new PVector(1, 11)
            ],
            [ "                      "
            , " a                  a "
            , "  bc              cb  "
            , "    de          ed    "
            , "      fg      gf      "
            , "        hi  ih        "
            , "          kj          "
            , "        ml  lm        "
            , "      on      no      "
            , "    qp          pq    "
            , "  sr              rs  "
            , " t                  t "
            , "                      "
            ]
        );
    }

    public function test_box():Void
    {
        this.assert_path(
            [ new PVector(1, 1)
            , new PVector(1, 5)
            , new PVector(5, 5)
            , new PVector(5, 1)
            , new PVector(1, 1)
            ],
            [ "       "
            , " qponm "
            , " b   l "
            , " c   k "
            , " d   j "
            , " efghi "
            , "       "
            ]
        );
    }

    public function test_triangle():Void
    {
        this.assert_path(
            [ new PVector(1, 1)
            , new PVector(1, 11)
            , new PVector(11, 11)
            , new PVector(1, 1)
            ],
            [ "             "
            , " E           "
            , " bD          "
            , " c C         "
            , " d  B        "
            , " e   A       "
            , " f    z      "
            , " g     y     "
            , " h      x    "
            , " i       w   "
            , " j        v  "
            , " klmnopqrstu "
            , "             "
            ]
        );
    }

    public function test_star_incremential():Void
    {
        this.assert_path(
            [new PVector(6, 6), new PVector(1, 6)],
            [ "             "
            , "             "
            , "             "
            , "             "
            , "             "
            , "             "
            , " fedcba      "
            , "             "
            , "             "
            , "             "
            , "             "
            , "             "
            , "             "
            ]
        );

        this.assert_path(
            [new PVector(6, 6), new PVector(11, 6)],
            [ "             "
            , "             "
            , "             "
            , "             "
            , "             "
            , "             "
            , " fedcbabcdef "
            , "             "
            , "             "
            , "             "
            , "             "
            , "             "
            , "             "
            ]
        );

        this.assert_path(
            [new PVector(6, 6), new PVector(6, 1)],
            [ "             "
            , "      f      "
            , "      e      "
            , "      d      "
            , "      c      "
            , "      b      "
            , " fedcbabcdef "
            , "             "
            , "             "
            , "             "
            , "             "
            , "             "
            , "             "
            ]
        );

        this.assert_path(
            [new PVector(6, 6), new PVector(6, 11)],
            [ "             "
            , "      f      "
            , "      e      "
            , "      d      "
            , "      c      "
            , "      b      "
            , " fedcbabcdef "
            , "      b      "
            , "      c      "
            , "      d      "
            , "      e      "
            , "      f      "
            , "             "
            ]
        );

        this.assert_path(
            [new PVector(6, 6), new PVector(1, 1)],
            [ "             "
            , " f    f      "
            , "  e   e      "
            , "   d  d      "
            , "    c c      "
            , "     bb      "
            , " fedcbabcdef "
            , "      b      "
            , "      c      "
            , "      d      "
            , "      e      "
            , "      f      "
            , "             "
            ]
        );

        this.assert_path(
            [new PVector(6, 6), new PVector(11, 1)],
            [ "             "
            , " f    f    f "
            , "  e   e   e  "
            , "   d  d  d   "
            , "    c c c    "
            , "     bbb     "
            , " fedcbabcdef "
            , "      b      "
            , "      c      "
            , "      d      "
            , "      e      "
            , "      f      "
            , "             "
            ]
        );

        this.assert_path(
            [new PVector(6, 6), new PVector(11, 11)],
            [ "             "
            , " f    f    f "
            , "  e   e   e  "
            , "   d  d  d   "
            , "    c c c    "
            , "     bbb     "
            , " fedcbabcdef "
            , "      bb     "
            , "      c c    "
            , "      d  d   "
            , "      e   e  "
            , "      f    f "
            , "             "
            ]
        );

        this.assert_path(
            [new PVector(6, 6), new PVector(1, 11)],
            [ "             "
            , " f    f    f "
            , "  e   e   e  "
            , "   d  d  d   "
            , "    c c c    "
            , "     bbb     "
            , " fedcbabcdef "
            , "     bbb     "
            , "    c c c    "
            , "   d  d  d   "
            , "  e   e   e  "
            , " f    f    f "
            , "             "
            ]
        );
    }

    public function test_pentagram():Void
    {
        this.assert_path(
            [ new PVector(6, 1)
            , new PVector(12, 11)
            , new PVector(18, 1)
            , new PVector(1, 7)
            , new PVector(23, 7)
            , new PVector(6, 1)
            ],
            [ "                         "
            , "      on         vu      "
            , "       bmlk   yxwt       "
            , "       c   jih   s       "
            , "        dDC   gfr        "
            , "      GFE       edc      "
            , "   JIH   f     p   ba9   "
            , " LMNOPQRSTUVWXYZ01234587 "
            , "          h   n          "
            , "           i m           "
            , "           j l           "
            , "            k            "
            , "                         "
            ]
        );
    }

    public function test_circle():Void
    {
        this.assert_path(
            [ new PVector(2, 3)
            , new PVector(5, 1)
            , new PVector(8, 1)
            , new PVector(11, 3)
            , new PVector(12, 4)
            , new PVector(12, 7)
            , new PVector(11, 8)
            , new PVector(8, 10)
            , new PVector(5, 10)
            , new PVector(2, 8)
            , new PVector(1, 7)
            , new PVector(1, 4)
            ],
            [ "              "
            , "     defg     "
            , "   bc    hi   "
            , "  a        j  "
            , " B          k "
            , " A          l "
            , " z          m "
            , " y          n "
            , "  x        o  "
            , "   wv    qp   "
            , "     utsr     "
            , "              "
            ]
        );
    }

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

    public function test_bezier_line_vertical():Void
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

    public function test_bezier_line_horizontal():Void
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

    public function test_bezier_line_diagonal():Void
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

    public function test_bezier_ribbon():Void
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

    public function test_bezier_s():Void
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

    public function test_bezier_inconspicuous_wave():Void
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

    public function test_bezier_cusp_down():Void
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
