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
 * @package       io.xun.sys
 * @license       http://www.gnu.org/licenses/agpl-3.0.html GNU Affero General Public License
 */

package io.xun.sys;

import io.xun.core.exception.NotImplementedOnThisPlatformException;

/**
 * Class System
 *
 * @author        Maximilian Ruta <mr@xtain.net>
 * @copyright     Copyright (c) 2013 XTAIN oHG, <https://company.xtain.net>
 * @package       io.xun.sys
 */
class System {

    public static var DIRECTORY_SEPARATOR : Null<String>;
    public static var PATH_SEPARATOR : Null<String>;
    public static var TEMP_DIECTORY : Null<String>;
    public static var OS : Null<OS>;
    public static var OS_FAMILY : Null<OSFamily>;

	public static function getTempDirectory() : String {
        #if php
        return untyped __php__('sys_get_temp_dir()');
        #elseif (js && nodejs)
        return untyped __js__("require('os').tmpdir()");
        #elseif cs
        return untyped __cs__("global::System.IO.Path.GetTempPath()");
        #elseif java
        return untyped __java__('java.lang.System.getProperty("java.io.tmpdir")');
        //return untyped __java__("java.nio.file.Files.createTempDirectory(null).toString()");
        #end
        throw new NotImplementedOnThisPlatformException();
    }

    public static function getPathSeperator() : String {
        #if php
        return untyped __php__('PATH_SEPARATOR');
        #elseif (js && nodejs)
        return untyped __js__("require('path').delimiter");
        #elseif cs
        return untyped __cs__("new string(global::System.IO.Path.PathSeparator, 1)");
        #elseif java
        return untyped __java__("java.io.File.pathSeparator");
        #end
        throw new NotImplementedOnThisPlatformException();
    }

    public static function getDirectorySeperator() : String {
        #if php
        return untyped __php__('DIRECTORY_SEPARATOR');
        #elseif (js && nodejs)
        return untyped __js__("require('path').sep");
        #elseif cs
        return untyped __cs__("new string(global::System.IO.Path.DirectorySeparatorChar, 1)");
        #elseif java
        return untyped __java__("java.io.File.separator");
		#elseif neko
		var path : String = sys.FileSystem.fullPath('.');
		var pathParent : String = sys.FileSystem.fullPath('..');
        return path.substr(pathParent.length, 1);
        #end
        throw new NotImplementedOnThisPlatformException();
    }

    public static function __init__() {
	    System.DIRECTORY_SEPARATOR = null;
	    System.PATH_SEPARATOR = null;
	    System.TEMP_DIECTORY = null;
	    System.OS = null;
	    System.OS_FAMILY = null;

        try {
            System.DIRECTORY_SEPARATOR = getDirectorySeperator();
        } catch (e : NotImplementedOnThisPlatformException) {}
        try {
            System.PATH_SEPARATOR = getPathSeperator();
        } catch (e : NotImplementedOnThisPlatformException) {}
        try {
            System.TEMP_DIECTORY = getTempDirectory();
        } catch (e : NotImplementedOnThisPlatformException) {}
    }

}

