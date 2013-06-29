package io.xun.core.util;

class BitwiseFlag {

    private var _mask : Int = 0;

    public function new() {
        reset();
    }

    public static function checkMask(flag : Int, mask : Int) {
        return ((mask | flag) == mask);
    }

    public function check(flag : Int) {
        return checkMask(flag, _mask);
    }

    public function get() : Int {
        return _mask;
    }

    public function set(flag : Int) {
        _mask = _mask | flag;
    }

    public function unset(flag : Int) {
        _mask = ~(flag | ~_mask);
    }

    public function reset() {
        _mask = 0;
    }

    public function isZero() {
        return _mask == 0;
    }

}
