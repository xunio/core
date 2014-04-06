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
 * @package       io.xun.test.unit.sys
 * @license       http://www.gnu.org/licenses/agpl-3.0.html GNU Affero General Public License
 */

package io.xun.test.unit.sys;

import io.xun.sys.System;

/**
 * Class System
 *
 * @author        Maximilian Ruta <mr@xtain.net>
 * @copyright     Copyright (c) 2013 XTAIN oHG, <https://company.xtain.net>
 * @package       io.xun.test.unit.sys
 */
class TestSystem extends haxe.unit.TestCase {

    public function testDirectorySeparator() {
        assertTrue(System.DIRECTORY_SEPARATOR == '/' || System.DIRECTORY_SEPARATOR == '\\');
    }

    public function testPathSeparator() {
        assertTrue(System.PATH_SEPARATOR == ';' || System.PATH_SEPARATOR == ':');
    }

    public function testTempDirecotry() {
        assertTrue(System.TEMP_DIECTORY.length > 0);
    }

}

