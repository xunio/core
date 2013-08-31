package io.xun.core.exception;
class Exception {

    private var message : String;


    public function new(message : String) {
        this.message = message;
    }

    public function toString() {
        return this.message;
    }

}
