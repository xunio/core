package de.xtain.firefly.net;

import haxe.Http;

enum Method {
    GET;
    POST;
}

class HttpWebRequest {

    private var _Http : Http;
    private var _HttpWebResponse : Null<HttpWebResponse>;
    public var RequestUri(default, null) : String;
    public var Method(default, null) : Method;

    public function new(url : String, ?method : Method) {
        this.RequestUri = url;
        if (method == null) {
            this.Method = de.xtain.firefly.net.Method.GET;
        } else {
            this.Method = method;
        }
        this._Http = new Http(url);
    }

    public function getResponse() : HttpWebResponse {
        if (this._HttpWebResponse == null) {
            Sys.println("test");
            this._HttpWebResponse = new HttpWebResponse(this._Http);
            this._Http.request(this.Method == de.xtain.firefly.net.Method.POST);
        }

        return this._HttpWebResponse;
    }

}
