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
package hase.test.cases;

import hase.ds.LinkedList;

class LinkedListTest extends haxe.unit.TestCase
{
    public function test_empty():Void
    {
        var list:LinkedList<Int> = new LinkedList();
        this.assertEquals("{}", list.toString());
    }

    public function test_singleton():Void
    {
        var list:LinkedList<Int> = new LinkedList();
        list.add(666);
        this.assertEquals("{666}", list.toString());
    }

    public function test_two():Void
    {
        var list:LinkedList<Int> = new LinkedList();
        list.add(666);
        list.add(777);
        this.assertEquals("{666, 777}", list.toString());
    }

    public function test_remove():Void
    {
        var list:LinkedList<Int> = new LinkedList();
        list.add(1);
        list.add(2);
        list.add(3);
        list.add(4);
        list.add(5);
        this.assertEquals("{1, 2, 3, 4, 5}", list.toString());
        list.remove(3);
        this.assertEquals("{1, 2, 4, 5}", list.toString());
        list.remove(1);
        this.assertEquals("{2, 4, 5}", list.toString());
        list.remove(5);
        this.assertEquals("{2, 4}", list.toString());
        list.remove(2);
        this.assertEquals("{4}", list.toString());
        list.remove(4);
        this.assertEquals("{}", list.toString());
        list.remove(123);
        this.assertEquals("{}", list.toString());
    }

    public function test_sort():Void
    {
        var list:LinkedList<Int> = new LinkedList();
        list.add(5);
        list.add(1);
        list.add(3);
        list.add(2);
        list.add(4);
        this.assertEquals("{5, 1, 3, 2, 4}", list.toString());
        list.sort(Reflect.compare);
        this.assertEquals("{1, 2, 3, 4, 5}", list.toString());
    }

    public function test_sort_duplicates():Void
    {
        var list:LinkedList<Array<Int>> = new LinkedList();
        list.add([4, 4]);
        list.add([3, 5]);
        list.add([3, 2]);
        this.assertEquals("{[4,4], [3,5], [3,2]}", list.toString());
        list.sort(function(a, b) return Reflect.compare(a[0], b[0]));
        this.assertEquals("{[3,5], [3,2], [4,4]}", list.toString());
    }

    public function test_iterate():Void
    {
        var list:LinkedList<Int> = new LinkedList();
        list.add(5);
        list.add(4);
        list.add(3);
        list.add(2);
        list.add(1);

        var result:Array<Int> = [for (i in list) i];
        var expected:Array<Int> = [5, 4, 3, 2, 1];
        this.assertEquals(expected.length, result.length);
        for (i in 0...result.length)
            this.assertEquals(expected[i], result[i]);
    }

    public function test_iterate_null():Void
    {
        var list:LinkedList<Int> = new LinkedList();
        this.assertEquals(0, [for (i in list) i].length);
    }
}
