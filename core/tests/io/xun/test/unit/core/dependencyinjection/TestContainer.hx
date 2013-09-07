/*
 * xun.io
 * Copyright (c) 2013, XTAIN oHG <https://company.xtain.net>
 *
 * Licensed under GNU Affero General Public License
 * For full copyright and license information, please see the LICENSE
 * Redistributions of files must retain the above copyright notice.
 *
 * @copyright     Copyright (c) 2013, XTAIN oHG <https://company.xtain.net>
 * @link          http://xun.io/ xun.io Project
 * @package       io.xun.test.unit.core.dependencyinjection
 * @license       http://www.gnu.org/licenses/agpl-3.0.html GNU Affero General Public License
 */

package io.xun.test.unit.core.dependencyinjection;

import io.xun.core.dependencyinjection.ref.Parameter;
import io.xun.core.dependencyinjection.Container;

/**
 * Class TestContainer
 *
 * @author        Maximilian Ruta <mr@xtain.net>
 * @copyright     Copyright (c) 2013, XTAIN oHG <https://company.xtain.net>
 * @package       io.xun.test.unit.core.dependencyinjection
 */
class TestContainer extends haxe.unit.TestCase {

    public function testParameter() {
        var container : Container = new Container();
        var parameter : Parameter = new Parameter('foo', 'baa');

        assertFalse(container.hasParameter('foo'));
        container.setParameter(parameter);
        assertTrue(container.hasParameter('foo'));
        assertEquals(parameter.value, container.getParameter('foo').value);
    }

    public function testSet() {
        var container : Container = new Container();

        assertFalse(container.has('foo'));
        container.set('foo', 'foo2');
        assertTrue(container.has('foo'));

        assertFalse(container.has('foo1'));
        container.set('foo1', 'foo3');
        assertTrue(container.has('foo1'));
    }

    public function testMethodName() {
        assertEquals('getFooService', Container.getMethodName('foo'));
        assertEquals('getFooBaaService', Container.getMethodName('foo.baa'));
        assertEquals('getFooBaaService', Container.getMethodName('foo_baa'));
    }

    public function testHas() {
        var container : Container = new ExtendedContainer();

        assertFalse(container.has('foo'));
        container.set('foo', 'foo2');
        assertTrue(container.has('foo'));

        assertTrue(container.has('baa_da'));
    }

    public function testGetServiceIds() {
        var container : Container = new ExtendedContainer();

        container.set('foo', 'foo2');
        container.set('foo1', 'foo3');

        for ( service in container.getServiceIds() ) {
            assertTrue(Lambda.has([Container.CONTAINER, 'foo', 'foo1', 'baa_da'], service));
        }
    }

    public function testRegister() {
        // TODO
    }

    public function testInitialized() {
        // TODO
    }


}

/**
 * Class ExtendedContainer
 *
 * @author        Maximilian Ruta <mr@xtain.net>
 * @copyright     Copyright (c) 2013, XTAIN oHG <https://company.xtain.net>
 * @package       io.xun.test.unit.core.dependencyinjection.TestContainer
 */
class ExtendedContainer extends Container {

    public function getBaaDaService() : String {
        return 'baa';
    }


}