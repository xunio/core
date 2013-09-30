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
 * @package       io.xun.io
 * @license       http://www.gnu.org/licenses/agpl-3.0.html GNU Affero General Public License
 */

package io.xun.io;

/**
 * Interface ICloseable
 *
 * @author        Maximilian Ruta <mr@xtain.net>
 * @copyright     Copyright (c) 2013 XTAIN oHG, <https://company.xtain.net>
 * @package       io.xun.io
 */
interface ICloseable extends IAutoCloseable {

    /*
     * Closes this stream and releases any system resources associated with it. If the stream is already closed then
     * invoking this method has no effect.
     *
     * @author Maximilian Ruta <mr@xtain.net>
     * @throws io.xun.io.IOException If an I/O error occurs
     */
    public function close() : Void;

}