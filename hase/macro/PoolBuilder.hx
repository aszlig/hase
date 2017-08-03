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

class PoolBuilder
{
    private var fields:Array<Field>;
    private var clstype:ComplexType;

    private function new(fields:Array<Field>, clstype:ComplexType)
    {
        this.fields = fields;
        this.clstype = clstype;
    }

    private function generate_alloc_kind(ft:FieldType):FieldType
    {
        switch (ft) {
            case FFun(f):
                var args:Array<FunctionArg> = f.args.copy();
                var names:Array<Expr> = [for (a in args) macro $i{a.name}];
                return FFun({
                    args: args,
                    ret: this.clstype,
                    expr: macro return hase.utils.Pool.alloc($a{names}),
                    params: Utils.get_clstype_params(this.clstype)
                });
            default:
                throw 'Unknown field kind ${ft} of new().';
        }
        return ft;
    }

    private function generate_dealloc_kind():FieldType
    {
        return FFun({
            args: [],
            ret: this.clstype,
            expr: macro return hase.utils.Pool.free(this)
        });
    }

    private function add_deallocator():Void
    {
        var access:Array<Access> = [APublic];

        switch (Context.resolveType(this.clstype, Context.currentPos())) {
            case TInst(_.get().superClass => sc, _) if (sc != null):
                access.push(AOverride);
            default:
        }

        this.fields.push({
            name: "free",
            access: access,
            kind: this.generate_dealloc_kind(),
            pos: Context.currentPos()
        });
    }

    private function build_pool():Array<Field>
    {
        for (f in this.fields) {
            if (f.name == "new") {
                this.fields.push({
                    name: "alloc",
                    doc: f.doc,
                    access: [APublic, AStatic, AInline],
                    kind: this.generate_alloc_kind(f.kind),
                    pos: Context.currentPos()
                });
                this.add_deallocator();
                return this.fields;
            }
        }

        throw 'No constructor found for ${this.clstype}';
    }


    public static function build():Array<Field>
    {
        var fields:Array<Field> = Context.getBuildFields();
        var type:Type = Context.getLocalType();
        var ct:ComplexType = Context.toComplexType(type);
        return new PoolBuilder(fields, ct).build_pool();
    }
}
#end
