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

import sys.io.FileInput;
import sys.FileSystem;
import sys.io.File;
import sys.io.FileSeek;

/**
 * Class TestFile
 *
 * @author        Maximilian Ruta <mr@xtain.net>
 * @copyright     Copyright (c) 2013 XTAIN oHG, <https://company.xtain.net>
 * @package       io.xun.test.unit.haxe.sys.io
 */
class TestFile extends haxe.unit.TestCase {

	private var path : String;

	public function new() {
		super();
		path = 'testcase-test-file';
	}

	override public function setup() {
		File.saveContent(path, "test\n1234");
	}

	override public function tearDown() {
	    FileSystem.deleteFile(path);
	}

	public function testReadWriteContent() {
		File.saveContent(path, 'test1234');
		assertEquals('test1234', File.getContent(path));
		File.saveContent(path, "teäöüst\n1234");
		assertEquals("teäöüst\n1234", File.getContent(path));
		File.saveContent(path, "test\n1234");
		assertEquals("test\n1234", File.getContent(path));
	}

	public function testRead() {
		var file : FileInput = File.read(path, false);
		assertEquals(0, file.tell());
		assertEquals(116, file.readByte());
		assertEquals(1, file.tell());
		assertEquals(101, file.readByte());
		assertEquals(2, file.tell());
		assertEquals(115, file.readByte());
		assertEquals(3, file.tell());
		assertEquals(116, file.readByte());
		assertEquals(4, file.tell());
	}

	public function testSeekBeginCur() {
		var file : FileInput = File.read(path, false);
		assertEquals(116, file.readByte());
		assertEquals(101, file.readByte());
		assertEquals(115, file.readByte());
		assertEquals(116, file.readByte());

		file.seek(-4, FileSeek.SeekCur);
		assertEquals(0, file.tell());
		assertEquals(116, file.readByte());
		assertEquals(1, file.tell());
	}

	public function testSeekBeginEnd() {
		var file : FileInput = File.read(path, false);
		assertEquals(116, file.readByte());
		assertEquals(101, file.readByte());
		assertEquals(115, file.readByte());
		assertEquals(116, file.readByte());

		file.seek(-9, FileSeek.SeekEnd);
		assertEquals(0, file.tell());
		assertEquals(116, file.readByte());
		assertEquals(1, file.tell());
	}

	public function testSeekBegin() {
		var file : FileInput = File.read(path, false);
		assertEquals(116, file.readByte());
		assertEquals(101, file.readByte());
		assertEquals(115, file.readByte());
		assertEquals(116, file.readByte());

		file.seek(0, FileSeek.SeekBegin);
		assertEquals(0, file.tell());
		assertEquals(116, file.readByte());
		assertEquals(1, file.tell());
	}

	public function testSeekPosBegin() {
		var file : FileInput = File.read(path, false);
		assertEquals(116, file.readByte());
		assertEquals(101, file.readByte());
		assertEquals(115, file.readByte());
		assertEquals(116, file.readByte());

		file.seek(1, FileSeek.SeekBegin);
		assertEquals(1, file.tell());
		assertEquals(101, file.readByte());
		assertEquals(2, file.tell());
	}

	public function testSeekPosBeginMulti() {
		var file : FileInput = File.read(path, false);
		assertEquals(116, file.readByte());
		assertEquals(101, file.readByte());
		assertEquals(115, file.readByte());
		assertEquals(116, file.readByte());

		file.seek(1, FileSeek.SeekBegin);
		assertEquals(1, file.tell());
		assertEquals(101, file.readByte());
		assertEquals(2, file.tell());
		file.seek(3, FileSeek.SeekBegin);
		assertEquals(3, file.tell());
		assertEquals(116, file.readByte());
		assertEquals(4, file.tell());
	}

	public function testSeekEnd() {
		var file : FileInput = File.read(path, false);
		assertEquals(116, file.readByte());
		assertEquals(101, file.readByte());
		assertEquals(115, file.readByte());
		assertEquals(116, file.readByte());

		file.seek(-1, FileSeek.SeekEnd);
		assertEquals(8, file.tell());
		assertEquals(52, file.readByte());
		assertEquals(9, file.tell());
	}

	public function testSeekEofLast() {
		var file : FileInput = File.read(path, false);
		assertEquals(116, file.readByte());
		assertEquals(101, file.readByte());
		assertEquals(115, file.readByte());
		assertEquals(116, file.readByte());

		file.seek(0, FileSeek.SeekEnd);
		assertEquals(9, file.tell());
		assertFalse(file.eof());
		try {
			file.readByte();
			assertTrue(false);
		} catch(e : haxe.io.Eof) {
			assertTrue(true);
		}
		assertTrue(file.eof());
	}

	public function testSeekEof() {
		var file : FileInput = File.read(path, false);
		assertEquals(116, file.readByte());
		assertEquals(101, file.readByte());
		assertEquals(115, file.readByte());
		assertEquals(116, file.readByte());

		file.seek(0, FileSeek.SeekEnd);
		assertEquals(9, file.tell());
		assertFalse(file.eof());
		try {
			file.readByte();
			assertTrue(false);
		} catch(e : haxe.io.Eof) {
			assertTrue(true);
		}
		assertTrue(file.eof());
		assertEquals(9, file.tell());
		file.seek(-1, FileSeek.SeekCur);
		assertEquals(8, file.tell());
		assertEquals(52, file.readByte());
		assertEquals(9, file.tell());
		assertFalse(file.eof());
		try {
			file.readByte();
			assertTrue(false);
		} catch(e : haxe.io.Eof) {
			assertTrue(true);
		}
		assertTrue(file.eof());
		assertEquals(9, file.tell());
		try {
			file.readByte();
			assertTrue(false);
		} catch(e : haxe.io.Eof) {
			assertTrue(true);
		}

		file.seek(5, FileSeek.SeekEnd);
		assertFalse(file.eof());
		try {
			file.readByte();
			assertTrue(false);
		} catch(e : haxe.io.Eof) {
			assertTrue(true);
		}
		assertTrue(file.eof());
		file.seek(1, FileSeek.SeekEnd);
		assertFalse(file.eof());
		try {
			file.readByte();
			assertTrue(false);
		} catch(e : haxe.io.Eof) {
			assertTrue(true);
		}
		assertTrue(file.eof());
		try {
			file.readByte();
			assertTrue(false);
		} catch(e : haxe.io.Eof) {
			assertTrue(true);
		}
	}

}

