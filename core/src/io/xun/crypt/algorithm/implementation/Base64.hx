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
 * @package       io.xun.crypt.algorithm.implementation
 * @license       http://www.gnu.org/licenses/agpl-3.0.html GNU Affero General Public License
 */

package io.xun.crypt.algorithm.implementation;

import haxe.io.Bytes;
import io.xun.io.ByteArrayInputStream;
import haxe.io.Bytes;
import io.xun.io.InputStream;
import haxe.Utf8;

/**
 * Class Base64
 *
 * @author        Maximilian Ruta <mr@xtain.net>
 * @copyright     Copyright (c) 2013 XTAIN oHG, <https://company.xtain.net>
 * @package       io.xun.crypt.algorithm.implementation
 */
class Base64 {

    public static var chars : String = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";

    public static function decode(input : Bytes) : Bytes {
        var decoder : Base64Decoder = new Base64Decoder(new ByteArrayInputStream(input));
        return decoder.toBytes();
    }

    public static function encode(input : Bytes) : Bytes {
        var encoder : Base64Encoder = new Base64Encoder(new ByteArrayInputStream(input));
        return encoder.toBytes();
    }

}
