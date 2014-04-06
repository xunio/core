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
import io.xun.core.exception.DefaultException;
import io.xun.core.exception.Exception;
import sys.io.FileSeek;

class FileOutput extends io.xun.async.io.Output implements IFileOutput {

    private var fileOutput : sys.io.FileOutput;

    public function new(fileOutput : sys.io.FileOutput) {
        super(fileOutput);
        this.fileOutput = fileOutput;
    }

    public function seek(p : Int, pos : FileSeek, callback : Null<Exception> -> Void) : Void {
        try {
            this.fileOutput.seek(p, pos);
            callback(null);
        } catch (e : Dynamic) {
            callback(new DefaultException(e));
        }
    }

    public function tell() : Promise<Int> {
        var r : Promise<Int> = new Promise<Int>();
        r.resolve(fileOutput.tell());
        return r;
    }

}
