package io.xun.core.util;

class BitwiseMask {

    private var _mask : Int = 0;

    public function new(?flag : Int = 0) {
        reset();
        if(flag != null) {
            set(flag);
        }
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

    public function toString() : String {
        var num : Int = _mask;
        var res : String = '';

        while (num > 0) {
            if((num & 1) == 1) {
                res = res + '1';
            } else {
                res = res + '0';
            }
            num = num >> 1;
        }
        return res == '' ? '0' : res;
    }

}
