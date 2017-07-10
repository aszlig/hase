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

@:build(hase.test.Runner.build_single())
class PreloaderTest2 extends hase.test.SurfaceTestCase
{
    public function test_preload():Void
    {
        var preloader:Preloader = new Preloader();

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
            , "  Loading one thing to load...          "
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
        return Preloader.preload("one thing to load", "foo" + "bar");
}
