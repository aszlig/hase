/* Haxe ASCII Spriting Engine
 *
 * Copyright (C) 2013-2017 aszlig
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
package hase.test;

class Main
{
    public static function main():Void
    {
        var runner = new Runner();
        runner.add(new hase.test.cases.AnimationParserTest());
        runner.add(new hase.test.cases.AnimationTest());
        runner.add(new hase.test.cases.BitmapTest());
        runner.add(new hase.test.cases.BoxTest());
        runner.add(new hase.test.cases.ColorTableTest());
        runner.add(new hase.test.cases.FrameAreaParserTest());
        runner.add(new hase.test.cases.ImageTest());
        runner.add(new hase.test.cases.MiscTest());
        runner.add(new hase.test.cases.MotionTest());
        runner.add(new hase.test.cases.ObjectTest());
        runner.add(new hase.test.cases.PVectorTest());
        runner.add(new hase.test.cases.PathTest());
        runner.add(new hase.test.cases.PoolTest());
        runner.add(new hase.test.cases.RasterTest());
        runner.add(new hase.test.cases.RectTest());
        runner.add(new hase.test.cases.RenewableTest());
        runner.add(new hase.test.cases.SpriteTest());
        runner.add(new hase.test.cases.SurfaceTest());
        runner.add(new hase.test.cases.TextTest());
        runner.run_and_exit();
    }
}
