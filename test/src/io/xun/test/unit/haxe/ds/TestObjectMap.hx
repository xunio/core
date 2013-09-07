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

    private var _map : ObjectMap<ITestObject, Int>;

    private function _testObjectSet( o : ITestObject ) {
        _map.set(o, 11);
    }

    private function _testObjectGet() {
        for ( obj in _map.keys() ) {
            // this fails. I get back null
            assertEquals(11, _map.get(obj));
        }
    }

    public function testObject() {
        _map = new ObjectMap<ITestObject, Int>();

        var f : TestObject = new TestObject();
        _testObjectSet(f);
        _testObjectGet();
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
