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
 * @package       io.xun.core.util
 * @license       http://www.gnu.org/licenses/agpl-3.0.html GNU Affero General Public License
 */

package io.xun.core.util;

/**
 * Class BitwiseMask
 *
 * @author        Maximilian Ruta <mr@xtain.net>
 * @copyright     Copyright (c) 2013 XTAIN oHG, <https://company.xtain.net>
 * @package       io.xun.core.util
 */
class BitwiseMask {

    private var _mask : Int = 0;

    public function new(?flag : Int = 0) {
        reset();
        if(flag != null) {
            set(flag);
        }
    }

    public static function checkMask(flag : Int, mask : Int) {
        return ((mask | flag) == mask);
    }

    public function check(flag : Int) {
        return checkMask(flag, _mask);
    }

    public function get() : Int {
        return _mask;
    }

    public function set(flag : Int) {
        _mask = _mask | flag;
    }

    public function unset(flag : Int) {
        _mask = ~(flag | ~_mask);
    }

    public function reset() {
        _mask = 0;
    }

    public function isZero() {
        return _mask == 0;
    }

    public function toString() : String {
        var num : Int = _mask;
        var res : String = '';

        while (num > 0) {
            if((num & 1) == 1) {
                res = res + '1';
            } else {
                res = res + '0';
            }
            num = num >> 1;
        }
        return res == '' ? '0' : res;
    }

}
