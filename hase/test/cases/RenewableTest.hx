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

class TestRenewA implements hase.iface.Renewable
{
    public var state:Int;

    public function new()
        this.state = 0;
}

class TestRenewB extends TestRenewA
{
    public function new()
    {
        super();
        this.state = 666;
    }
}

class TestRenewC extends TestRenewA
{
    public function new(val:Int)
    {
        super();
        this.state = val;
    }
}

class TestRenewD extends TestRenewC
{
    public var another_state:Int;

    public function new(val:Int)
    {
        super(val);
        this.another_state = 12345;
    }

    public function renew():TestRenewD
    {
        this.state = 999;
        this.another_state = 999;
    }
}

class TestRenewE extends TestRenewA
{
    public function new(do_return:Bool)
    {
        super();
        if (do_return) return;
        this.state = 555;
    }
}

class TestRenewF extends TestRenewA
{
    public function renew(do_return:Bool)
    {
        super.renew();
        if (do_return) return;
        this.state = 555;
    }
}

abstract TestRenewAbstract (Int)
{
    public inline function new(val:Int)
        this = val;

    public inline function renew(val:Int):TestRenewAbstract
    {
        this = val;
        return cast this;
    }

    public inline function get_value():Int
        return this;
}

class TestRenewMetaConditions implements hase.iface.Renewable
{
    public var val1:Int;
    public var val2:Int;

    public function new(val:Int)
    {
        if (val > 0) {
            @:new_only {
                this.val1 = val;
                this.val2 = 0;
            }
            @:renew_only {
                this.val1 = 0;
                this.val2 = val;
            }
        }
    }
}

class RenewableTest extends haxe.unit.TestCase
{
    public function test_simple():Void
    {
        var obj = new TestRenewA();
        obj.state = 23;
        hase.utils.Renew.object(obj);
        this.assertEquals(0, obj.state);
    }

    public function test_subclass():Void
    {
        var obj = new TestRenewB();
        obj.state = 777;
        hase.utils.Renew.object(obj);
        this.assertEquals(666, obj.state);
    }

    public function test_with_params():Void
    {
        var obj = new TestRenewC(123);
        this.assertEquals(123, obj.state);
        obj.state = 321;
        hase.utils.Renew.object(obj, 999);
        this.assertEquals(999, obj.state);
    }

    public function test_with_renew_override():Void
    {
        var obj = new TestRenewD(9123);
        this.assertEquals(9123, obj.state);
        this.assertEquals(12345, obj.another_state);
        obj.state = 70;
        obj.another_state = 700;
        hase.utils.Renew.object(obj);
        this.assertEquals(999, obj.state);
        this.assertEquals(999, obj.another_state);
    }

    public function test_renew_return_value():Void
    {
        var obj = new TestRenewA();
        obj.state = 23;
        this.assertEquals(0, hase.utils.Renew.object(obj).state);
    }

    public function test_new_contains_return():Void
    {
        var obj = new TestRenewE(false);
        this.assertEquals(555, obj.state);
        this.assertEquals(0, hase.utils.Renew.object(obj, true).state);
        this.assertEquals(555, hase.utils.Renew.object(obj, false).state);
    }

    public function test_renew_contains_return():Void
    {
        var obj = new TestRenewF();
        this.assertEquals(0, obj.state);
        this.assertEquals(0, hase.utils.Renew.object(obj, true).state);
        this.assertEquals(555, hase.utils.Renew.object(obj, false).state);
    }

    public function test_renew_abstract():Void
    {
        var obj = new TestRenewAbstract(567);
        this.assertEquals(567, obj.get_value());
        this.assertEquals(890, hase.utils.Renew.object(obj, 890).get_value());
    }

    public function test_renew_meta_conditions():Void
    {
        var obj = new TestRenewMetaConditions(123);
        this.assertEquals(123, obj.val1);
        this.assertEquals(0, obj.val2);
        obj = hase.utils.Renew.object(obj, 321);
        this.assertEquals(0, obj.val1);
        this.assertEquals(321, obj.val2);
    }
}
