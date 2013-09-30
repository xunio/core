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

    private static var chars : String = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";

    public static function prepareEncode(input : InputStream) : InputStream {
        return input;
        //return Utf8.encode(input);
    }

    public static function encode(input : InputStream) : InputStream {
        var output : String = "";
        var chr1 : Null<Int>;
        var chr2 : Null<Int>;
        var chr3 : Null<Int>;
        var chr2t : Null<Int>;
        var chr3t : Null<Int>;
        var enc1 : Null<Int>;
        var enc2 : Null<Int>;
        var enc3 : Null<Int>;
        var enc4 : Null<Int>;
        var i : Int = 0;

        input = prepareEncode(input);

        while (i < input.length) {
            chr1 = input.charCodeAt(i++);
            chr2t = chr2 = input.charCodeAt(i++);
            chr3t = chr3 = input.charCodeAt(i++);
            if (chr1 == null) {
                chr1 = 0;
            }
            if (chr2 == null) {
                chr2 = 0;
            }
            if (chr3 == null) {
                chr3 = 0;
            }
            enc1 = chr1 >> 2;
            enc2 = ((chr1 & 3) << 4) | (chr2 >> 4);
            if (chr2t != null) {
                enc3 = ((chr2 & 15) << 2) | (chr3 >> 6);
                if (chr3t != null) {
                    enc4 = chr3 & 63;
                } else {
                    enc4 = 64;
                }
            } else {
                enc3 = enc4 = 64;
            }
            output = output + chars.charAt(enc1) + chars.charAt(enc2) + chars.charAt(enc3) + chars.charAt(enc4);
        }
        return output;
    }

    public static function afterEncode(input : InputStream) : InputStream {
        //var r : EReg = ~/[^A-Za-z0-9\+\/\=]/g;
        //return r.replace(input, "");
        return input;
    }

    public static function prepareDecode(input : InputStream) : InputStream {
        var r : EReg = ~/[^A-Za-z0-9\+\/=]/g;
        input = r.replace(input, "");
        trace(input);
        return input;
    }

    public static function decode(input : InputStream) : InputStream {
        var output : String = "";
        var chr1 : Null<Int>;
        var chr2 : Null<Int>;
        var chr3 : Null<Int>;
        var enc1 : Null<Int>;
        var enc2 : Null<Int>;
        var enc3 : Null<Int>;
        var enc4 : Null<Int>;
        var i : Int = 0;

        input = prepareDecode(input);

        while (i < input.length) {
            enc1 = chars.indexOf(input.charAt(i++));
            enc2 = chars.indexOf(input.charAt(i++));
            enc3 = chars.indexOf(input.charAt(i++));
            enc4 = chars.indexOf(input.charAt(i++));
            chr1 = (enc1 << 2) | (enc2 >> 4);
            chr2 = ((enc2 & 15) << 4) | (enc3 >> 2);
            chr3 = ((enc3 & 3) << 6) | enc4;
            output = output + String.fromCharCode(chr1);
            if (enc3 != 64) {
                output = output + String.fromCharCode(chr2);
            }
            if (enc4 != 64) {
                output = output + String.fromCharCode(chr3);
            }
        }

        return output;
    }

    public static function afterDecode(input : InputStream) : InputStream {
        return input;
        //return Utf8.decode(input);
    }

}
