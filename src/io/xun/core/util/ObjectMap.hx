package io.xun.core.util;

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
