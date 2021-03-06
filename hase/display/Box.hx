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

class BoxBase extends Sprite
{
    public var corner_tl(default, set):Symbol;
    public var corner_tr(default, set):Symbol;
    public var corner_bl(default, set):Symbol;
    public var corner_br(default, set):Symbol;

    public var edge_left(default, set):Symbol;
    public var edge_right(default, set):Symbol;
    public var edge_top(default, set):Symbol;
    public var edge_bottom(default, set):Symbol;

    private var needs_rebuild:Bool;

    public function new()
    {
        super();
        this.needs_rebuild = true;
    }

    private inline function set_corner_tl(sym:Symbol):Symbol
        return this.corner_tl = this.trigger_rebuild(this.corner_tl, sym);

    private inline function set_corner_tr(sym:Symbol):Symbol
        return this.corner_tr = this.trigger_rebuild(this.corner_tr, sym);

    private inline function set_corner_bl(sym:Symbol):Symbol
        return this.corner_bl = this.trigger_rebuild(this.corner_bl, sym);

    private inline function set_corner_br(sym:Symbol):Symbol
        return this.corner_br = this.trigger_rebuild(this.corner_br, sym);

    private inline function set_edge_left(sym:Symbol):Symbol
        return this.edge_left = this.trigger_rebuild(this.edge_left, sym);

    private inline function set_edge_right(sym:Symbol):Symbol
        return this.edge_right = this.trigger_rebuild(this.edge_right, sym);

    private inline function set_edge_top(sym:Symbol):Symbol
        return this.edge_top = this.trigger_rebuild(this.edge_top, sym);

    private inline function set_edge_bottom(sym:Symbol):Symbol
        return this.edge_bottom = this.trigger_rebuild(this.edge_bottom, sym);

    private function trigger_rebuild<T>(from:T, to:T):T
    {
        if (from != to)
            this.needs_rebuild = true;
        return to;
    }

    private function rebuild():Void
    {
        if (this.ascii == null) {
            this.ascii = Image.create(this.width, this.height);
        }

        this.ascii.set(0, 0, this.corner_tl);
        this.ascii.set(this.width - 1, 0, this.corner_tr);
        this.ascii.set(0, this.height - 1, this.corner_bl);
        this.ascii.set(this.width - 1, this.height - 1, this.corner_br);

        for (x in 1...this.width - 1) {
            this.ascii.set(x, 0, this.edge_top);
            this.ascii.set(x, this.height - 1, this.edge_bottom);
        }

        for (y in 1...this.height - 1) {
            this.ascii.set(0, y, this.edge_left);
            this.ascii.set(this.width - 1, y, this.edge_right);
        }

        this.needs_rebuild = false;
        this.is_dirty = true;
    }

    public function add_content(obj:Object):Object
    {
        obj.x = 1;
        obj.y = 1;
        obj.width = this.width - 1;
        obj.height = this.height - 1;
        return this.add_child(obj);
    }

    private override function set_width(val:Int):Int
    {
        this.needs_rebuild = true;
        return super.set_width(val);
    }

    private override function set_height(val:Int):Int
    {
        this.needs_rebuild = true;
        return super.set_height(val);
    }

    public override function update(td:Float):Void
    {
        if (this.needs_rebuild)
            this.rebuild();
        super.update(td);
    }
}

class Box extends BoxBase
{
    public function new()
    {
        super();

        this.corner_tl = new Symbol(".".code);
        this.corner_tr = new Symbol(".".code);
        this.corner_bl = new Symbol("`".code);
        this.corner_br = new Symbol("'".code);

        this.edge_left   = new Symbol("|".code);
        this.edge_right  = new Symbol("|".code);
        this.edge_top    = new Symbol("-".code);
        this.edge_bottom = new Symbol("-".code);
    }
}

class UnderscoreBox extends BoxBase
{
    public function new()
    {
        super();

        this.corner_tl = new Symbol(0);
        this.corner_tr = new Symbol(0);
        this.corner_bl = new Symbol("|".code);
        this.corner_br = new Symbol("|".code);

        this.edge_left   = new Symbol("|".code);
        this.edge_right  = new Symbol("|".code);
        this.edge_top    = new Symbol("_".code);
        this.edge_bottom = new Symbol("_".code);
    }
}

class ProgressBar extends Box
{
    public var finished(default, set):Symbol;
    public var unfinished(default, set):Symbol;

    public var progress(default, set):Float;

    public function new()
    {
        super();
        this.finished = new Symbol(" ".code, 0, 10);
        this.unfinished = new Symbol(" ".code, 0, 0);
        this.progress = 0.0;
    }

    private inline function set_finished(sym:Symbol):Symbol
        return this.finished = this.trigger_rebuild(this.finished, sym);

    private inline function set_unfinished(sym:Symbol):Symbol
        return this.unfinished = this.trigger_rebuild(this.unfinished, sym);

    private inline function set_progress(percent:Float):Float
        return this.progress = this.trigger_rebuild(this.progress, percent);

    private override function rebuild():Void
    {
        super.rebuild();

        var divider:Int = Std.int(this.progress / 100.0 * (this.width - 2));

        for (x in 1...this.width - 1) {
            for (y in 1...this.height - 1) {
                if (x - 1 < divider)
                    this.ascii.set(x, y, this.finished);
                else
                    this.ascii.set(x, y, this.unfinished);
            }
        }
    }
}
