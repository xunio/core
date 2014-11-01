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

import io.xun.core.exception.DefaultException;
import io.xun.core.exception.Exception;
import io.xun.async.Promise;
import sys.io.FileSeek;

class FileInput extends io.xun.async.io.Input implements IFileInput {

    private var fileInput : sys.io.FileInput;

    public function new(fileInput : sys.io.FileInput) {
        super(fileInput);
        this.fileInput = fileInput;
    }

    public function seek(p : Int, pos : FileSeek ) : Promise<Void> {
	    var r : Promise<Void> = new Promise<Void>();
        try {
            this.fileInput.seek(p, pos);
	        r.resolve();
        } catch (e : Dynamic) {
            r.reject(e);
        }
	    return r;
    }

    public function tell() : Promise<Int> {
        var r : Promise<Int> = new Promise<Int>();
        r.resolve(fileInput.tell());
        return r;
    }

    public function eof() : Promise<Bool> {
        var r : Promise<Bool> = new Promise<Bool>();
        r.resolve(fileInput.eof());
        return r;
    }
}
