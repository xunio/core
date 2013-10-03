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
import io.xun.io.InputStream;
import io.xun.io.PipeInputStream;
import io.xun.core.event.IObservable;
import io.xun.core.event.IObserver;
using io.xun.io.ByteUtils;

/**
 * Class Base64Decoder
 *
 * @author        Maximilian Ruta <mr@xtain.net>
 * @copyright     Copyright (c) 2013 XTAIN oHG, <https://company.xtain.net>
 * @package       io.xun.crypt.algorithm.implementation
 */
class Base64Decoder extends PipeInputStream {

    public static inline var CHUNK_SIZE = 4 * 512;

    /**
     * Constructor
     *
     * @author Maximilian Ruta <mr@xtain.net>
     */
    public function new(input : InputStream) {
        super(new Base64DecoderCleaner(input), decode, CHUNK_SIZE);
    }

    public static function prepare(input : Bytes) : Bytes {
        var r : EReg = ~/[^A-Za-z0-9\+\/=]/g;
        return Bytes.ofString(r.replace(input.toString(), ""));
    }

    public static function after(input : Bytes) : Bytes {
        return input;
    }

    public static function decode(input : Bytes) : Bytes {
        var output : Bytes = Bytes.alloc(0);
        var chr1 : Int;
        var chr2 : Int;
        var chr3 : Int;
        var enc1 : Int;
        var enc2 : Int;
        var enc3 : Int;
        var enc4 : Int;
        var i : Int = 0;

        input = prepare(input);
        while (i < input.length) {
            if (i < input.length) {
                enc1 = Base64.chars.indexOf(String.fromCharCode(input.get(i)));
            } else {
                enc1 = 0;
            }
            i = i + 1;
            if (i < input.length) {
                enc2 = Base64.chars.indexOf(String.fromCharCode(input.get(i)));
            } else {
                enc2 = 0;
            }
            i = i + 1;
            if (i < input.length) {
                enc3 = Base64.chars.indexOf(String.fromCharCode(input.get(i)));
            } else {
                enc3 = 0;
            }
            i = i + 1;
            if (i < input.length) {
                enc4 = Base64.chars.indexOf(String.fromCharCode(input.get(i)));
            } else {
                enc4 = 0;
            }
            i = i + 1;
            chr1 = (enc1 << 2) | (enc2 >> 4);
            chr2 = ((enc2 & 15) << 4) | (enc3 >> 2);
            chr3 = ((enc3 & 3) << 6) | enc4;

            output = output.appendByte(chr1);
            if (enc3 != 64) {
                output = output.appendByte(chr2);
            }
            if (enc4 != 64) {
                output = output.appendByte(chr3);
            }
        }

        return output;
    }

}

/**
 * Class Base64DecoderCleaner
 *
 * @author        Maximilian Ruta <mr@xtain.net>
 * @copyright     Copyright (c) 2013 XTAIN oHG, <https://company.xtain.net>
 * @package       io.xun.crypt.algorithm.implementation.Base64Decoder
 */
class Base64DecoderCleaner extends PipeInputStream {

    public static inline var CHUNK_SIZE = Base64Decoder.CHUNK_SIZE;

    /**
     * Constructor
     *
     * @author Maximilian Ruta <mr@xtain.net>
     */
    public function new(input : InputStream) {
        super(input, Base64Decoder.prepare, CHUNK_SIZE);
    }

}
