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
        assert_path(path:Path, expect:Array<String>):Void
    {
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

        path.map2matrix(area.ascii, inline function(x:Int, y:Int, v:Symbol) {
            this.assertTrue(syms.length > 0);
            return new Symbol(syms.pop());
        });
        this.root.add_child(area);
        this.update();
        this.assert_area(expect);
    }

    public function test_null():Void
    {
        this.assert_path(new Path([]), []);
    }

    public function test_point():Void
    {
        this.assert_path(
            new Path([new PVector(1, 1)]),
            [ "   "
            , " a "
            , "   "
            ]
        );
    }

    public function test_vertical():Void
    {
        this.assert_path(
            new Path(
                [ new PVector(1, 1)
                , new PVector(1, 10)
                ]
            ),
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
            new Path(
                [ new PVector(1, 10)
                , new PVector(1, 1)
                ]
            ),
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
            new Path(
                [ new PVector(1, 1)
                , new PVector(10, 1)
                ]
            ),
            [ "            "
            , " abcdefghij "
            , "            "
            ]
        );

        this.assert_path(
            new Path(
                [ new PVector(10, 1)
                , new PVector(1, 1)
                ]
            ),
            [ "            "
            , " jihgfedcba "
            , "            "
            ]
        );
    }

    public function test_diagonal():Void
    {
        this.assert_path(
            new Path(
                [ new PVector(1, 1)
                , new PVector(20, 11)
                ]
            ),
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
            new Path(
                [ new PVector(20, 1)
                , new PVector(1, 11)
                ]
            ),
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
            new Path(
                [ new PVector(1, 1)
                , new PVector(1, 5)
                , new PVector(5, 5)
                , new PVector(5, 1)
                , new PVector(1, 1)
                ]
            ),
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
            new Path(
                [ new PVector(1, 1)
                , new PVector(1, 11)
                , new PVector(11, 11)
                , new PVector(1, 1)
                ]
            ),
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
            new Path([new PVector(6, 6), new PVector(1, 6)]),
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
            new Path([new PVector(6, 6), new PVector(11, 6)]),
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
            new Path([new PVector(6, 6), new PVector(6, 1)]),
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
            new Path([new PVector(6, 6), new PVector(6, 11)]),
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
            new Path([new PVector(6, 6), new PVector(1, 1)]),
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
            new Path([new PVector(6, 6), new PVector(11, 1)]),
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
            new Path([new PVector(6, 6), new PVector(11, 11)]),
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
            new Path([new PVector(6, 6), new PVector(1, 11)]),
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
            new Path(
                [ new PVector(6, 1)
                , new PVector(12, 11)
                , new PVector(18, 1)
                , new PVector(1, 7)
                , new PVector(23, 7)
                , new PVector(6, 1)
                ]
            ),
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
            new Path(
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
                ]
            ),
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

    public function test_length():Void
    {
        this.assertEquals(20.0, new Path([
            new PVector(0, 0),
            new PVector(0, 10),
            new PVector(10, 10),
        ]).length);

        this.assertEquals(20.0, new Path([
            new PVector(-5, 5),
            new PVector(-5, -5),
            new PVector(5, -5),
        ]).length);
    }

    public function test_add():Void
    {
        var path:Path = new Path();
        path.add_pvector(new PVector(1, 1));
        this.assert_path(
            path.add(10, 1),
            [ "             "
            , " abcdefghij  "
            , "             "
            ]
        );
    }

    public function test_concat():Void
    {
        var path1:Path = new Path([new PVector(1, 1)]);
        var path2:Path = new Path([new PVector(5, 5)]);
        this.assert_path(
            path1 + path2,
            [ "       "
            , " a     "
            , "  b    "
            , "   c   "
            , "    d  "
            , "     e "
            , "       "
            ]
        );
    }

    public function test_bezier_line_vertical():Void
    {
        this.assert_path(
            Path.bezier(
                [ new PVector(1, 6)
                , new PVector(1, -9)
                , new PVector(1, 14)
                , new PVector(1, 9)
                ]
            ),
            [ "   "
            , " f "
            , " g "
            , " h "
            , " i "
            , " j "
            , " k "
            , " l "
            , " m "
            , " p "
            , " o "
            , "   "
            ]
        );
    }

    public function test_bezier_line_horizontal():Void
    {
        this.assert_path(
            Path.bezier(
                [ new PVector(6, 1)
                , new PVector(-9, 1)
                , new PVector(14, 1)
                , new PVector(9, 1)
                ]
            ),
            [ "            "
            , " fghijklmpo "
            , "            "
            ]
        );
    }

    public function test_bezier_line_diagonal():Void
    {
        this.assert_path(
            Path.bezier(
                [ new PVector(6, 6)
                , new PVector(-9, -9)
                , new PVector(14, 14)
                , new PVector(9, 9)
                ]
            ),
            [ "            "
            , " f          "
            , "  g         "
            , "   h        "
            , "    i       "
            , "     j      "
            , "      k     "
            , "       l    "
            , "        m   "
            , "         p  "
            , "          o "
            , "            "
            ]
        );
    }

    public function test_bezier_ribbon():Void
    {
        this.assert_path(
            Path.bezier(
                [ new PVector(0, 12)
                , new PVector(40, -4)
                , new PVector(-20, -4)
                , new PVector(20, 12)
                ]
            ),
            [ "       HGFEDCB       "
            , "      JI     Az      "
            , "      K       y      "
            , "      L       x      "
            , "      MN     vw      "
            , "       OP   tu       "
            , "        QR rs        "
            , "         STq         "
            , "        mnUVW        "
            , "      jkl   XYZ      "
            , "    ghi       012    "
            , " cdef           3456 "
            , "ab                 78"
            ]
        );
    }

    public function test_bezier_s():Void
    {
        this.assert_path(
            Path.bezier(
                [ new PVector(13, 1)
                , new PVector(-20, 7)
                , new PVector(34, 7)
                , new PVector(1, 13)
                ]
            ),
            [ "               "
            , "          dcba "
            , "      ihgfe    "
            , "   mlkj        "
            , "  on           "
            , "  pq           "
            , "   rst         "
            , "     uvwxy     "
            , "         zAB   "
            , "           CD  "
            , "           FE  "
            , "        JIHG   "
            , "    ONMLK      "
            , " SRQP          "
            , "               "
            ]
        );
    }

    public function test_bezier_inconspicuous_wave():Void
    {
        this.assert_path(
            Path.bezier(
                [ new PVector(0, 4)
                , new PVector(7, -12)
                , new PVector(9, -5)
                , new PVector(10, 26)
                , new PVector(11, -5)
                , new PVector(13, -12)
                , new PVector(20, 4)
                ]
            ),
            [ "  hjlmoqs   FHJKMOQ  "
            , " ef     tu CD     RS "
            , " d       v B       T "
            , "bc       wzA       UV"
            , "a         y         W"
            ]
        );
    }

    public function test_bezier_cusp_down():Void
    {
        this.assert_path(
            Path.bezier(
                [ new PVector(1, 1)
                , new PVector(21, 11)
                , new PVector(11, 11)
                , new PVector(11, 1)
                ]
            ),
            [ "                "
            , " ab        E    "
            , "  cde      D    "
            , "    fgh    C    "
            , "      ijk  B    "
            , "        lm Az   "
            , "         nopy   "
            , "           qxw  "
            , "            sv  "
            , "              u "
            , "                "
            ]
        );
    }

    public function test_bezier_circle():Void
    {
        this.assert_path(
            Path.bezier(
                [ new PVector(7, 1)
                , new PVector(-1, 1)
                , new PVector(-1, 6)
                , new PVector(-1, 11)
                , new PVector(7, 11)
                , new PVector(15, 11)
                , new PVector(15, 6)
                , new PVector(15, 1)
                , new PVector(7, 1)
                ]
            ),
            [ "               "
            , "    dcbONML    "
            , "  gfe     KJI  "
            , " ih         HG "
            , " j           F "
            , " k           E "
            , " l           D "
            , " mn         BC "
            , "  opq     yzA  "
            , "    rstuvwx    "
            , "               "
            ]
        );
    }

    public function test_bezier_x():Void
    {
        this.assert_path(
            Path.bezier(
                [ new PVector(1, 1)
                , new PVector(1, 6)
                , new PVector(56, 26)
                , new PVector(9, 3)
                , new PVector(-22, 6)
                , new PVector(9, 9)
                , new PVector(56, -14)
                , new PVector(1, 6)
                , new PVector(1, 11)
                ]
            ),
            [ "                    "
            , " a              Z21 "
            , " bc           W543  "
            , "  def       T876    "
            , "    gh     ba9      "
            , "     ijk edc        "
            , "       hgfO         "
            , "     kji oNM        "
            , "    ml     LKt      "
            , "  pon       JIHw    "
            , " rq           GFEz  "
            , " s              DCB "
            , "                    "
            ]
        );
    }

    public function test_shaky_wave():Void
    {
        this.assert_path(
            Path.bezier(
                [ new PVector(1, 14)
                , new PVector(3, -26)
                , new PVector(5, 14)
                , new PVector(7, 64)
                , new PVector(9, 14)
                , new PVector(11, -82)
                , new PVector(13, 14)
                , new PVector(15, 64)
                , new PVector(17, 14)
                , new PVector(19, -26)
                , new PVector(21, 14)
                ]
            ),
            [ "                       "
            , "  op       X       vw  "
            , "  nq      VYZ      ux  "
            , "  mrs     U 0     sty  "
            , "  l t    ST 12    r z  "
            , "  k u    R   3    q A  "
            , " ij v    Q   4    p BC "
            , " h  w    P   5    o  D "
            , " g  xy  NO   67  mn  E "
            , " f   z  M     8  l   F "
            , " e   A  L     9  k   G "
            , " d   B  K     a  j   H "
            , " c   C IJ     bc i   I "
            , " b   DEH       dgh   J "
            , " a    FG       ef    K "
            , "                       "
            ]
        );
    }
}