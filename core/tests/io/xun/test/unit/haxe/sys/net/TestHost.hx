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

package io.xun.test.unit.haxe.sys.net;

import sys.net.Host;

/**
 * Class TestHost
 *
 * @author        Maximilian Ruta <mr@xtain.net>
 * @copyright     Copyright (c) 2013 XTAIN oHG, <https://company.xtain.net>
 * @package       io.xun.test.unit.haxe.sys.io
 */
class TestHost extends haxe.unit.TestCase {

	private static inline var TEST_HOSTNAME = 'haxe.org';

	public function new() {
		super();
	}

	private function getHostnameBySysTools() : String {
		var args : Array<String> = new Array<String>();
		var process = new sys.io.Process('/usr/bin/hostname', args);
		var out : String = process.stdout.readAll().toString();
		return out.substr(0, out.length - 1);
	}

	private function getIpBySysTools(host : String) : String {
		var args : Array<String> = new Array<String>();
		args.push('-tA');
		args.push(host);
		var process = new sys.io.Process('/usr/bin/host', args);
		var out : String = process.stdout.readAll().toString();
		var reg : EReg = ~/[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+/;
		reg.match(out);
		return reg.matched(0);
	}

	public function testLocalhost() {
		assertEquals(getHostnameBySysTools(), Host.localhost());
	}

	public function testResolve() {
		var host1 : Host = new Host(getIpBySysTools(TEST_HOSTNAME));
		var host2 : Host = new Host(TEST_HOSTNAME);
		assertEquals(host1.ip, host2.ip);
	}

	public function testReverse() {
		var host1 : Host = new Host(TEST_HOSTNAME);
		var host2 : Host = new Host(getIpBySysTools(TEST_HOSTNAME));
		assertEquals(TEST_HOSTNAME, host1.reverse());
		assertEquals(host1.reverse(), host2.reverse());
	}

	public function testReverseNotExistent() {
		try {
			var host : Host = new Host('notexistent.example.org');
			assertTrue(false);
		} catch(e : Dynamic) {
			assertTrue(true);
		}
	}
}

