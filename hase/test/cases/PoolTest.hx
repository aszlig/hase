/* Haxe ASCII Spriting Engine
 *
 * Copyright (C) 2015-2017 aszlig
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
package hase.test.cases;

import hase.mem.Types;

class Pooled implements hase.iface.Renewable
{
    public var x:Int;
    public var y:Int;

    public var canary:Int;

    public function new(x:Int, y:Int)
    {
        this.x = x;
        this.y = y;
    }
}

class OtherPooled implements hase.iface.Renewable
{
    public var val:Int;
    public var canary:Int;

    public function new(val:Int)
        this.val = val;
}

class PooledWithParam<T> implements hase.iface.Renewable
{
    public var val:Null<T>;
    public var canary:T;

    public function new(val:Null<T>)
        this.val = val;
}

class PooledWithInterface implements hase.iface.Pooling
{
    public var val:Float;
    public var canary:Float;

    public function new(val:Float)
        this.val = val;
}

class PooledSubclassWithInterface
    extends PooledWithInterface
{
    public var another:String;

    public function new()
    {
        super(123.0);
        this.another = "reset";
    }
}

class PooledWithInterfaceAndParam<T> implements hase.iface.Pooling
{
    public var vals:Array<T>;
    public var canary:Array<T>;

    public function new(vals:Array<T>)
        this.vals = vals;
}

class ImplicitAlloc
{
    public var implicit(get, null):PooledWithInterface;

    public function new() {}

    private function get_implicit():Disposable<PooledWithInterface>
        return PooledWithInterface.alloc(222.222);

    public function implicit_fun():Disposable<PooledWithInterface>
        return PooledWithInterface.alloc(333.333);
}

class PoolTest extends haxe.unit.TestCase
{
    public function test_just_alloc():Void
    {
        var obj:Pooled = hase.utils.Pool.alloc(10, 12);
        this.assertEquals(10, obj.x);
        this.assertEquals(12, obj.y);
    }

    public function test_with_canary():Void
    {
        var first:Pooled = hase.utils.Pool.alloc(1, 2);
        this.assertEquals(1, first.x);
        this.assertEquals(2, first.y);
        first.canary = 999;
        hase.utils.Pool.free(first);

        var second:Pooled = hase.utils.Pool.alloc(3, 4);
        this.assertEquals(999, second.canary);
    }

    public function test_with_type_params():Void
    {
        var obj:PooledWithParam<Float> = hase.utils.Pool.alloc(666.0);
        this.assertEquals(666.0, obj.val);
        obj.canary = 1.23;
        hase.utils.Pool.free(obj);

        obj = hase.utils.Pool.alloc(777.0);
        this.assertEquals(777.0, obj.val);
        this.assertEquals(1.23, obj.canary);
    }

    public function test_wrong_hashing():Void
    {
        var obj:OtherPooled = hase.utils.Pool.alloc(100);
        this.assertEquals(100, obj.val);
        obj.canary = 1000;
        hase.utils.Pool.free(obj);

        obj = hase.utils.Pool.alloc(200);
        this.assertEquals(200, obj.val);
        this.assertEquals(1000, obj.canary);
    }

    public function test_explicit_types():Void
    {
        var first = hase.utils.Pool.alloc(Pooled, 5, 6);
        this.assertEquals(5, first.x);
        this.assertEquals(6, first.y);
        first.canary = 123456;
        hase.utils.Pool.free(first);

        var second = hase.utils.Pool.alloc(Pooled, 3, 4);
        this.assertEquals(123456, second.canary);
    }

    public function test_explicit_types_with_type_param():Void
    {
        var obj = hase.utils.Pool.alloc(PooledWithParam, [Float], 9.1);
        this.assertEquals(9.1, obj.val);
        obj.canary = 1.9;
        hase.utils.Pool.free(obj);

        obj = hase.utils.Pool.alloc(PooledWithParam, [Float], 8.1);
        this.assertEquals(8.1, obj.val);
        this.assertEquals(1.9, obj.canary);
    }

    public function test_using_pooling_interface():Void
    {
        var obj:PooledWithInterface = PooledWithInterface.alloc(1.2);
        this.assertEquals(1.2, obj.val);
        obj.canary = 2.0;
        obj.free();

        obj = PooledWithInterface.alloc(2.1);
        this.assertEquals(2.1, obj.val);
        this.assertEquals(2.0, obj.canary);
    }

    public function test_using_pooling_interface_subclass():Void
    {
        var obj:PooledSubclassWithInterface =
            PooledSubclassWithInterface.alloc();
        this.assertEquals(123.0, obj.val);
        this.assertEquals("reset", obj.another);

        obj.canary = 9.0;
        obj.another = "not reset";
        obj.free();

        obj = PooledSubclassWithInterface.alloc();
        this.assertEquals(123.0, obj.val);
        this.assertEquals("reset", obj.another);
        this.assertEquals(9.0, obj.canary);
    }

    public function test_pooling_with_interface_and_param():Void
    {
        var obj:PooledWithInterfaceAndParam<Int> =
            PooledWithInterfaceAndParam.alloc([1, 2, 3]);

        this.assertEquals(3, obj.vals.length);
        this.assertEquals(1, obj.vals[0]);
        this.assertEquals(2, obj.vals[1]);
        this.assertEquals(3, obj.vals[2]);

        obj.canary = [3, 2, 1];
        obj.free();

        obj = PooledWithInterfaceAndParam.alloc([4, 5, 6]);

        this.assertEquals(3, obj.vals.length);
        this.assertEquals(4, obj.vals[0]);
        this.assertEquals(5, obj.vals[1]);
        this.assertEquals(6, obj.vals[2]);

        this.assertEquals(3, obj.canary.length);
        this.assertEquals(3, obj.canary[0]);
        this.assertEquals(2, obj.canary[1]);
        this.assertEquals(1, obj.canary[2]);
    }

    public function test_pooling_with_interface_and_param_different_type():Void
    {
        var obj:PooledWithInterfaceAndParam<Float> =
            PooledWithInterfaceAndParam.alloc([1.2, 2.4, 3.9]);

        this.assertEquals(3, obj.vals.length);
        this.assertEquals(1.2, obj.vals[0]);
        this.assertEquals(2.4, obj.vals[1]);
        this.assertEquals(3.9, obj.vals[2]);

        obj.canary = [3.3, 2.2, 1.1];
        obj.free();

        obj = PooledWithInterfaceAndParam.alloc([4.8, 5.6, 6.1]);

        this.assertEquals(3, obj.vals.length);
        this.assertEquals(4.8, obj.vals[0]);
        this.assertEquals(5.6, obj.vals[1]);
        this.assertEquals(6.1, obj.vals[2]);

        this.assertEquals(3, obj.canary.length);
        this.assertEquals(3.3, obj.canary[0]);
        this.assertEquals(2.2, obj.canary[1]);
        this.assertEquals(1.1, obj.canary[2]);
    }

    public function test_autofree():Void
    {
        var reference:PooledWithInterface;
        var unrelated = PooledWithInterface.alloc(444.444);
        var result = hase.utils.Pool.autofree(PooledWithInterface.alloc(
            (reference = PooledWithInterface.alloc(111.111)).val +
            new ImplicitAlloc().implicit.val +
            new ImplicitAlloc().implicit_fun().val +
            unrelated.val
        ));

        var pool:Array<PooledWithInterface> =
            hase.utils.Pool.get_pooled_objects(PooledWithInterface);

        var pooled = Lambda.find(pool, function(x) return x.val == 222.222);
        this.assertTrue(pooled != null);

        this.assertEquals(1111, Math.round(result.val));
        this.assertEquals(222.222, pooled.val);
        this.assertFalse(Lambda.has(pool, reference));
        this.assertFalse(Lambda.has(pool, unrelated));
    }

    public function test_autofree_scope():Void
    {
        var outer:PooledWithInterface;
        var result = hase.utils.Pool.autofree({
            outer = PooledWithInterface.alloc(1.0);
            var inner:PooledWithInterface = PooledWithInterface.alloc(214.781);
            outer.val + inner.val;
        });

        var pool:Array<PooledWithInterface> =
            hase.utils.Pool.get_pooled_objects(PooledWithInterface);

        var pooled = Lambda.find(pool, function(x) return x.val == 214.781);
        this.assertTrue(pooled != null);

        this.assertEquals(216, Math.round(result));
        this.assertTrue(Lambda.has(pool, outer));
        this.assertEquals(214.781, pooled.val);
    }

    public function test_autofree_var_collision():Void
    {
        var result = hase.utils.Pool.autofree({
            var __tmp = 1;
            var __result = 2;
            var clash = PooledWithInterface.alloc(0.0);
            __tmp + __result + clash.val;
        });

        this.assertEquals(3.0, result);
    }
}
