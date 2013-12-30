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
 * @package       io.xun.test.unit.core.util
 * @license       http://www.gnu.org/licenses/agpl-3.0.html GNU Affero General Public License
 */

package io.xun.test.unit.core.util;

/* imports and uses */

import io.xun.core.util.StringUtils;

/**
 * Class TestStringUtils
 *
 * @author        Maximilian Ruta <mr@xtain.net>
 * @copyright     Copyright (c) 2013 XTAIN oHG, <https://company.xtain.net>
 * @package       io.xun.test.unit.core.util
 */
class TestStringUtils extends haxe.unit.TestCase {

    public function testUpperCaseWords() {
        assertEquals('Test Test Ddasd Adsad', StringUtils.upperCaseWords('test test ddasd adsad'));
        assertEquals(' Test Test Ddasd Adsad ', StringUtils.upperCaseWords(' test test ddasd adsad '));
        assertEquals(' Test 5test 7ddasd Adsad ', StringUtils.upperCaseWords(' test 5test 7ddasd adsad '));
        assertEquals('Test 5test', StringUtils.upperCaseWords('test 5test'));
        assertEquals('Test 5test', StringUtils.upperCaseWords('Test 5test'));
        assertEquals('5test', StringUtils.upperCaseWords('5test'));
    }

    public function testEscapeShellArgument() {
        assertEquals("'kevin\\'s birthday'", StringUtils.escapeShellArgument("kevin's birthday"));
    }

}
