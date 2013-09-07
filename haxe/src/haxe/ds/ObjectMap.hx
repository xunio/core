/*
 * xun.io
 * Copyright (c) 2013, XTAIN oHG <https://company.xtain.net>
 *
 * Licensed under GNU Affero General Public License
 * For full copyright and license information, please see the LICENSE
 * Redistributions of files must retain the above copyright notice.
 *
 * @copyright     Copyright (c) 2013, XTAIN oHG <https://company.xtain.net>
 * @link          http://xun.io/ xun.io Project
 * @package       haxe.ds
 * @license       http://www.gnu.org/licenses/agpl-3.0.html GNU Affero General Public License
 */

package haxe.ds;

/**
 * Class ObjectMap
 *
 * @author        Maximilian Ruta <mr@xtain.net>
 * @copyright     Copyright (c) 2013 XTAIN oHG, <https://company.xtain.net>
 * @package       haxe.ds
 */
class ObjectMap<K, V> implements Map.IMap<K, V> {

    private var _keys : Array<K>;
    private var _values : Array<V>;

    public function new() : Void {
        _keys = new Array<K>();
        _values = new Array<V>();
    }

    private function _getKey( key : K ) : Null<Int> {
        var i : Int = 0;
        for (val in _keys.iterator()) {
            if (val == key) {
                return i;
            }
            i++;
        }
        return null;
    }

    public function set( key : K, value : V ) : Void {
        var ikey : Null<Int> = _getKey(key);
        if(ikey == null) {
            _keys.push(key);
            _values.push(value);
        } else {
            _keys[ikey] = key;
            _values[ikey] = value;
        }
    }

    public function get( key : K ) : Null<V> {
        var ikey : Null<Int> = _getKey(key);
        if(ikey == null) {
            return null;
        }
        return _values[ikey];
    }

    public function exists( key : K ) : Bool {
        return _getKey(key) == null ? false : true;
    }

    public function remove( key : K ) : Bool {
        var ikey : Null<Int> = _getKey(key);
        if(ikey != null) {
            var keys : Array<K> = new Array<K>();
            var values : Array<V> = new Array<V>();
            var i : Int = 0;
            for (value in _values.iterator()) {
                if(ikey != i) {
                    values.push(value);
                }
                i++;
            }
            i = 0;
            for (key in _keys.iterator()) {
                if(ikey != i) {
                    keys.push(key);
                }
                i++;
            }
            _keys = keys;
            _values = values;
            return true;
        } else {
            return false;
        }
    }

    public function keys() : Iterator<K> {
        return _keys.iterator();
    }

    public function iterator() : Iterator<V> {
        return _values.iterator();
    }

    public function toString() : String {
        return _keys.toString() + ' ' + _values.toString();
    }

}
