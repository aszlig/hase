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
package hase.macro;

#if macro
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.ExprTools;
import haxe.macro.Type;

class RenewableBuilder
{
    private static var renew_idx:Int = 0;
    private static var indices:Map<String, Int> = new Map();

    private var clsname:String;
    private var clstype:ComplexType;
    private var fields:Array<Field>;

    private var ident:String;
    private var super_ident:Null<String>;

    private var is_constructor:Bool;

    public function new(clsname:String, clstype:ComplexType,
                        fields:Array<Field>, ident:String,
                        sident:Null<String>)
    {
        this.clsname = clsname;
        this.clstype = clstype;
        this.fields = fields;

        this.ident = ident;
        this.super_ident = sident;
        this.is_constructor = false;
    }

    private function replace_super_call(e:Expr, params:Array<Expr>):Null<Expr>
    {
        if (this.is_constructor) {
            switch (e) {
                case macro super:
                default: return null;
            }
        } else {
            switch (e) {
                case macro super.renew:
                default: return null;
            }
        }

        if (this.super_ident == null)
            throw 'Cannot call super without superclass in ${this.clsname}.';
        var sident:String = this.super_ident;
        return macro this.$sident($a{params});
    }

    private function mangle_function(e:Expr):Expr
    {
        return switch (e.expr) {
            case EReturn(null):
                var replaced:Expr = macro return this;
                replaced.pos = e.pos;
                replaced;
            case ECall(ec, params):
                var replaced:Null<Expr> = this.replace_super_call(ec, params);
                if (replaced == null)
                    ExprTools.map(e, this.mangle_function);
                else
                    replaced;
            default:
                ExprTools.map(e, this.mangle_function);
        }
    }

    private function insert_return(e:Expr):Expr
    {
        return {
            expr: switch (e.expr) {
                case EBlock(vals):
                    EBlock(vals.concat([macro return this]));
                default:
                    EBlock([e, macro return this]);
            },
            pos: e.pos
        };
    }

    private function process_kind(ft:FieldType):FieldType
    {
        switch (ft) {
            case FFun(f):
                var new_expr:Expr = this.mangle_function(f.expr);
                return FFun({
                    args: f.args.copy(),
                    ret: this.clstype,
                    expr: this.insert_return(new_expr),
                    params: f.params.copy()
                });
            default:
                throw 'Unknown field kind ${ft} for renewable.';
        }
        return ft;
    }

    private function build_renewable():Array<Field>
    {
        for (f in this.fields) {
            if (f.name == "renew") {
                f.name = this.ident;
                this.is_constructor = false;
                f.kind = this.process_kind(f.kind);
                return this.fields;
            }
        }

        for (f in this.fields) {
            if (f.name == "new") {
                this.is_constructor = true;
                var new_kind:FieldType = this.process_kind(f.kind);
                this.fields.push({
                    name: this.ident,
                    doc: f.doc,
                    meta: f.meta,
                    access: f.access,
                    kind: new_kind,
                    pos: Context.currentPos()
                });
                return this.fields;
            }
        }

        throw 'Class ${this.clsname} does not have a constructor'
            + " or a renew() method.";
    }

    @:allow(hase.utils.Renew.object)
    private static function
        get_or_create_ident(clsname:String):String
    {
        if (!RenewableBuilder.indices.exists(clsname))
            RenewableBuilder.indices[clsname] = RenewableBuilder.renew_idx++;

        return RenewableBuilder.mkident(RenewableBuilder.indices[clsname]);
    }

    private inline static function mkident(index:Int):String
        return "__renew_" + Std.string(index);

    public static function build():Array<Field>
    {
        var thisclass:Null<String> = null;
        var superclass:Null<String> = null;
        var ident:Null<String> = null;
        var super_ident:Null<String> = null;

        var type:Type = Context.getLocalType();
        var thistype = Context.toComplexType(type);

        switch (type) {
            case TInst(ct, _):
                thisclass = ct.toString();
                switch (ct.get().superClass) {
                    case null:
                    case sc:
                        superclass = sc.t.toString();
                }
            default:
        }

        if (thisclass == null)
            throw "Unable to find own class while building Renewable.";

        if (superclass != null)
            super_ident = RenewableBuilder.get_or_create_ident(superclass);

        ident = RenewableBuilder.get_or_create_ident(thisclass);

        return new RenewableBuilder(
            thisclass, thistype,
            Context.getBuildFields(),
            ident, super_ident
        ).build_renewable();
    }
}
#end
