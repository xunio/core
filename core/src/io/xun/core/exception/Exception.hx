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
 * @package       io.xun.core.exception
 * @license       http://www.gnu.org/licenses/agpl-3.0.html GNU Affero General Public License
 */

package io.xun.core.exception;

/**
 * Class Exception
 *
 * @author        Maximilian Ruta <mr@xtain.net>
 * @copyright     Copyright (c) 2013 XTAIN oHG, <https://company.xtain.net>
 * @package       io.xun.core.exception
 */
class Exception {

    public var message(default, null) : String = '';
    public var code(default, null) : Int = 0;
    public var previous(default, null) : Null<Exception> = null;

    public function new(message : String = '', code : Int = 0, previous : Null<Exception> = null) {
        this.message = message;
        this.code = code;
        this.previous = previous;
    }

    public function toString() {
        return Type.getClassName(Type.getClass(this)) + ': ' + this.message;
    }

}
