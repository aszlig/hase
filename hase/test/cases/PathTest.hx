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
        ], function(a:IntIterator, b:List<Int>) {
            for (i in a) b.add(i);
            b.add(b.last() + 1);
            return b;
        }, new List());

        path.rasterize(area.ascii, function(x:Int, y:Int, v:Symbol) {
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
            Path.bezier( new PVector(1, 6)
                       , new PVector(1, -9)
                       , new PVector(1, 14)
                       , new PVector(1, 9)
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
            Path.bezier( new PVector(6, 1)
                       , new PVector(-9, 1)
                       , new PVector(14, 1)
                       , new PVector(9, 1)
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
            Path.bezier( new PVector(6, 6)
                       , new PVector(-9, -9)
                       , new PVector(14, 14)
                       , new PVector(9, 9)
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
            Path.bezier( new PVector(0, 12)
                       , new PVector(40, -4)
                       , new PVector(-20, -4)
                       , new PVector(20, 12)
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
            Path.bezier( new PVector(13, 1)
                       , new PVector(-20, 7)
                       , new PVector(34, 7)
                       , new PVector(1, 13)
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
            Path.bezier( new PVector(1, 5)
                       , new PVector(3, -1)
                       , new PVector(9, -1)
                       , new PVector(11, 5)
                       ) +
            Path.bezier( new PVector(11, 5)
                       , new PVector(13, -1)
                       , new PVector(19, -1)
                       , new PVector(21, 5)
                       ),
            [ "                       "
            , "   ghijklm   yzABCDE   "
            , "  ef     no wx     FG  "
            , "  d       p v       H  "
            , " bc       qtu       IJ "
            , " a         s         K "
            , "                       "
            ]
        );
    }

    public function test_bezier_cusp_down():Void
    {
        this.assert_path(
            Path.bezier( new PVector(1, 1)
                       , new PVector(21, 11)
                       , new PVector(11, 11)
                       , new PVector(11, 1)
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
            Path.bezier( new PVector(7, 1)
                       , new PVector(-1, 1)
                       , new PVector(-1, 9)
                       , new PVector(7, 9)
                       ) +
            Path.bezier( new PVector(7, 9)
                       , new PVector(15, 9)
                       , new PVector(15, 1)
                       , new PVector(7, 1)
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
            Path.bezier( new PVector(1, 1)
                       , new PVector(13, 11)
                       , new PVector(13, 1)
                       , new PVector(1, 11)
                       ) +
            Path.bezier( new PVector(18, 1)
                       , new PVector(5, 11)
                       , new PVector(5, 1)
                       , new PVector(18, 11)
                       ),
            [ "                    "
            , " ab              UT "
            , "  cd            WV  "
            , "   ef         ZYX   "
            , "    ghi      10     "
            , "      jkl 5432      "
            , "        89a         "
            , "      tIJ bcde      "
            , "    wvH      fg     "
            , "   yFG        hij   "
            , "  DE            kl  "
            , " CB              mn "
            , "                    "
            ]
        );
    }

    public function test_shaky_wave():Void
    {
        this.assert_path(
            Path.bezier( new PVector(1, 14)
                       , new PVector(1, 9)
                       , new PVector(2, -1)
                       , new PVector(3, 1)
                       ) +
            Path.bezier( new PVector(3, 1)
                       , new PVector(7, 29)
                       , new PVector(8, 4)
                       , new PVector(11, 1)
                       ) +
            Path.bezier( new PVector(11, 1)
                       , new PVector(14, 4)
                       , new PVector(15, 29)
                       , new PVector(19, 1)
                       ) +
            Path.bezier( new PVector(19, 1)
                       , new PVector(20, -1)
                       , new PVector(21, 9)
                       , new PVector(21, 14)
                       ),
            [ "                       "
            , "  op       X       vw  "
            , "  nq      VYZ      ux  "
            , "  mr      U 0      ty  "
            , "  lst    ST 12    rsz  "
            , "  k u    R   3    q A  "
            , " ij v    Q   4    p BC "
            , " h  w    P   5    o  D "
            , " g  x   NO   67   n  E "
            , " f  y   M     8   m  F "
            , " e  zA  L     9  kl  G "
            , " d   B  K     a  j   H "
            , " c   C IJ     bc i   I "
            , " b   DEH       dgh   J "
            , " a    FG       ef    K "
            , "                       "
            ]
        );
    }

    public function test_pos_at_polyline():Void
    {
        var poly = new Path(
            [ new PVector(1, 1)
            , new PVector(2, 11)
            , new PVector(3, 1)
            , new PVector(4, 11)
            , new PVector(5, 1)
            ]
        );

        var cross:hase.display.Sprite = this.create_sprite(
            [ "`. .'"
            , "  X  "
            , ".' `."
            ]
        );

        this.root.add_child(cross);
        this.update();

        this.assert_area(
            [ "`. .'"
            , "  X  "
            , ".' `."
            ]
        );

        cross.vector = poly.pos_at(0.25);
        this.update();

        this.assert_area(
            [ "       "
            , " `. .' "
            , "   X   "
            , " .' `. "
            , "       "
            ], 1, 10
        );

        cross.vector = poly.pos_at(0.75);
        this.update();

        this.assert_area(
            [ "       "
            , " `. .' "
            , "   X   "
            , " .' `. "
            , "       "
            ], 3, 10
        );

        cross.vector = poly.pos_at(0.5);
        this.update();

        this.assert_area(
            [ "       "
            , " `. .' "
            , "   X   "
            , " .' `. "
            , "       "
            ], 2
        );
    }

    public function test_pos_at_bezier():Void
    {
        var s_shape = Path.bezier( new PVector(13, 1)
                                 , new PVector(-20, 7)
                                 , new PVector(34, 7)
                                 , new PVector(1, 13)
                                 );

        var cross:hase.display.Sprite = this.create_sprite(
            [ "`. .'"
            , "  X  "
            , ".' `."
            ]
        );

        this.root.add_child(cross);
        this.update();

        this.assert_area(
            [ "`. .'"
            , "  X  "
            , ".' `."
            ]
        );

        cross.vector = s_shape.pos_at(0.0);
        this.update();

        this.assert_area(
            [ "                       "
            , "             `. .'     "
            , "               X       "
            , "             .' `.     "
            , "                       "
            ]
        );

        cross.vector = s_shape.pos_at(0.2);
        this.update();

        this.assert_area(
            [ "                       "
            , "                       "
            , "      `. .'            "
            , "        X              "
            , "      .' `.            "
            , "                       "
            ]
        );

        cross.vector = s_shape.pos_at(0.7);
        this.update();

        this.assert_area(
            [ "       "
            , " `. .' "
            , "   X   "
            , " .' `. "
            , "       "
            ], 10, 9
        );

        cross.vector = s_shape.pos_at(1.0);
        this.update();

        this.assert_area(
            [ "       "
            , " `. .' "
            , "   X   "
            , " .' `. "
            , "       "
            ], 0, 12
        );

        cross.vector = s_shape.pos_at(2.0);
        this.update();

        this.assert_area(
            [ "       "
            , " `. .' "
            , "   X   "
            , " .' `. "
            , "       "
            ], 0, 12
        );
    }

    public function test_iter():Void
    {
        var shape = Path.bezier( new PVector(10, 10)
                               , new PVector(8, 1)
                               , new PVector(4, 8)
                               , new PVector(7, 1)
                               );

        var area:hase.display.Sprite = this.create_sprite([]);

        for (vec in shape) {
            area.ascii.set(Std.int(vec.x), Std.int(vec.y), "x".code);
            var shifted:PVector = vec + new PVector(2, 0);
            area.ascii.set(Std.int(shifted.x), Std.int(shifted.y), "y".code);
        }

        this.root.add_child(area);
        this.update();

        this.assert_area(
            [ "                  "
            , "      xxyy        "
            , "      x y         "
            , "     xxyy         "
            , "     xxyyy        "
            , "       xxyy       "
            , "        xxyy      "
            , "         x y      "
            , "         x y      "
            , "         x y      "
            , "          x y     "
            , "                  "
            ], 0, 0
        );
    }

    public function test_partition():Void
    {
        var shape = Path.bezier( new PVector(10, 10)
                               , new PVector(8, 8)
                               , new PVector(6, 6)
                               , new PVector(4, 4)
                               );
        shape.add(4, 8);

        var area:hase.display.Sprite = this.create_sprite([]);

        for (vec in shape.partition(0.2)) {
            area.ascii.set(Std.int(vec.x), Std.int(vec.y), "x".code);
            var shifted:PVector = vec + new PVector(2, 0);
            area.ascii.set(Std.int(shifted.x), Std.int(shifted.y), "y".code);
        }

        this.root.add_child(area);
        this.update();

        this.assert_area(
            [ "              "
            , "    x y       "
            , "    x y       "
            , "      x y     "
            , "              "
            , "    x y x y   "
            , "              "
            ], 0, 3
        );
    }
}
