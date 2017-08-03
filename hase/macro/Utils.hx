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

class Utils
{
    public static function type2module(type:TypeDefinition, name:String):Expr
    {
        var module_str:String = Context.getLocalModule();
        var module:Array<String> = module_str.split(".");

        var imports:Array<ImportExpr> = Context.getLocalImports();
        imports.push({
            path: [for (name in module) {
                pos: Context.currentPos(),
                name: name
            }],
            mode: INormal
        });

        Context.defineModule(name, [type], imports);

        return haxe.macro.MacroStringTools.toFieldExpr(name.split("."));
    }

    public static function param2param_decl(tp:TypeParam):TypeParamDecl
    {
        return switch (tp) {
            case TPType(TPath(x = {name: n, params: ps, sub: sub})):
                { name: n + (sub != null ? "." + sub : "")
                , params: [for (p in ps) Utils.param2param_decl(p)]
                };
            default:
                throw 'Unable to decode TypeParam for ${tp}.';
        }
    }

    public static function
        get_clstype_params(ct:ComplexType):Array<TypeParamDecl>
    {
        return switch (ct) {
            case TPath({params: ps}):
                [for (p in ps) Utils.param2param_decl(p)];
            default:
                throw 'Unable to retrieve parameters for ${ct}.';
        }
    }

}
#end
