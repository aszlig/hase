/* Haxe ASCII Spriting Engine
 *
 * Copyright (C) 2013-2017 aszlig
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
package hase.term;

import hase.display.Symbol;
import hase.display.Image;

import hase.geom.Rect;

interface Interface
{
    @:allow(hase.display.Surface)
    private var renderer:hase.term.renderer.Interface;

    @:allow(hase.term.renderer.Interface)
    private function draw_area(rect:Rect, area:Image):Void;

    // XXX: These should be handled by events (such as resize).
    public var width:Int;
    public var height:Int;
    public function exit(code:Int):Void;
    public function get_key():hase.input.Key;

    public function clear(?sym:hase.display.Symbol):Void;
}
