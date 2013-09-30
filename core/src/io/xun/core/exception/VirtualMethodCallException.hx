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
 * @package       io.xun.core.exception
 * @license       http://www.gnu.org/licenses/agpl-3.0.html GNU Affero General Public License
 */

package io.xun.core.exception;

/**
 * Class VirtualMethodCallException
 *
 * @author        Maximilian Ruta <mr@xtain.net>
 * @copyright     Copyright (c) 2013 XTAIN oHG, <https://company.xtain.net>
 * @package       io.xun.core.exception
 */
class VirtualMethodCallException extends NotImplementedException {

    public function new(e : Null<String> = null) {
        if (e == null) {
            super('This method is a virutal method and must be implemented in extending classes. '
                + 'Direct calles to this method are not allowed. This method does not contain any implementation!');
        } else {
            super(e);
        }
    }

}
