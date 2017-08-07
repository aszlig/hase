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
    private static var pools:Map<String, Expr> = new Map();
    private static var poolidx:Int = 0;

    private static function
        resolve_params(params:Map<String, Type>, type:Null<Type>):Type
    {
        // Handle TDynamic(null)
        if (type == null)
            return null;

        return switch (type) {
            case TInst(_.get() => i, p) if (params.exists(i.name)):
                params[i.name];
            default:
                TypeTools.map(type, Pool.resolve_params.bind(params, _));
        }
    }

    private static function build_pool(type:Type):Expr
    {
        var clsname:String = 'PoolForType_${Pool.poolidx++}';
        var objtype:ComplexType = Context.toComplexType(type);

        var typepath:TypePath = switch (objtype) {
            case TPath(tp): {name: tp.name, pack: tp.pack, sub: tp.sub};
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

        var ctor_args = switch (Context.follow(ctor_type)) {
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
            ret: macro : hase.mem.Types.Allocated<$objtype>,
            expr: macro {
                if ($i{clsname}.offset == 0)
                    return new $typepath($a{params});
                else
                    return hase.utils.Renew.object($a{renew_params});
            },
            params: hase.macro.Utils.get_clstype_params(objtype)
        };

        var cls:TypeDefinition = macro class $clsname {
            public static var objects = new Array();
            public static var offset:Int = 0;

            public static function release(obj:$objtype):$objtype
            {
                if (obj == null)
                    return obj;

                var idx:Int = $i{clsname}.objects.indexOf(cast obj);
                if (idx == -1 || idx >= $i{clsname}.offset)
                    $i{clsname}.objects[$i{clsname}.offset++] = cast obj;
                return obj;
            }
        };

        for (f in cls.fields) {
            if (f.name == "release") {
                switch (f.kind) {
                    case FFun(attrs):
                        attrs.params = fetchfun.params;
                    default:
                }
            }
        }

        cls.fields.push({
            name: "fetch",
            access: [APublic, AStatic],
            kind: FFun(fetchfun),
            pos: Context.currentPos()
        });

        return hase.macro.Utils.type2module(cls, '__internal.pool.${clsname}');
    }

    private static function get_or_create_pool(type:Type):Expr
    {
        var hashed:String = Context.signature(Context.toComplexType(type));
        return Pool.pools.exists(hashed)
             ? Pool.pools[hashed]
             : (Pool.pools[hashed] = Pool.build_pool(type));
    }

    private static function is_class_type(expr:Expr):Bool
    {
        return switch (Context.typeof(expr)) {
            case TType(_.get().type
                       => TAnonymous(_.get().status
                       => AClassStatics(_)), _):
                true;
            default:
                false;
        }
    }

    private static function resolve_type(type:Type):Type
    {
        var msg:String = "Unable to resolve the type to use for the memory"
                       + " pool. Please provide a type declaration.";
        if (type == null)
            Context.error(msg, Context.currentPos());

        return switch (Context.followWithAbstracts(type)) {
            case TMono(t):
                Context.error(msg, Context.currentPos());
            case t: t;
        }
    }

    private static function resolve_param(param:Type):TypeParam
    {
        return TPType(switch (Context.followWithAbstracts(param)) {
            case TAnonymous(_.get().status => AAbstractStatics(t)):
                Context.toComplexType(t.get().type);
            default:
                throw 'Unable to resolve params for ${param}';
        });
    }

    private static function unpack_params(orig_type:ComplexType, e:Expr):Type
    {
        return switch (Context.typeof(e)) {
            case TInst(_.get() => {pack: [], name: "Array"}, prm):
                Context.resolveType(switch (orig_type) {
                    case TPath(args):
                        for (p in prm)
                            args.params.push(Pool.resolve_param(p));
                        TPath(args);
                    default:
                        throw 'Unable to unpack params for ${orig_type}.';
                }, e.pos);
            default:
                throw 'Unable to resolve class type params in ${e}.';
        }
    }

    private static function resolve_class_type(params:Array<Expr>):Type
    {
        var e:Expr = params.shift();
        var type:Type = Context.typeof(e);
        var ct:ComplexType = Context.toComplexType(Context.follow(type));

        return switch (ct) {
            case TPath({name: "Class", params: [TPType(t)]}):
                try {
                    Context.resolveType(t, e.pos);
                } catch (exception:Dynamic) {
                    Pool.unpack_params(t, params.shift());
                }
            default:
                throw 'Unable to resolve class type for ${ct}.';
        }
    }
    #end

    @:allow(hase.test.cases.PoolTest)
    macro private static function get_pooled_objects(params:Array<Expr>):Expr
    {
        var type:Type = Pool.resolve_class_type(params);
        var pool:Expr = Pool.get_or_create_pool(type);
        return macro $e{pool}.objects;
    }

    macro public static function alloc(params:Array<Expr>):Expr
    {
        var type:Type = params.length > 1 && Pool.is_class_type(params[0])
                      ? Pool.resolve_class_type(params)
                      : Pool.resolve_type(Context.getExpectedType());
        var pool:Expr = Pool.get_or_create_pool(type);

        return macro @:pos(Context.currentPos()) $e{pool}.fetch($a{params});
    }

    macro public static function free(expr:Expr):Expr
    {
        var type:Type = Pool.resolve_type(Context.typeof(expr));
        var pool:Expr = Pool.get_or_create_pool(type);

        return macro @:pos(Context.currentPos()) $e{pool}.release($e{expr});
    }

    macro public static function autofree(expr:Expr):Expr
        return new hase.macro.AutoFree(expr).autofree();
}
