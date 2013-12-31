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
 * @package       io.xun.cp.lnx.core.util
 * @license       http://www.gnu.org/licenses/agpl-3.0.html GNU Affero General Public License
 */

package io.xun.cp.lnx.core.util;

import io.xun.core.util.clipboard.AbstractClipboard;
import io.xun.core.util.clipboard.ClipboardException;
import io.xun.core.util.clipboard.IClipboard;

/**
 * Class Clipboard
 *
 * @author        Maximilian Ruta <mr@xtain.net>
 * @copyright     Copyright (c) 2013 XTAIN oHG, <https://company.xtain.net>
 * @package       io.xun.cp.lnx.core.util
 */
class Clipboard extends AbstractClipboard implements IClipboard {

    private static var _getText : Void -> Null<String> = neko.Lib.load("ndll/clipboard", "getText", 0);
    private static var _setText : String -> Bool = neko.Lib.load("ndll/clipboard", "setText", 1);

    /**
     * Constructor
     *
     * @author Maximilian Ruta <mr@xtain.net>
     */
    public function new() {
    }

    public function isAvailable() : Bool {
        return true;
    }

    public function getText() : Null<String> {
        return _getText();
    }

    public function setText(value : String) : Void {
        if(!_setText(value)) {
            throw new ClipboardException();
        }
    }

}
