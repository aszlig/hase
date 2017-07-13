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
package hase.test.preloader;

import hase.display.Symbol;

@:build(hase.test.Runner.build_single())
class PreloaderTest2 extends hase.test.SurfaceTestCase
{
    public function test_preload():Void
    {
        var preloader = new hase.utils.Preloader();

        preloader.width = 40;
        preloader.height = 10;
        preloader.progress_bar.finished = new Symbol("#".code);

        this.root.add_child(preloader);

        this.assertFalse(preloader.done);

        this.update();

        this.assertTrue(preloader.done);

        this.assert_area(
            [ "                                        "
            , "                                        "
            , "                                        "
            , "  Loading thing to load...              "
            , "  .----------------------------------.  "
            , "  |##################################|  "
            , "  `----------------------------------'  "
            , "                                        "
            , "                                        "
            , "                                        "
            ]
        );

        this.assertEquals("foobar", this.load_a_thing());
    }

    private function load_a_thing():String
        return hase.utils.Preloader.preload("thing to load", "foo" + "bar");
}
