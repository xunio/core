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

import haxe.ds.IntMap;
import haxe.ds.EnumValueMap;
import haxe.ds.ObjectMap;
import haxe.ds.StringMap;
import io.xun.core.exception.Exception;
import Map.IMap;
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

    public static function fromIterator<T>( iter : Iterator<T> ) : Array<T> {
        var arr : Array<T> = [];

        for ( elm in iter ) {
            arr.push(elm);
        }

        return arr;
    }

    public static function flatten<T>( source : Array<Array<T>> ) : Array<T> {
        var result : Array<T> = [];
        for (child in source.iterator()) {
            for (element in child.iterator()) {
                result.push(element);
            }
        }
        return result;
    }

    public static function diff<T>( source : Iterator<T>, flats : Iterable<T> ) : Array<T> {
        var results : Array<T> = new Array<T>();
        for ( element in source ) {
            if (!Lambda.has(flats, element)) {
                results.push(element);
            }
        }
        return results;
    }

    public static function append<K, V>( source : IMap<K, V>, append : IMap<K, V> ) {
        for ( key in append.keys() ) {
            if (!source.exists(key)) {
                source.set(key, append.get(key));
            }
        }
    }

    public static function toMap(object : {}) : Map<String, Dynamic> {
        var fields : Array<String> = Reflect.fields(object);
        var map : Map<String, Dynamic> = new Map<String, Dynamic>();
        for (name in fields) {
            map.set(name, Reflect.field(object, name));
        }
        return map;
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
