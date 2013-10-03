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

package io.xun.io;

import io.xun.core.exception.OutOfBoundsException;
import haxe.io.Bytes;
using Lambda;

/**
 * Class ByteUtils
 *
 * @author        Maximilian Ruta <mr@xtain.net>
 * @copyright     Copyright (c) 2013 XTAIN oHG, <https://company.xtain.net>
 * @package       io.xun.core.util
 */
class ByteUtils {

    public static function rtrim(source : Bytes, list : Null<Array<Int>> = null) : Bytes {
        if (list == null) {
            list = [0];
        }

        var result : Bytes;
        var length : Int = 0;

        for (i in 0...source.length) {
            if (!list.has(source.get(source.length - 1 - i))) {
                break;
            }
            length++;
        }

        var resultLength : Int = source.length - length;
        result = Bytes.alloc(resultLength);
        result.blit(0, source, 0, resultLength);
        return result;
    }

    public static function ltrim(source : Bytes, list : Null<Array<Int>> = null) : Bytes {
        if (list == null) {
            list = [0];
        }

        var result : Bytes;
        var length : Int = 0;

        for (i in 0...source.length) {
            if (!list.has(source.get(i))) {
                break;
            }
            length++;
        }

        var resultLength : Int = source.length - length;
        result = Bytes.alloc(resultLength);
        result.blit(0, source, length, resultLength);
        return result;
    }

    public static function trim(source : Bytes, list : Null<Array<Int>> = null) : Bytes {
        if (list == null) {
            list = [0];
        }

        return ByteUtils.rtrim(ByteUtils.ltrim(source, list), list);
    }

    public static function append(source : Bytes, b : Bytes) {
        if (source.length == 0) {
            return Bytes.ofData(b.getData());
        }

        var result : Bytes = Bytes.alloc(source.length + b.length);
        result.blit(0, source, 0, source.length);
        result.blit(source.length, b, 0, b.length);
        return result;
    }

    public static function prepend(source : Bytes, b : Bytes) {
        return ByteUtils.append(b, source);
    }

    public static function appendByte(source : Bytes, b : Int) {
        var t : Bytes = Bytes.alloc(1);
        t.set(0, b);
        return ByteUtils.append(source, t);
    }

    public static function prependByte(source : Bytes, b : Int) {
        var t : Bytes = Bytes.alloc(1);
        t.set(0, b);
        return ByteUtils.prepend(source, t);
    }

    public static function insert(source : Bytes, b : Bytes, pos : Int = 0) {
        var length : Int = source.length;
        if (pos > (source.length - 1)) {
            throw new OutOfBoundsException('position is grater than source length');
        }
        if ((pos + b.length) > source.length) {
            length = pos + b.length;
        }
        var result : Bytes = Bytes.alloc(length);
        result.blit(0, source, 0, source.length);
        result.blit(pos, b, 0, b.length);
        return result;
    }

}
