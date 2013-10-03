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
 * @package       io.xun.test.unit.io
 * @license       http://www.gnu.org/licenses/agpl-3.0.html GNU Affero General Public License
 */

package io.xun.test.unit.io;

import io.xun.core.event.IObservable;
import io.xun.core.event.IObserver;
import io.xun.core.exception.OutOfBoundsException;
import haxe.io.Bytes;
import haxe.io.BytesData;
import io.xun.io.ByteArrayInputStream;
import io.xun.io.InputStream;
import io.xun.io.InputStream.InputStreamEvent;

/**
 * Class TestByteArrayInputSteam
 *
 * @author        Maximilian Ruta <mr@xtain.net>
 * @copyright     Copyright (c) 2013 XTAIN oHG, <https://company.xtain.net>
 * @package       io.xun.test.unit.io
 */
class TestByteArrayInputSteam extends haxe.unit.TestCase {

    public function testRead() {
        var sourceBytes : Bytes;
        var targetBytes : Bytes;
        var stream : ByteArrayInputStream;

        sourceBytes = Bytes.ofString('1234');
        stream = new ByteArrayInputStream(sourceBytes);

        targetBytes = Bytes.alloc(1);
        assertEquals(1, stream.read(targetBytes));
        assertEquals('31', targetBytes.toHex());
        assertEquals(1, stream.read(targetBytes));
        assertEquals('32', targetBytes.toHex());
        assertEquals(1, stream.read(targetBytes));
        assertEquals('33', targetBytes.toHex());
        assertEquals(1, stream.read(targetBytes));
        assertEquals('34', targetBytes.toHex());

        targetBytes = Bytes.alloc(1);
        assertEquals(-1, stream.read(targetBytes));
        assertEquals(0, targetBytes.get(0));
    }

    public function testReadOffset() {
        var sourceBytes : Bytes;
        var targetBytes : Bytes;
        var stream : ByteArrayInputStream;

        sourceBytes = Bytes.ofString('1234');
        stream = new ByteArrayInputStream(sourceBytes);

        targetBytes = Bytes.alloc(4);
        assertEquals(4, stream.readOffset(targetBytes));
        assertEquals('1234', targetBytes.toString());


        sourceBytes = Bytes.ofString('1234');
        stream = new ByteArrayInputStream(sourceBytes);

        targetBytes = Bytes.alloc(6);
        assertEquals(4, stream.readOffset(targetBytes));
        assertEquals('313233340000', targetBytes.toHex());
        assertEquals(0, targetBytes.get(4));
        assertEquals(0, targetBytes.get(5));


        sourceBytes = Bytes.ofString('1234');
        stream = new ByteArrayInputStream(sourceBytes);
        targetBytes = Bytes.alloc(4);
        targetBytes.set(0, 1);
        targetBytes.set(1, 2);
        assertEquals(2, stream.readOffset(targetBytes, 2));
        assertEquals('01023132', targetBytes.toHex());


        sourceBytes = Bytes.ofString('1234');
        stream = new ByteArrayInputStream(sourceBytes);
        targetBytes = Bytes.alloc(4);
        targetBytes.set(0, 1);
        targetBytes.set(1, 2);
        assertEquals(1, stream.readOffset(targetBytes, 2, 1));
        assertEquals('01023100', targetBytes.toHex());


        sourceBytes = Bytes.ofString('12');
        stream = new ByteArrayInputStream(sourceBytes);
        targetBytes = Bytes.alloc(2);
        try {
            stream.readOffset(targetBytes, 0, 5);
            assertTrue(false);
        } catch(e : OutOfBoundsException) {
            assertTrue(true);
        } catch(e : Dynamic) {
            assertTrue(false);
        }

        sourceBytes = Bytes.ofString('12');
        stream = new ByteArrayInputStream(sourceBytes);
        targetBytes = Bytes.alloc(2);
        try {
            stream.readOffset(targetBytes, 3, 1);
            assertTrue(false);
        } catch(e : OutOfBoundsException) {
            assertTrue(true);
        } catch(e : Dynamic) {
            assertTrue(false);
        }

        sourceBytes = Bytes.ofString('1234');
        targetBytes = Bytes.alloc(5);
        stream = new ByteArrayInputStream(sourceBytes);

        targetBytes.set(3, 1);
        targetBytes.set(4, 2);
        assertEquals(3, stream.readOffset(targetBytes, 0, 3));
        assertEquals('3132330102', targetBytes.toHex());
    }

    public function testSkip() {
        var sourceBytes : Bytes;
        var targetBytes : Bytes;
        var stream : ByteArrayInputStream;

        sourceBytes = Bytes.ofString('1234');
        stream = new ByteArrayInputStream(sourceBytes);
        assertEquals(2, stream.skip(2));
        targetBytes = Bytes.alloc(2);
        assertEquals(2, stream.readOffset(targetBytes));
        assertEquals('3334', targetBytes.toHex());


        sourceBytes = Bytes.ofString('1234');
        stream = new ByteArrayInputStream(sourceBytes);
        assertEquals(4, stream.skip(5));
        targetBytes = Bytes.alloc(1);
        assertEquals(-1, stream.readOffset(targetBytes));


        sourceBytes = Bytes.ofString('1234');
        stream = new ByteArrayInputStream(sourceBytes);
        assertEquals(4, stream.skip(4));
        assertEquals(0, stream.skip(2));
        assertEquals(0, stream.available());
    }

    public function testToBytes() {
        var sourceBytes : Bytes;
        var targetBytes : Bytes;
        var stream : ByteArrayInputStream;

        sourceBytes = Bytes.ofString('1234');
        stream = new ByteArrayInputStream(sourceBytes);
        targetBytes = stream.toBytes();
        assertEquals('31323334', targetBytes.toHex());
    }

    public function testMarkSupported() {
        var sourceBytes : Bytes;
        var targetBytes : Bytes;
        var stream : ByteArrayInputStream;

        sourceBytes = Bytes.ofString('1234');
        stream = new ByteArrayInputStream(sourceBytes);
        assertTrue(stream.markSupported());
    }

    public function testMark() {
        var sourceBytes : Bytes;
        var targetBytes : Bytes;
        var stream : ByteArrayInputStream;

        sourceBytes = Bytes.ofString('1234');
        stream = new ByteArrayInputStream(sourceBytes);
        targetBytes = Bytes.alloc(2);
        assertEquals(2, stream.readOffset(targetBytes));
        assertEquals('3132', targetBytes.toHex());
        stream.mark(2);
        targetBytes = Bytes.alloc(2);
        assertEquals(2, stream.readOffset(targetBytes));
        assertEquals('3334', targetBytes.toHex());
        stream.reset();
        targetBytes = Bytes.alloc(2);
        assertEquals(2, stream.readOffset(targetBytes));
        assertEquals('3334', targetBytes.toHex());
    }

    public function testObserver() {
        var sourceBytes : Bytes;
        var stream : ByteArrayInputStream;

        sourceBytes = Bytes.ofString('1234');
        stream = new ByteArrayInputStream(sourceBytes);
        var ob : TestByteArrayInputSteamObserver = new TestByteArrayInputSteamObserver();
        stream.attach(ob, InputStreamEvent.DATA);
        assertEquals(4, ob.read);
        assertEquals('31323334', ob.targetBytes.toHex());
    }

}

/**
 * Class TestByteArrayInputSteamObserver
 *
 * @author        Maximilian Ruta <mr@xtain.net>
 * @copyright     Copyright (c) 2013 XTAIN oHG, <https://company.xtain.net>
 * @package       io.xun.test.unit.io.TestByteArrayInputSteam
 */
class TestByteArrayInputSteamObserver implements IObserver {

    public var targetBytes : Bytes;
    public var read : Int;

    public function new() {
        targetBytes = Bytes.alloc(4);
    }

    public function onUpdate( type : Int, source : IObservable, userData : Dynamic ) : Void {
        switch(type) {
            case InputStreamEvent.DATA:
                var stream : InputStream = cast source;
                read = stream.readOffset(targetBytes);
        }
    }

}