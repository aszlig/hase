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
import haxe.macro.TypedExprTools;
import haxe.macro.Type;

class AutoFree
{
    private var expr:Expr;

    private var decls:Array<Expr>;
    private var frees:Array<Expr>;

    private var tvars:Map<String, Void>;

    public function new(expr:Expr)
    {
        this.expr = expr;
        this.decls = new Array();
        this.frees = new Array();
        this.tvars = new Map();
    }

    private function get_varname(name:String, idx:Int = 0):String
    {
        var proposed:String = "__" + name
                            + (idx > 0 ? "_" + Std.string(idx) : "");
        if (this.tvars.exists(proposed))
            return this.get_varname(name, idx + 1);
        this.tvars[proposed] = null;
        return proposed;
    }

    private function make_tempvar():Expr
    {
        var name:String = this.get_varname("tmp");
        var decl:Expr = macro var $name;
        Context.typeExpr(decl);
        this.decls.push(decl);
        this.frees.push(macro hase.utils.Pool.free($i{name}));
        return macro $i{name};
    }

    private function handle_disposable(e:Expr):Expr
    {
        return switch (e.expr) {
            case ECall(_, _) | EField(_, _):
                macro ($e{this.make_tempvar()} = $e{e});
            default: e;
        }
    }

    private function
        find_field(name:String, fields:Array<ClassField>):ClassField
    {
        return Lambda.find(
            fields,
            function(f:ClassField) return f.name == name
        );
    }

    private function
        find_property_type(name:String, fields:Array<ClassField>):Null<Type>
    {
        var cf:ClassField = this.find_field(name, fields);
        if (cf == null)
            return null;

        switch (cf) {
            case {kind: FVar(AccCall, _)}:
                var accname:String = "get_" + name;
                var accfun:Null<ClassField> = this.find_field(accname, fields);
                if (accfun == null)
                    return null;
                switch (accfun.type) {
                    case TFun(_, ret):
                        return ret;
                    default:
                        return null;
                }
            default:
                return null;
        }
    }

    private function collect_allocs(e:Expr):Expr
    {
        switch (e.expr) {
            case EBinop(OpAssign, {expr: EConst(CIdent(_))}, _):
                return e;
            case ECall(_, _):
                switch (Context.typeof(e)) {
                    case TType(_.get() => {module: "hase.mem.Types",
                                           name: "Disposable"}, _):
                        return this.handle_disposable(e);
                    default:
                };
            case EField(fe, field):
                switch (Context.typeof(fe)) {
                    case TInst(_.get().fields.get() => fields, _):
                        switch (this.find_property_type(field, fields)) {
                            case TType(_.get() => {module: "hase.mem.Types",
                                                   name: "Disposable"}, _):
                                return this.handle_disposable(e);
                            default:
                        };
                    default:
                };
            default:
        };

        return switch (Context.typeof(e)) {
            case TType(_.get() => {module: "hase.mem.Types",
                                   name: "Allocated"}, _):
                this.handle_disposable(e);
            default:
                ExprTools.map(e, this.collect_allocs);
        };
    }

    private function wrap_tempvars(e:Expr):Expr
    {
        var result:Array<Expr> = new Array();
        result = result.concat(this.decls);
        var wrapvar:String = this.get_varname("result");
        result.push(macro var $wrapvar = $e{e});
        result = result.concat(this.frees);
        result.push(macro $i{wrapvar});
        return {expr: EBlock(result), pos: e.pos};
    }

    private function collect_tvars(e:Expr):Void
    {
        switch (e.expr) {
            case EVars(vars):
                for (v in vars)
                    this.tvars[v.name] = null;
            default:
        }

        ExprTools.iter(e, this.collect_tvars);
    }

    public function autofree():Expr
    {
        for (tvar in Context.getLocalVars().keys())
            this.tvars[tvar] = null;

        ExprTools.iter(this.expr, this.collect_tvars);

        var result:Expr = ExprTools.map(this.expr, this.collect_allocs);

        if (this.decls.length == 0)
            return this.expr;

        return this.wrap_tempvars(result);
    }
}
#end
