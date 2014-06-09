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

package io.xun.test.unit.haxe.sys.io;

import sys.io.Process;

/**
 * Class TestProcess
 *
 * @author        Maximilian Ruta <mr@xtain.net>
 * @copyright     Copyright (c) 2013 XTAIN oHG, <https://company.xtain.net>
 * @package       io.xun.test.unit.haxe.sys.io
 */
class TestProcess extends haxe.unit.TestCase {

	public function new() {
		super();
	}

	public function testSpawn() {
		var args : Array<String> = new Array<String>();
		args.push('/proc/cpuinfo');
		var process = new sys.io.Process('/usr/bin/cat', args);
		var exitCode = process.exitCode();
		assertEquals(0, exitCode);
	}

	public function testReadWrite() {
		var args : Array<String> = new Array<String>();
		var process = new sys.io.Process('/usr/bin/cat', args);
		process.stdin.writeString('test');
		assertEquals('test', process.stdout.readString(4));
		process.stdin.writeString('äöüöäü');
		assertEquals('äöü', process.stdout.readString(6));
		process.close();
	}
}

