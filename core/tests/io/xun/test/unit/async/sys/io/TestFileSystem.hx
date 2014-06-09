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
 * @package       io.xun.test.unit.async.sys.io
 * @license       http://www.gnu.org/licenses/agpl-3.0.html GNU Affero General Public License
 */

package io.xun.test.unit.async.sys.io;

import io.xun.async.Promise;
import io.xun.async.sys.FileSystem;
import sys.FileStat;

/**
 * Class TestFileSystem
 *
 * @author        Maximilian Ruta <mr@xtain.net>
 * @copyright     Copyright (c) 2013 XTAIN oHG, <https://company.xtain.net>
 * @package       io.xun.test.unit.async.sys.io
 */
class TestFileSystem extends haxe.unit.TestCase {

    public function testReadDirectory() {
        var s : FileStat = sys.FileSystem.stat('/');
        var p : Promise<FileStat> = FileSystem.stat('/');
        p.then(function (v : FileStat) {
            assertEquals(s.gid, v.gid);
            assertEquals(s.uid, v.uid);
            assertEquals(s.atime.getTime(), v.atime.getTime());
            assertEquals(s.mtime.getTime(), v.mtime.getTime());
            assertEquals(s.ctime.getTime(), v.ctime.getTime());
            assertEquals(s.size, v.size);
            assertEquals(s.dev, v.dev);
            assertEquals(s.ino, v.ino);
            assertEquals(s.nlink, v.nlink);
            assertEquals(s.rdev, v.rdev);
            assertEquals(s.mode, v.mode);
        });
        p.block();
    }

}

