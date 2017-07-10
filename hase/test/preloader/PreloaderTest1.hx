/* Copyright (C) 2017 aszlig
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
package hase.test.preloader;

import hase.utils.Preloader;
import hase.display.Symbol;

class Canary {
    public static var canary:Int = 0;
}

@:build(hase.test.Runner.build_single())
class PreloaderTest1 extends hase.test.SurfaceTestCase
{
    public function test_preload():Void
    {
        var preloader:Preloader = new Preloader();
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
        return Preloader.preload("something to load", {
            Canary.canary++;
            return 123;
        });
    }

    private function load_something_else():Int
    {
        return Preloader.preload("something else to load", {
            Canary.canary++;
            return 321;
        });
    }
}
