/*
 * xun.io
 * Copyright (c) 2014 XTAIN oHG, <https://company.xtain.net>
 *
 * Licensed under GNU Affero General Public License
 * For full copyright and license information, please see the LICENSE
 * Redistributions of files must retain the above copyright notice.
 *
 * @copyright     Copyright (c) 2014 XTAIN oHG, <https://company.xtain.net>
 * @link          http://xun.io/ xun.io Project
 * @package       io.xun.test.unit.core.util
 * @license       http://www.gnu.org/licenses/agpl-3.0.html GNU Affero General Public License
 */

package io.xun.test.unit.core.util;

import io.xun.core.util.Std;

/**
 * Class TestStd
 *
 * @author        Maximilian Ruta <mr@xtain.net>
 * @copyright     Copyright (c) 2014 XTAIN oHG, <https://company.xtain.net>
 * @package       io.xun.test.unit.core.util
 */
class TestStd extends haxe.unit.TestCase {

    #if js
    /**
     * Is Undefined
     *
     * @author Maximilian Ruta <mr@xtain.net>
     */
    public function testIsUndefined() {
        var testu : Dynamic;
        var test : Dynamic = 'test';
        untyped __js__("test = testu");
        assertTrue(Std.isUndefined(test));
        test = 'foo';
        assertFalse(Std.isUndefined(test));
    }
    #end

}
