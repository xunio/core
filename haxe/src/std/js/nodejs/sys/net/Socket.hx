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

class Socket {

	public function new() : Void {
		throw "Not implemented";
	}

	public function close() : Void {
		throw "Not implemented";
	}

	public function read() : String {
		throw "Not implemented";
	}

	public function write( content : String ) : Void {
		throw "Not implemented";
	}

	public function connect(host : Host, port : Int) : Void {
		throw "Not implemented";
	}

	public function listen(connections : Int) : Void {
		throw "Not implemented";
	}

	public function shutdown( read : Bool, write : Bool ) : Void {
		throw "Not implemented";
	}

	public function bind(host : Host, port : Int) : Void {
		throw "Not implemented";
	}

	public function accept() : Socket {
		throw "Not implemented";
	}

	public function peer() : { host : Host, port : Int } {
		throw "Not implemented";
	}

	public function host() : { host : Host, port : Int } {
		throw "Not implemented";
	}

	public function setTimeout( timeout : Float ) : Void {
		throw "Not implemented";
	}

	public function waitForRead() : Void {
		throw "Not implemented";
	}

	public function setBlocking( b : Bool ) : Void {
		throw "Not implemented";
	}

	public function setFastSend( b : Bool ) : Void {
		throw "Not implemented";
	}

	public static function select(read : Array<Socket>, write : Array<Socket>, others : Array<Socket>, ?timeout : Float) : {read: Array<Socket>,write: Array<Socket>,others: Array<Socket>} {
		throw "Not implemented";
	}
}
