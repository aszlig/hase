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
package hase.display;

class Text extends Sprite
{
    private var _text:String;
    public var text(get, set):String;

    public function new(text:String)
    {
        super();
        this.ascii =
            Image.create(text.length, 1, new Symbol(0), new Symbol(0));
        this.set_text(text);
    };

    private inline function get_text():String
        return this._text;

    private function set_text(text:String):String
    {
        if (text != this._text) {
            for (c in 0...Std.int(Math.max(text.length, this.ascii.width)))
                this.ascii.set(c, 0, c < text.length ? text.charCodeAt(c)
                                                     : new Symbol(0));
            this.is_dirty = true;
        }
        return this._text = text;
    }
}
