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
package hase.utils;

import hase.display.Symbol;

enum Variant {
    Plain;
    Color16;
    ColorRed;
    ColorGreen;
    ColorBlue;
    ColorGrey;
}

enum Header {
    ChrAttr(key:String, val:Symbol);
    StrAttr(key:String, val:String);
    IntAttr(key:String, val:Int);
    Variant(variant:Variant);
}

typedef Container = {
    var headers:Array<Header>;
    var body:hase.geom.Raster<Symbol>;
};
