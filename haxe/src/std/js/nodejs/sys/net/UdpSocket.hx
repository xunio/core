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
package sys.net;
import haxe.io.Bytes;
import js.nodejs.Node;

class UdpSocket extends Socket {

	private var __s : NodeDGSocket;
	private var blocking : Bool = false;
	private var conected : Bool = false;
	private var connectedAddress : Address;
	public var input(default,null) : haxe.io.Input;
	public var output(default,null) : haxe.io.Output;
	public var custom : Dynamic;

	public function new() : Void {
		__s = Node.dgram.createSocket('udp4');
		super();
	}

	public function close() : Void {
		__s.close();
		input.close();
		output.close();
	}

	public function read() : String {
		var b : Bytes = Bytes.alloc(1);
		readFrom(b, 0, 1, connectedAddress);
		return b.toString();
	}

	public function write( content : String ) : Void {
		var b : Bytes = Bytes.ofString(content);
		sendTo(b, 0, b.length, connectedAddress);
	}

	public function connect(host : Host, port : Int) : Void {
		conected = true;
		connectedAddress = new Address();
		connectedAddress.host = host.ip;
		connectedAddress.port = port;
	}

	public function listen(connections : Int) : Void {
		// nothing?
	}

	public function shutdown( read : Bool, write : Bool ) : Void {
		close();
	}

	public function bind(host : Host, port : Int) : Void {
		var fiber = js.nodejs.Node.NodeFiber.current;
		__s.bind(port, host.toString(), function() : Void {
			fiber.run();
		});
		js.nodejs.Node.NodeFiber.yield();
	}

	public function accept() : Socket {
		throw "Not implemented";
	}

	public function peer() : { host : Host, port : Int } {
		throw "Not implemented";
	}

	public function host() : { host : Host, port : Int } {
		var addr = __s.address();
		return { host : new Host(addr.address), port : addr.port };
	}

	public function setTimeout( timeout : Float ) : Void {
		// TODO
	}

	public function waitForRead() : Void {
		select([this],null,null,null);
	}

	public function setBlocking( b : Bool ) : Void {
		blocking = b;
	}

	public function setFastSend( b : Bool ) : Void {
		throw "Not implemented";
	}

	public static function select(read : Array<Socket>, write : Array<Socket>, others : Array<Socket>, ?timeout : Float) : {read: Array<Socket>,write: Array<Socket>,others: Array<Socket>} {
		throw "Not implemented";
	}

	public function sendTo( buf : haxe.io.Bytes, pos : Int, len : Int, addr : Address ) : Int {
		if (blocking) {
			var fiber = js.nodejs.Node.NodeFiber.current;
			__s.send(new NodeBuffer(buf.getData()), pos, len, addr.port, addr.getHost().toString(), function() {
				fiber.run();
			})
			js.nodejs.Node.NodeFiber.yield();
		} else {
			__s.send(new NodeBuffer(buf.getData()), pos, len, addr.port, addr.host)
		}
	}

	public function readFrom( buf : haxe.io.Bytes, pos : Int, len : Int, addr : Address ) : Int {
		throw "Not implemented";
	}
}
