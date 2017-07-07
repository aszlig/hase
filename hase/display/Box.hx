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

    private function trigger_rebuild(from:Symbol, to:Symbol):Symbol
    {
        if (from != to)
            this.needs_rebuild = true;
        return to;
    }

    private inline function rebuild():Void
    {
        if (this.ascii == null) {
            this.ascii = Image.create(
                this.width, this.height, new Symbol(0), new Symbol(0)
            );
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
