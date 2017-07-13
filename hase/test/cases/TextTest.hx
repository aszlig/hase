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

import hase.display.Text;

class TextTest extends hase.test.SurfaceTestCase
{
    public function test_simple():Void
    {
        var text = new Text("hello world");
        text.x = 1;
        text.y = 1;

        this.root.add_child(text);
        this.update();

        this.assert_area(
            [ "             "
            , " hello world "
            , "             "
            ]
        );
    }

    public function test_growing():Void
    {
        var text = new Text("hello world");
        text.x = 1;
        text.y = 1;

        this.root.add_child(text);
        this.update();

        this.assert_area(
            [ "             "
            , " hello world "
            , "             "
            ]
        );

        text.text = "more hello world";

        this.update();

        this.assert_area(
            [ "                  "
            , " more hello world "
            , "                  "
            ]
        );
    }

    public function test_shrinking():Void
    {
        var text = new Text("hello big world");
        text.x = 1;
        text.y = 1;

        this.root.add_child(text);
        this.update();

        this.assert_area(
            [ "                 "
            , " hello big world "
            , "                 "
            ]
        );

        text.text = "good bye world";

        this.update();

        this.assert_area(
            [ "                 "
            , " good bye world  "
            , "                 "
            ]
        );

        text.text = "no world";

        this.update();

        this.assert_area(
            [ "                 "
            , " no world        "
            , "                 "
            ]
        );
    }
}
