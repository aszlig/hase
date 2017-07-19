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

import hase.display.Object;
import hase.geom.PVector;

class ObjectTest extends hase.test.SurfaceTestCase
{
    public function test_pos_single():Void
    {
        var obj:Object = new Object();
        obj.x = 9;
        obj.y = 10;

        this.root.add_child(obj);
        this.update();

        this.assertEquals(9, obj.x);
        this.assertEquals(10, obj.y);
    }

    public function test_pos_multiple():Void
    {
        var obj1:Object = new Object();
        obj1.x = 9;
        obj1.y = 10;

        var obj2:Object = new Object();
        obj1.add_child(obj2);
        obj2.x = 9;
        obj2.y = 10;

        this.root.add_child(obj1);
        this.update();

        this.assertEquals(9, obj1.x);
        this.assertEquals(10, obj1.y);
        this.assertEquals(9, obj2.x);
        this.assertEquals(10, obj2.y);
        this.assertEquals(18, obj2.absolute_x);
        this.assertEquals(20, obj2.absolute_y);

        obj1.x = 4;
        obj1.y = 4;

        this.update();

        this.assertEquals(4, obj1.x);
        this.assertEquals(4, obj1.y);
        this.assertEquals(9, obj2.x);
        this.assertEquals(10, obj2.y);
        this.assertEquals(13, obj2.absolute_x);
        this.assertEquals(14, obj2.absolute_y);
    }

    public function test_absolute_pos_single():Void
    {
        var obj:Object = new Object();
        obj.absolute_x = 9;
        obj.absolute_y = 10;

        this.root.add_child(obj);
        this.update();

        this.assertEquals(9, obj.x);
        this.assertEquals(10, obj.y);
        this.assertEquals(9, obj.absolute_x);
        this.assertEquals(10, obj.absolute_y);
    }

    public function test_absolute_pos_multiple():Void
    {
        var obj1:Object = new Object();
        obj1.absolute_x = 9;
        obj1.absolute_y = 10;

        var obj2:Object = new Object();
        obj1.add_child(obj2);
        obj2.x = 6;
        obj2.y = 5;

        this.root.add_child(obj1);
        this.update();

        this.assertEquals(15, obj2.absolute_x);
        this.assertEquals(15, obj2.absolute_y);

        obj2.absolute_x = 5;
        obj2.absolute_y = 10;

        this.update();

        this.assertEquals(-4, obj2.x);
        this.assertEquals(0, obj2.y);
        this.assertEquals(5, obj2.absolute_x);
        this.assertEquals(10, obj2.absolute_y);

        obj1.absolute_x = 10;
        obj1.absolute_y = 11;

        this.update();

        this.assertEquals(-4, obj2.x);
        this.assertEquals(0, obj2.y);
        this.assertEquals(6, obj2.absolute_x);
        this.assertEquals(11, obj2.absolute_y);
    }

    public function test_object_center_single():Void
    {
        var obj:Object = new Object();
        obj.x = 5;
        obj.y = 5;
        obj.center_x = 2;
        obj.center_y = 2;

        this.root.add_child(obj);
        this.update();

        this.assertEquals(5, obj.x);
        this.assertEquals(5, obj.y);
        this.assertEquals(2, obj.center_x);
        this.assertEquals(2, obj.center_y);
    }

    public function test_vector_single():Void
    {
        var obj:Object = new Object();
        obj.vector = new PVector(5.2, 4.9);
        obj.center_vector = new PVector(1.3, 6.9);

        this.root.add_child(obj);
        this.update();

        this.assertEquals(5, obj.x);
        this.assertEquals(5, obj.y);
    }

    public function test_vector_multiple():Void
    {
        var obj1:Object = new Object();
        obj1.vector = new PVector(4.8, 4.9);
        obj1.center_vector = new PVector(1.4, 7.3);

        var obj2:Object = new Object();
        obj1.add_child(obj2);
        obj2.vector = obj1.center_vector + new PVector(1.6, 2.0);
        obj2.center_vector = new PVector(1.66, 2.33);

        this.root.add_child(obj1);
        this.update();

        this.assertEquals(5, obj1.x);
        this.assertEquals(5, obj1.y);
        this.assertEquals(8, obj2.absolute_x);
        this.assertEquals(14, obj2.absolute_y);

        obj1.vector = new PVector(3.5, 4.3);

        this.update();

        this.assertEquals(7, obj2.absolute_x);
        this.assertEquals(13, obj2.absolute_y);

        obj2.abs_vector = new PVector(1.75, 2.45);

        this.update();

        this.assertEquals(-2, obj2.x);
        this.assertEquals(-2, obj2.y);
    }
}
