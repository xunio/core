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
 * @package       io.xun.io
 * @license       http://www.gnu.org/licenses/agpl-3.0.html GNU Affero General Public License
 */

package io.xun.io;

import haxe.io.Bytes;
import io.xun.core.exception.VirtualMethodCallException;

/**
 * Class InputStream
 *
 * @author        Maximilian Ruta <mr@xtain.net>
 * @copyright     Copyright (c) 2013 XTAIN oHG, <https://company.xtain.net>
 * @package       io.xun.io
 */
class InputStream implements ICloseable {

    public function read(bytes : Bytes) : Int {
        return this.readOffset(bytes, 0, 1);
    }

    public function readOffset(bytes : Bytes, offset : Int = 0, length : Null<Int> = null) : Int {
        throw new VirtualMethodCallException();
        return 0;
    }

    public function available() : Int {
        throw new VirtualMethodCallException();
        return 0;
    }

    public function close() : Void {
        throw new VirtualMethodCallException();
    }

    public function mark(readLimit : Int) : Void {
        throw new VirtualMethodCallException();
    }

    public function markSupported() : Bool {
        throw new VirtualMethodCallException();
        return true;
    }

    public function reset() : Void {
        throw new VirtualMethodCallException();
    }

    public function skip(n : Int) : Int {
        throw new VirtualMethodCallException();
        return 0;
    }

}
