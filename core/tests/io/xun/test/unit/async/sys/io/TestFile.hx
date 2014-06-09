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
import io.xun.async.sys.io.IFileInput;
import io.xun.async.sys.io.File;

/**
 * Class TestFile
 *
 * @author        Maximilian Ruta <mr@xtain.net>
 * @copyright     Copyright (c) 2013 XTAIN oHG, <https://company.xtain.net>
 * @package       io.xun.test.unit.async.sys.io
 */
class TestFile extends haxe.unit.TestCase {

	public function testGetContent() {
		var p : Promise<String> = File.getContent('/tmp/test');
		p.then(function (value : String) {
			assertEquals('test123', value);
		});
		p.block();
	}

	public function testRead() {
		var p : Promise<IFileInput> = File.read('/tmp/test', false);
		p.then(function (file : IFileInput) {
			var pb : Promise<Int> = file.readByte();
			pb.then(function(value : Int) {
				trace(value);
			});
			pb.block();
		});
		p.block();
	}

}

