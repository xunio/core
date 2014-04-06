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

import io.xun.async.sys.io.FileInput;
import io.xun.core.exception.DefaultException;
import io.xun.core.exception.Exception;
import io.xun.async.Promise;

class File {

    public static function getContent(path : String) : Promise<String> {
        var r : Promise<String> = new Promise<String>();
        r.resolve(sys.io.File.getContent(path));
        return r;
    }

    public static function saveContent(path : String, content : String, callback : Null<Exception> -> Void) : Void {
        try {
            sys.io.File.saveContent(path, content);
            callback(null);
        } catch (e : Dynamic) {
            callback(new DefaultException(e));
        }
    }

    public static function getBytes(path : String) : Promise<haxe.io.Bytes> {
        var r : Promise<haxe.io.Bytes> = new Promise<haxe.io.Bytes>();
        r.resolve(sys.io.File.getBytes(path));
        return r;
    }

    public static function saveBytes(path : String, bytes : haxe.io.Bytes, callback : Null<Exception> -> Void) : Void {
        try {
            sys.io.File.saveBytes(path, bytes);
            callback(null);
        } catch (e : Dynamic) {
            callback(new DefaultException(e));
        }
    }

    public static function read(path : String, binary : Bool) : Promise<IFileInput> {
        var r : Promise<IFileInput> = new Promise<IFileInput>();
        r.resolve(new FileInput(sys.io.File.read(path, binary)));
        return r;
    }

    public static function write(path : String, binary : Bool) : Promise<IFileOutput> {
        var r : Promise<IFileOutput> = new Promise<IFileOutput>();
        r.resolve(new FileOutput(sys.io.File.write(path, binary)));
        return r;
    }

    public static function append(path : String, binary : Bool) : Promise<IFileOutput> {
        var r : Promise<IFileOutput> = new Promise<IFileOutput>();
        r.resolve(new FileOutput(sys.io.File.append(path, binary)));
        return r;
    }

    public static function copy(srcPath : String, dstPath : String, callback : Null<Exception> -> Void) : Void {
        try {
            sys.io.File.copy(srcPath, dstPath);
            callback(null);
        } catch (e : Dynamic) {
            callback(new DefaultException(e));
        }
    }

}
