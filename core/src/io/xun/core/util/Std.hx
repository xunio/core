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
 * @package       io.xun.core.util
 * @license       http://www.gnu.org/licenses/agpl-3.0.html GNU Affero General Public License
 */

package io.xun.core.util;

/**
 * Class Std
 *
 * @author        Maximilian Ruta <mr@xtain.net>
 * @copyright     Copyright (c) 2014 XTAIN oHG, <https://company.xtain.net>
 * @package       io.xun.core.util
 */
class Std {

    #if js
    /**
     * Is Undefined
     *
     * @author Maximilian Ruta <mr@xtain.net>
     */
    public static function isUndefined(d : Dynamic) : Bool {
        if (untyped __js__("typeof d") == 'undefined') {
            return true;
        } else {
            return false;
        }
    }
    #end

}
