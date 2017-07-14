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
    private var bbox:Rect;

    private var _width:Int;
    private var _height:Int;

    public var dirty_rect(default, null):Rect;
    public var is_dirty(default, null):Bool;

    public var width(get, set):Int;
    public var height(get, set):Int;

    private function new(raster:Raster<Symbol>)
    {
        this.raster = raster;
        this.bbox = new Rect(0, 0, this.raster.width, this.raster.height);
        this.trim_bbox();

        this._width = this.raster.width;
        this._height = this.raster.height;

        this.dirty_rect = this.bbox.copy();
        this.is_dirty = true;
    }

    private inline function get_width():Int
        return this._width;

    private function set_width(width:Int):Int
    {
        if (width > this.width) {
            this.clear_raster_area(
                this.width, 0, width - this.width, this.height
            );
        } else if (width < this.width) {
            this.clear_raster_area(
                width, 0, this.width - width, this.height
            );
            this.union_dirty(width, 0, this.width - width, this.height);
        }
        return this._width = width;
    }

    private inline function get_height():Int
        return this._height;

    private function set_height(height:Int):Int
    {
        if (height > this.height) {
            this.clear_raster_area(
                0, this.height, this.width, height - this.height
            );
        } else if (height < this.height) {
            this.clear_raster_area(
                0, height, this.width, this.height - height
            );
            this.union_dirty(0, height, this.width, this.height - height);
        }
        return this._height = height;
    }

    // TODO: Make this function lazy!
    private function clear_raster_area(x, y, width, height):Void
    {
        if (x >= this.raster.width || y >= this.raster.height)
            return;

        for (y in y...Std.int(Math.min(this.raster.height, y + height)))
            for (x in x...Std.int(Math.min(this.raster.width, x + width)))
                this.raster.unsafe_set(x, y, new Symbol(0));
    }

    private function is_occupied_row(y:Int):Bool
    {
        for (x in 0...this.raster.width)
            if (this.raster.unsafe_get(x, y) != new Symbol(0))
                return true;
        return false;
    }

    private function is_occupied_col(x:Int):Bool
    {
        for (y in 0...this.raster.height)
            if (this.raster.unsafe_get(x, y) != new Symbol(0))
                return true;
        return false;
    }

    private inline function truncate_bbox():Void
    {
        this.bbox.x = 0;
        this.bbox.y = 0;
        this.bbox.width = 0;
        this.bbox.height = 0;
    }

    private function trim_bbox():Void
    {
        if (this.bbox.width == 0 || this.bbox.height == 0)
            return this.truncate_bbox();

        var x:Int = this.bbox.left;
        while (x < this.bbox.right) {
            if (this.is_occupied_col(x)) {
                this.bbox.width -= x - this.bbox.left;
                this.bbox.x = x;
                break;
            }
            x++;
        }

        if (x == this.bbox.right)
            return this.truncate_bbox();

        x = this.bbox.right;
        while (x-- > this.bbox.left) {
            if (this.is_occupied_col(x)) {
                this.bbox.width = (x - this.bbox.left) + 1;
                break;
            }
        }

        for (y in this.bbox.top...this.bbox.bottom) {
            if (this.is_occupied_row(y)) {
                this.bbox.height -= y - this.bbox.top;
                this.bbox.y = y;
                break;
            }
        }

        var y:Int = this.bbox.bottom;
        while (y-- > this.bbox.top) {
            if (this.is_occupied_row(y)) {
                this.bbox.height = (y - this.bbox.top) + 1;
                break;
            }
        }
    }

    private function union_dirty(x:Int, y:Int, width:Int, height:Int):Void
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
        this.dirty_rect.x = this.bbox.x;
        this.dirty_rect.y = this.bbox.y;
        this.dirty_rect.width = this.bbox.width;
        this.dirty_rect.height = this.bbox.height;
        this.is_dirty = false;
        this.trim_bbox();
    }

    public function clear(?val:Symbol):Void
    {
        if (val == null) {
            this.dirty_rect.x = 0;
            this.dirty_rect.y = 0;
            this.dirty_rect.width = this.width;
            this.dirty_rect.height = this.height;
            this.clear_raster_area(0, 0, this.width, this.height);
            this.is_dirty = true;
        } else {
            this.map_(function(x:Int, y:Int, sym:Symbol):Void {
                this.set(x, y, val);
            });
        }
    }

    public inline function get(x:Int, y:Int):Symbol
        return this.unsafe_get(x, y);

    public function set(x:Int, y:Int, val:Symbol):Symbol
    {
        if (x >= this.width)
            this.width = x + 1;
        if (y >= this.height)
            this.height = y + 1;

        return this.unsafe_set(x < 0 ? 0 : x, y < 0 ? 0 : y, val);
    }

    public function unsafe_get(x:Int, y:Int):Symbol
    {
        if (!this.bbox.contains(x, y))
            return new Symbol(0);
        else if (this.raster.width <= x || this.raster.height <= y)
            return new Symbol(0);
        return this.raster.unsafe_get(x, y);
    }

    public function unsafe_set(x:Int, y:Int, val:Symbol):Symbol
    {
        if (!this.bbox.contains(x, y)) {
            if (val == new Symbol(0))
                return val;
            else
                this.bbox.union_values_(x, y, 1, 1);
        }

        if (x >= this.raster.width) {
            if (val == new Symbol(0))
                return val;
            else
                this.raster.width = x + 1;
        }

        if (y >= this.raster.height) {
            if (val == new Symbol(0))
                return val;
            else
                this.raster.height = y + 1;
        }

        if (this.raster.unsafe_get(x, y) != val) {
            this.raster.unsafe_set(x, y, val);
            this.union_dirty(x, y, 1, 1);
        }
        return val;
    }

    public function map_(f:Int -> Int -> Symbol -> Void):Void
    {
        for (y in 0...this.height)
            for (x in 0...this.width)
                f(x, y, this.unsafe_get(x, y));
    }

    public inline function merge_raster(raster:Raster<Symbol>):Void
    {
        this.width = raster.width;
        this.height = raster.height;
        return raster.map_(this.set);
    }

    public inline static function from_raster(raster:Raster<Symbol>):Image
        return new Image(raster.copy());

    public inline static function
        create(width:Int, height:Int, ?val:Symbol):Image
    {
        return new Image(Raster.create(
            width, height,
            val == null ? new Symbol(0) : val,
            new Symbol(0)
        ));
    }

    public inline static function
        from_2d_array(array:Array<Array<Symbol>>):Image
        return new Image(Raster.from_2d_array(array, new Symbol(0)));
}
