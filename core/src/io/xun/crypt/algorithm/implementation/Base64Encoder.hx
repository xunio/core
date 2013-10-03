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
 * Class Base64Encoder
 *
 * @author        Maximilian Ruta <mr@xtain.net>
 * @copyright     Copyright (c) 2013 XTAIN oHG, <https://company.xtain.net>
 * @package       io.xun.crypt.algorithm.implementation
 */
class Base64Encoder extends PipeInputStream {

    public static inline var CHUNK_SIZE = 3 * 512;

    /**
     * Constructor
     *
     * @author Maximilian Ruta <mr@xtain.net>
     */
    public function new(input : InputStream) {
        //super(new Base64EncoderCleaner(input), encode, CHUNK_SIZE);
        super(input, encode, CHUNK_SIZE);
    }

    public static function prepare(input : Bytes) : Bytes {
        return input;
    }

    public static function encode(input : Bytes) : Bytes {
        var output : Bytes = Bytes.alloc(0);
        var chr1 : Int;
        var chr2 : Int;
        var chr3 : Int;
        var chr2t : Bool;
        var chr3t : Bool;
        var enc1 : Int;
        var enc2 : Int;
        var enc3 : Int;
        var enc4 : Int;
        var chunk : Bytes;
        var i : Int = 0;

        input = prepare(input);

        while (i < input.length) {
            chr2t = chr3t = true;
            if (i < input.length) {
                chr1 = input.get(i);
            } else {
                chr1 = 0;
            }
            i = i + 1;
            if (i < input.length) {
                chr2 = input.get(i);
            } else {
                chr2 = 0;
                chr2t = false;
            }
            i = i + 1;
            if (i < input.length) {
                chr3 = input.get(i);
            } else {
                chr3 = 0;
                chr3t = false;
            }
            i = i + 1;
            enc1 = chr1 >> 2;
            enc2 = ((chr1 & 3) << 4) | (chr2 >> 4);
            if (chr2t) {
                enc3 = ((chr2 & 15) << 2) | (chr3 >> 6);
                if (chr3t) {
                    enc4 = chr3 & 63;
                } else {
                    enc4 = 64;
                }
            } else {
                enc3 = enc4 = 64;
            }

            chunk = Bytes.alloc(4);
            chunk.set(0, Base64.chars.charCodeAt(enc1));
            chunk.set(1, Base64.chars.charCodeAt(enc2));
            chunk.set(2, Base64.chars.charCodeAt(enc3));
            chunk.set(3, Base64.chars.charCodeAt(enc4));

            output = output.append(chunk);
        }
        return output;
    }

}

/**
 * Class Base64EncoderCleaner
 *
 * @author        Maximilian Ruta <mr@xtain.net>
 * @copyright     Copyright (c) 2013 XTAIN oHG, <https://company.xtain.net>
 * @package       io.xun.crypt.algorithm.implementation.Base64Encoder
 */
class Base64EncoderCleaner extends PipeInputStream {

    public static inline var CHUNK_SIZE = Base64Encoder.CHUNK_SIZE;

    /**
     * Constructor
     *
     * @author Maximilian Ruta <mr@xtain.net>
     */
    public function new(input : InputStream) {
        super(input, Base64Encoder.prepare, CHUNK_SIZE);
    }

}
