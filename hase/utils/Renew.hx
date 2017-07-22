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
package hase.utils;

import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Type;

class Renew
{
    #if macro
    private static function has_renewable_iface(ct:ClassType):Bool
    {
        switch (Context.getType("hase.iface.Renewable")) {
            case TInst(rct, _):
                for (ict in ct.interfaces) {
                    if (ict.t.toString() == rct.toString())
                        return true;
                }
            default:
        }

        if (ct.superClass != null)
            return Renew.has_renewable_iface(ct.superClass.t.get());

        return false;
    }
    #end

    macro public static function object(expr:Expr, params:Array<Expr>):Expr
    {
        switch (Context.typeof(expr)) {
            case TInst(ct, _):
                if (!Renew.has_renewable_iface(ct.get()))
                    throw 'Instance ${ct} does not implement Renewable!';
                var ident:String =
                    RenewableBuilder.get_or_create_ident(ct.toString());
                var result:Expr = macro $e{expr}.$ident($a{params});
                result.pos = expr.pos;
                return result;
            default:
                throw 'Unable to resolve renew() for ${expr}';
        }
        return expr;
    }
}
