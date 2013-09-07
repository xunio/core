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

/**
 * Class HttpWebResponse
 *
 * @author        Maximilian Ruta <mr@xtain.net>
 * @copyright     Copyright (c) 2013 XTAIN oHG, <https://company.xtain.net>
 * @package       io.xun.net
 */
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
