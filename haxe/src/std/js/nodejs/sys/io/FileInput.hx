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
package js.nodejs.sys.io;

import sys.io.FileSeek;
import sys.FileStat;
import js.nodejs.Node;
import haxe.io.Bytes;

/**
	Use [sys.io.File.read] to create a [FileInput]
**/
class FileInput extends haxe.io.Input {

	private var __f : Int;
	private var path : String;
	private var mode : String;
	private var binary : Bool;
	private var filePosition : Int;
	private var fileEndPosition : Int;
	private var stat : FileStat;
	private var isEof : Bool = false;

	public function new(path : String, mode : String, binary : Bool) : Void {
		this.path = path;
		this.mode = mode;
		this.binary = binary;

		this.stat = sys.FileSystem.stat(path);
		this.fileEndPosition = stat.size;
		this.filePosition = 0;

		__f = Node.fs.openSync(path, mode);
	}

	public override function readByte() : Int {
		var b = new NodeBuffer(1);
		var r = Node.fs.readSync(__f, b, 0, 1, filePosition);
		if (r <= 0) {
			isEof = true;
			return throw new haxe.io.Eof();
		}
		filePosition++;
		return Bytes.ofString(b.toString(Node.NodeC.UTF8)).get(0);
	}

	/*
	public override function readBytes( s : Bytes, p : Int, l : Int ) : Int {
		if( pos < 0 || len < 0 || pos + len > s.length ) {
			throw haxe.io.Error.OutsideBounds;
		}
		if(eof()) {
			return throw new haxe.io.Eof();
		}
		var b = __js__('new Buffer(l)');
		var r = Node.fs.readSync(__f, b, 0, l, null);
		filePosition = filePosition + r;
		var b = Bytes.ofString(b.toString());
		s.blit(p, b, 0, r);
		return r;
	}
	*/

	public override function close() : Void {
		super.close();
		Node.fs.closeSync(__f);
	}

	public function seek( p : Int, pos : FileSeek ) : Void {
		var readNumber : Int;
		var seekPosition : Int = 0;
		isEof = false;
		switch( pos ) {
			case SeekBegin:
				filePosition = p;
			case SeekCur:
				filePosition = filePosition + p;
			case SeekEnd:
				filePosition = fileEndPosition + p;
		}
	}

	public function tell() : Int {
		if (seekEof()) {
			return fileEndPosition;
		}
		return filePosition;
	}

	private function seekEof() : Bool {
		return filePosition >= fileEndPosition;
	}

	public function eof() : Bool {
		return isEof;
	}

}
