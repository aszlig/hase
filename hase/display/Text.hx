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
package hase.display;

class Text extends Sprite
{
    private var _text:String;
    public var text(get, set):String;

    public function new(text:String)
    {
        super();
        this.ascii = Image.create(text.length, 1);
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
