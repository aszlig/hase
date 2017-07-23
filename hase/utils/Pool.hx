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

#if macro
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Type;
import haxe.macro.TypeTools;
#end

class Pool
{
    #if macro
    private static var pools:Map<String, String> = new Map();
    private static var poolidx:Int = 0;

    private static function
        resolve_params(params:Map<String, Type>, type:Type):Type
    {
        return switch (type) {
            case TInst(_.get() => i, p) if (params.exists(i.name)):
                params[i.name];
            default:
                TypeTools.map(type, Pool.resolve_params.bind(params, _));
        }
    }

    private static function build_pool(type:Type):String
    {
        var clsname:String = 'PoolForType_${Pool.poolidx++}';
        var objtype:ComplexType = Context.toComplexType(type);

        var typepath:TypePath = switch (objtype) {
            case TPath(tp): tp;
            default: throw 'Cannot get type path for ${type}!';
        };

        var param_types:Map<String, Type> = new Map();

        var ctor_type:Type = switch (type) {
            case TInst(_.get() => t, ptypes):
                for (i in 0...t.params.length)
                    param_types[t.params[i].name] = ptypes[i];
                t.constructor.get().type;
            default:
                throw 'Unable to get constructor type for ${type}!';
        }

        var ctor_args = switch (ctor_type) {
            case TFun(args, _):
                [for (a in args) {
                    name: a.name,
                    opt: a.opt,
                    type: Context.toComplexType(TypeTools.map(
                        a.t, Pool.resolve_params.bind(param_types, _)
                    ))
                }];
            default:
                throw 'Unable to get constructor arguments for ${type}!';
        }

        var params:Array<Expr> = [
            for (a in ctor_args) macro $i{a.name}
        ];

        var renew_params:Array<Expr> = [
            macro $i{clsname}.objects[--$i{clsname}.offset]
        ].concat(params);

        var fetchfun:Function = {
            args: ctor_args,
            ret: macro : Null<$objtype>,
            expr: macro {
                if ($i{clsname}.offset == 0)
                    return new $typepath($a{params});
                else
                    return hase.utils.Renew.object($a{renew_params});
            }
        };

        var cls:TypeDefinition = macro class $clsname {
            public static var objects:Array<$objtype> = new Array();
            public static var offset:Int = 0;

            public static function release(obj:$objtype):Void
            {
                if (obj == null)
                    return;

                var idx:Int = $i{clsname}.objects.indexOf(obj);
                if (idx == -1 || idx >= $i{clsname}.offset)
                    $i{clsname}.objects[$i{clsname}.offset++] = obj;
            }
        };

        cls.fields.push({
            name: "fetch",
            access: [APublic, AStatic],
            kind: FFun(fetchfun),
            pos: Context.currentPos()
        });

        Context.defineType(cls);
        return clsname;
    }

    private static function get_or_create_pool(type:Type):String
    {
        var hashed:String = Context.signature(Context.toComplexType(type));
        return Pool.pools.exists(hashed)
             ? Pool.pools[hashed]
             : (Pool.pools[hashed] = Pool.build_pool(type));
    }

    private static function resolve_type(type:Type):Type
    {
        return switch (Context.followWithAbstracts(type)) {
            case TMono(t):
                var msg:String = "Unable to resolve the type to use for the"
                               + " memory pool. Please provide a type"
                               + " declaration.";
                Context.error(msg, Context.currentPos());
            case t: t;
        }
    }
    #end

    macro public static function alloc(params:Array<Expr>):Expr
    {
        var type:Type = Pool.resolve_type(Context.getExpectedType());
        var pool:String = Pool.get_or_create_pool(type);

        return macro $i{pool}.fetch($a{params});
    }

    macro public static function free(expr:Expr):Expr
    {
        var type:Type = Pool.resolve_type(Context.typeof(expr));
        var pool:String = Pool.get_or_create_pool(type);

        return macro $i{pool}.release($e{expr});
    }
}
