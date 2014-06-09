/*
 * Copyright (C)2005-2012 Haxe Foundation
 *
 * Permission is hereby granted, free of charge, to any person obtaining a
 * copy of this software and associated documentation files (the "Software"),
 * to deal in the Software without restriction, including without limitation
 * the rights to use, copy, modify, merge, publish, distribute, sublicense,
 * and/or sell copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
 * DEALINGS IN THE SOFTWARE.
 */
package js.nodejs.sys.net;

import js.nodejs.Node;

class Host {
	private var _ip : String;
	public var ip(default, null) : Int;

	public function new( name : String ) : Void
	{
		// TODO support IPv6 https://github.com/HaxeFoundation/haxe/issues/3122
		if(~/^(\d{1,3}\.){3}\d{1,3}$/.match(name)) {
			_ip = name;
		} else {
			ip = 0;
			var found : Bool = false;
			var fiber = js.nodejs.Node.NodeFiber.current;
			Node.dns.lookup(name, '4', function(err : NodeErr, address : String, family : Int) {
				if (err != null) {
					fiber.run();
					return;
				}
				found = true;
				_ip = address;
				fiber.run();
			});
			js.nodejs.Node.NodeFiber.yield();
			if(!found) {
				return;
			}
		}
		var rawIp = _ip.split('.');
		ip = Std.parseInt(rawIp[3]) | (Std.parseInt(rawIp[2]) << 8) | (Std.parseInt(rawIp[1]) << 16) | (Std.parseInt(rawIp[0]) << 24);
	}

	public function toString() : String
	{
		return _ip;
	}

	public function reverse() : String
	{
		var domain : String = null;
		var fiber = js.nodejs.Node.NodeFiber.current;
		var error : Null<Dynamic> = null;
		Node.dns.reverse(_ip, function(err : String, domains : Array<String>) {
			if (err != null) {
				error = err;
				fiber.run();
				return;
			}
			if (domains.length <= 0) {
				error = "Could not reverse domain";
				fiber.run();
				return;
			}
			domain = domains[0];
			fiber.run();
		});
		js.nodejs.Node.NodeFiber.yield();
		if (error != null) {
			throw error;
		}
		return domain;
	}

	public static function localhost() : String
	{
		return Node.os.hostname();
	}
}
