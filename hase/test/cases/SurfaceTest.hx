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

class SurfaceTest extends hase.test.SurfaceTestCase
{
    public function test_overflow_x():Void
    {
        this.root.width = 7;
        this.root.height = 7;

        var arrows:hase.display.Sprite = this.create_sprite(
            [ "->"
            , "->"
            , "->"
            , "->"
            , "->"
            ]
        );

        arrows.x = this.root.width - 1;
        this.root.add_child(arrows);
        this.update();

        this.assert_area(
            [ " - "
            , " - "
            , " - "
            , " - "
            , " - "
            , "   "
            ], this.root.width - 2
        );
    }

    public function test_overflow_y():Void
    {
        this.root.width = 7;
        this.root.height = 7;

        var arrows:hase.display.Sprite = this.create_sprite(
            [ "|||||"
            , "VVVVV"
            ]
        );

        arrows.y = this.root.height - 1;
        this.root.add_child(arrows);
        this.update();

        this.assert_area(
            [ "      "
            , "||||| "
            , "      "
            ], 0, this.root.height - 2
        );
    }
}
