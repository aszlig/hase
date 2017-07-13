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
package hase.iface;

interface Raster<T>
{
    public var width(get, set):Int;
    public var height(get, set):Int;

    public function clear(?val:T):Void;

    public function unsafe_get(x:Int, y:Int):T;
    public function unsafe_set(x:Int, y:Int, val:T):T;

    public function get(x:Int, y:Int):T;
    public function set(x:Int, y:Int, val:T):T;

    public function map_(f:Int -> Int -> T -> Void):Void;
}
