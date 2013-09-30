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
 * @package       io.xun.crypt.algorithm
 * @license       http://www.gnu.org/licenses/agpl-3.0.html GNU Affero General Public License
 */

package io.xun.crypt.algorithm;

/**
 * Class Base64
 *
 * @author        Maximilian Ruta <mr@xtain.net>
 * @copyright     Copyright (c) 2013 XTAIN oHG, <https://company.xtain.net>
 * @package       io.xun.crypt.algorithm
 */
class Base64 {

    /**
     * Encoder
     *
     * @author Maximilian Ruta <mr@xtain.net>
     */
    public static function encode(data : String) : String {
        data = io.xun.crypt.algorithm.implementation.Base64.prepareEncode(data);
        return io.xun.crypt.algorithm.implementation.Base64.afterEncode(untyped __php__("base64_encode($data)"));
    }

    /**
     * Decoder
     *
     * @author Maximilian Ruta <mr@xtain.net>
     */
    public static function decode(data : String) : String {
        data = io.xun.crypt.algorithm.implementation.Base64.prepareDecode(data);
        return io.xun.crypt.algorithm.implementation.Base64.afterDecode(untyped __php__("base64_decode($data)"));
    }
}
