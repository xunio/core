package de.xtain.firefly.net;

import haxe.Http;

class HttpWebResponse {

    private var _Http : Http;

    public function new(http : Http) {
        _Http = http;
    }

    private function assignDynamicMethods() {
        _Http.onData = onData;
        _Http.onError = onError;
        _Http.onStatus = onStatus;
    }

    private function onData(data : String) {
        Sys.println(data);
    }

    private function onError(msg : String) {
        Sys.println(msg);
    }

    private function onStatus(status : Int) {
        Sys.println(status);
    }

}
