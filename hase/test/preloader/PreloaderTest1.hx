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

class Canary {
    public static var canary:Int = 0;
}

@:build(hase.test.Runner.build_single())
class PreloaderTest1 extends hase.test.SurfaceTestCase
{
    public function test_preload():Void
    {
        var preloader = new hase.utils.Preloader();
        preloader.width = 40;
        preloader.height = 6;
        preloader.progress_bar.finished = new Symbol("#".code);
        this.root.add_child(preloader);

        this.assertEquals(0, Canary.canary);
        this.assertFalse(preloader.done);

        this.update();

        this.assert_area(
            [ "  .----------------------------------.  "
            , "  |#################                 |  "
            , "  `----------------------------------'  "
            , "                                        "
            ], 0, 2
        );

        this.assertEquals(1, Canary.canary);
        this.assertFalse(preloader.done);

        this.assertEquals(123, this.load_something());

        this.update();

        this.assert_area(
            [ "  .----------------------------------.  "
            , "  |##################################|  "
            , "  `----------------------------------'  "
            , "                                        "
            ], 0, 2
        );

        this.assertEquals(2, Canary.canary);
        this.assertTrue(preloader.done);

        this.assertEquals(321, this.load_something_else());
    }

    private function load_something():Int
    {
        return hase.utils.Preloader.preload("something to load", {
            Canary.canary++;
            return 123;
        });
    }

    private function load_something_else():Int
    {
        return hase.utils.Preloader.preload("something else to load", {
            Canary.canary++;
            return 321;
        });
    }
}
