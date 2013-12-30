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

import io.xun.core.util.Clipboard;

/**
 * Class TestClipboard
 *
 * @author        Maximilian Ruta <mr@xtain.net>
 * @copyright     Copyright (c) 2013 XTAIN oHG, <https://company.xtain.net>
 * @package       io.xun.test.unit.core.util
 */
class TestClipboard extends haxe.unit.TestCase {

    public function testIsAvailable() {
        var cl : Clipboard = new Clipboard();
        assertTrue(cl.isAvailable());
    }

    public function testReadWrite() {
        var cl : Clipboard = new Clipboard();

        var compare : String = "Lorem ipsum dolor sig!!";
        cl.setText(compare);
        assertEquals(compare, cl.getText());

        compare = String.fromCharCode(372);
        cl.setText(compare);
        assertEquals(compare, cl.getText());

        compare = "The quick brown fox jumps over the lazy dog";
        cl.setText(compare);
        assertEquals(compare, cl.getText());

        compare = "Zwölf Boxkämpfer jagen Eva quer über den großen Sylter Deich.";
        cl.setText(compare);
        assertEquals(compare, cl.getText());

    }

}
