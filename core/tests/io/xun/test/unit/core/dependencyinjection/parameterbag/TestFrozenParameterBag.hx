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

import io.xun.core.dependencyinjection.parameterbag.exception.FrozenParameterBagException;
import io.xun.core.dependencyinjection.ref.Parameter;
import io.xun.core.dependencyinjection.parameterbag.ParameterBag;
import io.xun.core.dependencyinjection.parameterbag.FrozenParameterBag;

/**
 * Class FrozenParameterBag
 *
 * @author        Maximilian Ruta <mr@xtain.net>
 * @copyright     Copyright (c) 2013 XTAIN oHG, <https://company.xtain.net>
 * @package       io.xun.test.unit.core.dependencyinjection.parameterbag
 */
class TestFrozenParameterBag extends haxe.unit.TestCase {

    public function testFreeze() {
        var p : ParameterBag = new ParameterBag();

        p.set(new Parameter('test', 'foo'));
        p.set(new Parameter('test2', 'foo2'));

        var pf : FrozenParameterBag = new FrozenParameterBag(p);

        assertEquals('foo', pf.get('test').value);
        assertEquals('foo2', pf.get('test2').value);

        try {
            pf.add([new Parameter('test3', 'foo'), new Parameter('test4', 'foo')]);
            assertTrue(false);
        } catch(e : FrozenParameterBagException) {
            assertTrue(true);
        }

        try {
            pf.set(new Parameter('test2', 'foo'));
            assertTrue(false);
        } catch(e : FrozenParameterBagException) {
            assertTrue(true);
        }

        try {
            pf.remove('test2');
            assertTrue(false);
        } catch(e : FrozenParameterBagException) {
            assertTrue(true);
        }

        try {
            pf.clear();
            assertTrue(false);
        } catch(e : FrozenParameterBagException) {
            assertTrue(true);
        }

        assertTrue(pf.isFrozen());
    }

}
