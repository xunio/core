/*
 * xun.io
 * Copyright (c) 2013 XTAIN oHG, <https://company.xtain.net>
 *
 * Licensed under GNU Affero General Public License
 * For full copyright and license information, please see the LICENSE
 * Redistributions of files must retain the above copyright notice.
 *
 * @copyright     Copyright (c) 2013 XTAIN oHG, <https://company.xtain.net>
 * @link          http://xun.io/ xun.io Project
 * @package       io.xun.test.unit.haxe.ds
 * @license       http://www.gnu.org/licenses/agpl-3.0.html GNU Affero General Public License
 */

package io.xun.test.unit.haxe.ds;

/* imports and uses */

import haxe.ds.ObjectMap;

/**
 * Class TestObjectMap
 *
 * @author        Maximilian Ruta <mr@xtain.net>
 * @copyright     Copyright (c) 2013 XTAIN oHG, <https://company.xtain.net>
 * @package       io.xun.test.unit.haxe.ds
 */
class TestObjectMap extends haxe.unit.TestCase {

    public function testObjectAsKey() {
        var map : ObjectMap<TestObject, Int> = new ObjectMap<TestObject, Int>();
        var f1 : TestObject = new TestObject();
        var f2 : TestObject = new TestObject();
        var f3 : TestObject = new TestObject();

        map.set(f1, 2);
        map.set(f2, 4);
        map.set(f3, 8);

        var values : Array<Int> = new Array<Int>();

        for ( v in map.iterator() ) {
            assertEquals(0, (v % 2));
            values.push(v);
        }

        var i : Int = 0;
        for ( o in map.keys() ) {
            assertEquals(values[i], map.get(o));
            i++;
        }

        assertEquals(3, i);
    }

    public function testInterfaceAsKey() {
        // It seems that hxcpp version 3.0.2 has an bug if you use interfaces as keys

        var map : ObjectMap<ITestObject, Int> = new ObjectMap<ITestObject, Int>();
        var f1 : TestObject = new TestObject();
        var f2 : TestObject = new TestObject();
        var f3 : TestObject = new TestObject();

        map.set(f1, 2);
        map.set(f2, 4);
        map.set(f3, 8);

        var values : Array<Int> = new Array<Int>();

        for ( v in map.iterator() ) {
            assertEquals(0, (v % 2));
            values.push(v);
        }

        var i : Int = 0;
        for ( o in map.keys() ) {
            // fails if the appears
            assertEquals(values[i], map.get(o));
            i++;
        }

        assertEquals(3, i);
    }

}

/**
 * Interface ITestObject
 *
 * @author        Maximilian Ruta <mr@xtain.net>
 * @copyright     Copyright (c) 2013 XTAIN oHG, <https://company.xtain.net>
 * @package       io.xun.test.unit.core.event.TestObjectMap
 */
interface ITestObject {}

/**
 * Class TestObject
 *
 * @author        Maximilian Ruta <mr@xtain.net>
 * @copyright     Copyright (c) 2013 XTAIN oHG, <https://company.xtain.net>
 * @package       io.xun.test.unit.core.event.TestObjectMap
 */
class TestObject implements ITestObject {

    public function new() {

    }

}
