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
 * @package       io.xun.async.sys
 * @license       http://www.gnu.org/licenses/agpl-3.0.html GNU Affero General Public License
 */

package io.xun.async.sys;

import io.xun.async.Promise;
import io.xun.sys.System;
import io.xun.async.Promise;
import io.xun.core.exception.DefaultException;
import io.xun.core.exception.Exception;
import sys.FileStat;

/**
 * Class FileSystem
 *
 * @author        Maximilian Ruta <mr@xtain.net>
 * @copyright     Copyright (c) 2013 XTAIN oHG, <https://company.xtain.net>
 * @package       io.xun.async.sys
 */
class FileSystem {

    public static var DIRECTORY_SEPARATOR : Null<String> = System.DIRECTORY_SEPARATOR;
    public static var PATH_SEPARATOR : Null<String> = System.PATH_SEPARATOR;
    public static var TEMP_DIECTORY : Null<String> = System.TEMP_DIECTORY;

    public static function exists( path : String ) : Promise<Bool> {
        var r : Promise<Bool> = new Promise<Bool>();
        try {
            r.resolve(sys.FileSystem.exists(path));
        } catch (e : Dynamic) {
            r.reject(e);
        }
        return r;
    }

    public static function rename( path : String, newPath : String ) : Promise<Void> {
        var r : Promise<Void> = new Promise<Void>();
        try {
            sys.FileSystem.rename(path, newPath);
            r.resolve(null);
        } catch (e : Dynamic) {
            r.reject(e);
        }
        return r;
    }

    public static function stat( path : String ) : Promise<FileStat> {
        var r : Promise<FileStat> = new Promise<FileStat>();
        try {
            r.resolve(sys.FileSystem.stat(path));
        } catch (e : Dynamic) {
            r.reject(e);
        }
        return r;
    }

    public static function fullPath( relPath : String ) : Promise<String> {
        var r : Promise<String> = new Promise<String>();
        try {
            r.resolve(sys.FileSystem.fullPath(relPath));
        } catch (e : Dynamic) {
            r.reject(e);
        }
        return r;
    }

    public static function isDirectory( path : String ) : Promise<Bool> {
        var r : Promise<Bool> = new Promise<Bool>();
        try {
            r.resolve(sys.FileSystem.isDirectory(path));
        } catch (e : Dynamic) {
            r.reject(e);
        }
        return r;
    }

    public static function createDirectory( path : String ) : Promise<Void> {
        var r : Promise<Void> = new Promise<Void>();
        try {
            sys.FileSystem.createDirectory(path);
            r.resolve(null);
        } catch (e : Dynamic) {
            r.reject(e);
        }
        return r;
    }

    public static function deleteFile( path : String ) : Promise<Void> {
        var r : Promise<Void> = new Promise<Void>();
        try {
            sys.FileSystem.deleteFile(path);
            r.resolve(null);
        } catch (e : Dynamic) {
            r.reject(e);
        }
        return r;
    }

    public static function deleteDirectory( path : String ) : Promise<Void> {
        var r : Promise<Void> = new Promise<Void>();
        try {
            sys.FileSystem.deleteDirectory(path);
            r.resolve(null);
        } catch (e : Dynamic) {
            r.reject(e);
        }
        return r;
    }

    public static function readDirectory( path : String ) : Promise<Array<String>> {
        var r : Promise<Array<String>> = new Promise<Array<String>>();
        try {
            r.resolve(sys.FileSystem.readDirectory(path));
        } catch (e : Dynamic) {
            r.reject(e);
        }
        return r;
    }
}

