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
 * @package       io.xun.test.unit.core.dependencyinjection.parameterbag
 * @license       http://www.gnu.org/licenses/agpl-3.0.html GNU Affero General Public License
 */

package io.xun.test.unit.core.dependencyinjection.parameterbag;

import io.xun.core.dependencyinjection.parameterbag.exception.InvalidArgumentException;
import io.xun.core.dependencyinjection.ref.Parameter;
import io.xun.core.dependencyinjection.parameterbag.ParameterBag;

/**
 * Class TestParameterBag
 *
 * @author        Maximilian Ruta <mr@xtain.net>
 * @copyright     Copyright (c) 2013 XTAIN oHG, <https://company.xtain.net>
 * @package       io.xun.test.unit.core.dependencyinjection.parameterbag
 */
class TestParameterBag extends haxe.unit.TestCase {

    public function testSet() {
        var p : ParameterBag = new ParameterBag();
        p.set(new Parameter('test', 'foo'));
        p.set(new Parameter('test2', 'foo2'));
        assertEquals('foo', p.get('test').value);
        assertEquals('foo2', p.get('test2').value);
    }

    public function testOverride() {
        var p : ParameterBag = new ParameterBag();

        p.set(new Parameter('test', 'foo'));
        try {
            p.add([new Parameter('test', 'foo2')]);
            assertTrue(false);
        } catch(e : InvalidArgumentException) {
            assertTrue(true);
        }

        p.set(new Parameter('test', 'foo2'));
        assertEquals('foo2', p.get('test').value);
    }

    public function testExists() {
        var p : ParameterBag = new ParameterBag();
        var param : Parameter = new Parameter('test', 'foo');

        assertFalse(p.exists('test'));
        assertFalse(p.parameterExists(param));
        p.set(param);
        assertTrue(p.parameterExists(param));
        assertTrue(p.exists('test'));
    }

    public function testGet() {
        var p : ParameterBag = new ParameterBag();
        var param : Parameter = new Parameter('test', 'foo');

        try {
            p.get('test');
            assertTrue(false);
        } catch(e : InvalidArgumentException) {
            assertTrue(true);
        }

        p.set(param);
        assertEquals('foo', p.get('test').value);
    }

    public function testAdd() {
        var p : ParameterBag = new ParameterBag();

        p.add([
            new Parameter('test', 'foo'),
            new Parameter('test2', 'foo2')
        ]);

        assertEquals('foo', p.get('test').value);
        assertEquals('foo2', p.get('test2').value);
    }

    public function testFreeze() {
        var p : ParameterBag = new ParameterBag();

        assertFalse(p.isFrozen());
    }

}
