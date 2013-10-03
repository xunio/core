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

import haxe.io.Bytes;
import io.xun.core.exception.OutOfBoundsException;
import Lambda;

/**
 * Class L
 *
 * @author        Maximilian Ruta <mr@xtain.net>
 * @copyright     Copyright (c) 2013 XTAIN oHG, <https://company.xtain.net>
 * @package       io.xun.core.util
 */
class L extends Lambda {

    public static function fromIterator<T>( iter : Iterator<T> ) : Iterable<T> {
        var arr : Array<T> = [];

        for ( elm in iter ) {
            arr.push(elm);
        }

        return arr;
    }

}

/**
 * Class ArrayExtension
 *
 * @author        Maximilian Ruta <mr@xtain.net>
 * @copyright     Copyright (c) 2013 XTAIN oHG, <https://company.xtain.net>
 * @package       io.xun.core.util.L
 */
class ArrayExtension {

    public static function unique<T>( x : Iterable<T> ) : Array<T> {
        var r : Array<T> = [];
        for (e in x.iterator()) {
            // you can inline exists yourself if you care much about speed.
            // But then you should consider using hash tables or such.
            if (!Lambda.has(r, e)) {
                r.push(e);
            }
        }
        return r;
    }

    public static function copyTo<T>(source : Array<T>, target : Array<T>, length : Int, srcPos : Int = 0, targetPos : Int = 0) : Void {
        if (source.length < length) {
            throw new OutOfBoundsException('source fewer items that sould be copied');
        }
        if (target.length < targetPos) {
            throw new OutOfBoundsException('targetPos is higher than gratest index of target');
            //targetPos = target.length;
        }

        for( i in 0...length ) {
            target[i + targetPos] = source[i + srcPos];
        }
    }

}
