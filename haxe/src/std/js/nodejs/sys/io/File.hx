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

import js.nodejs.Node;
import haxe.io.Bytes;

/**
	API for reading and writing to files.

	See `sys.FileSystem` for the complementary file system API.
**/
class File {

	private static var fs : {};
	private static var path : {};

	public static function getContent( path : String ) : String {
		return Node.fs.readFileSync(path);
	}

	public static function saveContent( path : String, content : String ) : Void {
		Node.fs.writeFileSync(path, content);
	}

	public static function getBytes( path : String ) : Bytes {
		var o = Node.fs.openSync(path, "r");
		var s = Node.fs.fstatSync(o);
		var len = s.size, pos = 0;
		var bytes = Bytes.alloc(s.size);
		while( len > 0 ) {
			var r = Node.fs.readSync(o, bytes.getData(), pos, len, null);
			pos += r;
			len -= r;
		}
		Node.fs.closeSync(o);
		return bytes;
	}

	public static function saveBytes( path : String, bytes : haxe.io.Bytes ) : Void {
		var f = write(path);
		f.write(bytes);
		f.close();
	}

	public static function read( path : String, binary : Bool = true ) : sys.io.FileInput {
		return new sys.io.FileInput(path, 'r', binary);
	}

	public static function write( path : String, binary : Bool = true ) : sys.io.FileOutput {
		return new sys.io.FileOutput(path, 'w', binary);
	}

	public static function append( path : String, binary : Bool = true ) : sys.io.FileOutput {
		return new sys.io.FileOutput(path, 'a', binary);
	}

	public static function copy( srcPath : String, dstPath : String ) : Void {
		Node.fs.createReadStream(srcPath).pipe(Node.fs.createWriteStream(dstPath));
	}

}
