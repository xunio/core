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
 * @package       io.xun.async
 * @license       http://www.gnu.org/licenses/agpl-3.0.html GNU Affero General Public License
 */

package io.xun.async;

import promhx.base.EventLoop;

/**
 * Class Promise
 *
 * @author        Maximilian Ruta <mr@xtain.net>
 * @copyright     Copyright (c) 2013 XTAIN oHG, <https://company.xtain.net>
 * @package       io.xun.async
 */
class Promise<T> extends promhx.Promise<T> {

    public static function until<T>(p : Promise<T>) : Promise<T> {
        while (p.isPending()) {
            EventLoop.finish();
            if (p.isPending()) {
                try {
                    #if !flash
                    Sys.sleep(0.1);
	                #end
                } catch(e : Dynamic) {}
            }

        }

        return p;
    }

    public function block() : Void {
        until(this);
    }

}


