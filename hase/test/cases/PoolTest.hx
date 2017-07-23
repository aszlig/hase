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
}
