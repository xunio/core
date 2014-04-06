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
 * @package       io.xun.async.sys.io
 * @license       http://www.gnu.org/licenses/agpl-3.0.html GNU Affero General Public License
 */

package io.xun.async.sys.io;

import io.xun.async.Promise;
import io.xun.core.exception.Exception;
import sys.io.FileSeek;

interface IFileOutput extends io.xun.async.io.IOutput {

    public function seek( p : Int, pos : FileSeek, callback : Null<Exception> -> Void ) : Void;
    public function tell() : Promise<Int>;

}
