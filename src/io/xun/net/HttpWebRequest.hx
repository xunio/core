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
 * @package       io.xun.net
 * @license       http://www.gnu.org/licenses/agpl-3.0.html GNU Affero General Public License
 */

package io.xun.net;

/* imports and uses */

import haxe.Http;

enum Method {
    GET;
    POST;
}

/**
 * Class HttpWebRequest
 *
 * @author        Maximilian Ruta <mr@xtain.net>
 * @copyright     Copyright (c) 2013 XTAIN oHG, <https://company.xtain.net>
 * @package       io.xun.net
 */
class HttpWebRequest {

    private var _Http : Http;
    private var _HttpWebResponse : Null<HttpWebResponse>;
    public var RequestUri(default, null) : String;
    public var Method(default, null) : Method;

    public function new(url : String, ?method : Method) {
        this.RequestUri = url;
        if (method == null) {
            this.Method = io.xun.net.Method.GET;
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
