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
package hase.display;

import hase.geom.Raster;
import hase.geom.Rect;

class Image implements hase.iface.Raster<Symbol>
{
    private var raster:Raster<Symbol>;

    public var dirty_rect(default, null):Rect;
    public var is_dirty(default, null):Bool;

    public var width(get, set):Int;
    public var height(get, set):Int;

    private function new(raster:Raster<Symbol>)
    {
        this.raster = raster;
        this.dirty_rect =
            new hase.geom.Rect(0, 0, raster.width, raster.height);
        this.is_dirty = true;
    }

    private inline function get_width():Int
        return this.raster.width;

    private function set_width(width:Int):Int
    {
        if (width > this.raster.width) {
            this.union_rect(
                this.raster.width - 1,
                0,
                width - this.raster.width,
                this.raster.height
            );
        } else if (width < this.raster.width) {
            this.union_rect(
                width - 1,
                0,
                this.raster.width - width,
                this.raster.height
            );
        }
        return this.raster.width = width;
    }

    private inline function get_height():Int
        return this.raster.height;

    private function set_height(height:Int):Int
    {
        if (height > this.raster.height) {
            this.union_rect(
                0,
                this.raster.height - 1,
                this.raster.width,
                height - this.raster.height
            );
        } else if (height < this.raster.height) {
            this.union_rect(
                0,
                height - 1,
                this.raster.width,
                this.raster.height - height
            );
        }
        return this.raster.height = height;
    }

    private function union_rect(x:Int, y:Int, width:Int, height:Int):Void
    {
        if (this.is_dirty) {
            this.dirty_rect.union_values_(x, y, width, height);
        } else {
            this.dirty_rect.x = x;
            this.dirty_rect.y = y;
            this.dirty_rect.width = width;
            this.dirty_rect.height = height;
            this.is_dirty = true;
        }
    }

    public function reset_dirty():Void
    {
        this.dirty_rect.x = 0;
        this.dirty_rect.y = 0;
        this.dirty_rect.width = this.raster.width;
        this.dirty_rect.height = this.raster.height;
        this.is_dirty = false;
    }

    public function clear(?val:Symbol):Void
    {
        this.dirty_rect.x = 0;
        this.dirty_rect.y = 0;
        this.dirty_rect.width = this.raster.width;
        this.dirty_rect.height = this.raster.height;
        this.is_dirty = true;
        return this.raster.clear(val);
    }

    public inline function get(x:Int, y:Int):Symbol
        return this.raster.get(x, y);

    private inline function union_set(x:Int, y:Int, val:Symbol):Void
    {
        if (this.raster.get(x, y) != val)
            this.union_rect(x, y, 1, 1);
    }

    public function set(x:Int, y:Int, val:Symbol):Symbol
    {
        this.union_set(x, y, val);
        return this.raster.set(x, y, val);
    }

    public inline function unsafe_get(x:Int, y:Int):Symbol
        return this.raster.unsafe_get(x, y);

    public function unsafe_set(x:Int, y:Int, val:Symbol):Symbol
    {
        this.union_set(x, y, val);
        return this.raster.unsafe_set(x, y, val);
    }

    public inline function map_(f:Int -> Int -> Symbol -> Void):Void
        return this.raster.map_(f);

    public function merge_raster(raster:Raster<Symbol>):Void
    {
        this.width = raster.width;
        this.height = raster.height;
        raster.map_(this.unsafe_set);
    }

    public inline static function from_raster(raster:Raster<Symbol>):Image
        return new Image(raster.copy());

    public inline static function
        create(width:Int, height:Int, ?val:Symbol, ?def:Symbol):Image
    {
        return new Image(Raster.create(
            width, height,
            val == null ? new Symbol(0) : val,
            def == null ? new Symbol(0) : def
        ));
    }

    public inline static function
        from_2d_array(array:Array<Array<Symbol>>):Image
        return new Image(Raster.from_2d_array(array, new Symbol(0)));
}
