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

import io.xun.io.InputStream;
import io.xun.io.InputStream.InputStreamEvent;
import io.xun.core.exception.Exception;
import io.xun.io.PipeInputStream;
import io.xun.core.event.IObservable;
import io.xun.core.event.IObserver;
import io.xun.core.exception.OutOfBoundsException;
import haxe.io.Bytes;
import haxe.io.BytesData;
import io.xun.io.ByteArrayInputStream;

/**
 * Class TestPipeInputSteam
 *
 * @author        Maximilian Ruta <mr@xtain.net>
 * @copyright     Copyright (c) 2013 XTAIN oHG, <https://company.xtain.net>
 * @package       io.xun.test.unit.io
 */
class TestPipeInputSteam extends haxe.unit.TestCase {

    private var pipeAtEnd : Bool = false;

    public function pipe(size : Int, endChunk : Null<Bytes>, b : Bytes) : Bytes {
        if (size != 0) {
            if (b.length > size) {
                assertTrue(false);
            } else if (b.length < size) {
                if (pipeAtEnd) {
                    assertTrue(false);
                }
                pipeAtEnd = true;
                if (endChunk.toHex() == b.toHex()) {
                    assertTrue(true);
                } else {
                    assertTrue(false);
                }
            } else {
                assertTrue(true);
            }
        }

        var r : Bytes = Bytes.alloc(b.length * 2);
        for( i in 0...b.length ) {
            r.set(i * 2, b.get(i));
            r.set((i * 2) + 1, b.get(i) + 16);
        }
        return r;
    }

    public function createPipe(sourceBytes : Bytes, stream : InputStream, chunkSize : Int = 0) : PipeInputStream {
        pipeAtEnd = false;
        if (chunkSize == 0) {
            return new PipeInputStream(stream, this.pipe.bind(0, null));
        }
        var sub : Int = Math.floor(sourceBytes.length / chunkSize) * chunkSize;
        var pipe : Bytes -> Bytes = this.pipe.bind(chunkSize, sourceBytes.sub(sub, sourceBytes.length - sub));
        return new PipeInputStream(stream, pipe, chunkSize);
    }

    public function testReadOffset() {
        var sourceBytes : Bytes;
        var targetBytes : Bytes;
        var stream : ByteArrayInputStream;

        sourceBytes = Bytes.ofString('123456');

        stream = new ByteArrayInputStream(sourceBytes);
        var pipe : PipeInputStream = createPipe(sourceBytes, stream);
        targetBytes = Bytes.alloc(sourceBytes.length * 2);
        assertEquals(12, pipe.readOffset(targetBytes));
        assertEquals(Bytes.ofString('1A2B3C4D5E6F').toHex(), targetBytes.toHex());

        stream = new ByteArrayInputStream(sourceBytes);
        var pipe : PipeInputStream = createPipe(sourceBytes, stream);
        targetBytes = Bytes.alloc((sourceBytes.length * 2) + 5);
        assertEquals(12, pipe.readOffset(targetBytes, 0, 12 + 5));
        assertEquals('3141324233433444354536460000000000', targetBytes.toHex());

        stream = new ByteArrayInputStream(sourceBytes);
        var pipe : PipeInputStream = createPipe(sourceBytes, stream, 5);
        targetBytes = Bytes.alloc(sourceBytes.length * 2);
        assertEquals(12, pipe.readOffset(targetBytes));
        assertEquals(Bytes.ofString('1A2B3C4D5E6F').toHex(), targetBytes.toHex());
        assertEquals(-1, pipe.readOffset(targetBytes));
        assertEquals(Bytes.ofString('1A2B3C4D5E6F').toHex(), targetBytes.toHex());

        stream = new ByteArrayInputStream(sourceBytes);
        var pipe : PipeInputStream = createPipe(sourceBytes, stream);
        targetBytes = Bytes.alloc(sourceBytes.length);
        assertEquals(6, pipe.readOffset(targetBytes));
        assertEquals(Bytes.ofString('1A2B3C').toHex(), targetBytes.toHex());

        stream = new ByteArrayInputStream(sourceBytes);
        var pipe : PipeInputStream = createPipe(sourceBytes, stream);
        targetBytes = Bytes.alloc((sourceBytes.length * 2) + 2);
        targetBytes.set(0, 1);
        targetBytes.set(1, 2);
        assertEquals(12, pipe.readOffset(targetBytes, 2));
        assertEquals('0102314132423343344435453646', targetBytes.toHex());
        assertEquals(-1, pipe.readOffset(targetBytes, 2));
        assertEquals('0102314132423343344435453646', targetBytes.toHex());

        stream = new ByteArrayInputStream(sourceBytes);
        var pipe : PipeInputStream = createPipe(sourceBytes, stream);
        targetBytes = Bytes.alloc((sourceBytes.length * 2) + 2);
        targetBytes.set(0, 1);
        targetBytes.set(1, 2);
        assertEquals(3, pipe.readOffset(targetBytes, 2, 3));
        assertEquals('0102314132000000000000000000', targetBytes.toHex());
        assertEquals(2, pipe.readOffset(targetBytes, 5, 2));
        assertEquals('0102314132423300000000000000', targetBytes.toHex());

        stream = new ByteArrayInputStream(sourceBytes);
        var pipe : PipeInputStream = createPipe(sourceBytes, stream);
        targetBytes = Bytes.alloc((sourceBytes.length * 2) + 2);
        targetBytes.set(0, 1);
        targetBytes.set(1, 2);
        targetBytes.set(1, 2);
        targetBytes.set(7, 5);
        targetBytes.set(9, 6);
        targetBytes.set(13, 7);
        assertEquals(3, pipe.readOffset(targetBytes, 2, 3));
        assertEquals('0102314132000005000600000007', targetBytes.toHex());
        assertEquals(2, pipe.readOffset(targetBytes, 5, 2));
        assertEquals('0102314132423305000600000007', targetBytes.toHex());


        stream = new ByteArrayInputStream(sourceBytes);
        var pipe : PipeInputStream = createPipe(sourceBytes, stream);
        targetBytes = Bytes.alloc(2);
        try {
            stream.readOffset(targetBytes, 0, 5);
            assertTrue(false);
        } catch(e : OutOfBoundsException) {
            assertTrue(true);
        } catch(e : Dynamic) {
            assertTrue(false);
        }

        stream = new ByteArrayInputStream(sourceBytes);
        var pipe : PipeInputStream = createPipe(sourceBytes, stream);
        targetBytes = Bytes.alloc(2);
        try {
            stream.readOffset(targetBytes, 3, 1);
            assertTrue(false);
        } catch(e : OutOfBoundsException) {
            assertTrue(true);
        } catch(e : Dynamic) {
            assertTrue(false);
        }
    }


    public function testSkip() {
        var sourceBytes : Bytes;
        var targetBytes : Bytes;
        var stream : ByteArrayInputStream;

        sourceBytes = Bytes.ofString('123456');

        stream = new ByteArrayInputStream(sourceBytes);
        var pipe : PipeInputStream = createPipe(sourceBytes, stream);
        targetBytes = Bytes.alloc((sourceBytes.length * 2) - 4);
        assertEquals(4, pipe.skip(4));
        assertEquals(8, pipe.readOffset(targetBytes));
        assertEquals(Bytes.ofString('3C4D5E6F').toHex(), targetBytes.toHex());

        stream = new ByteArrayInputStream(sourceBytes);
        var pipe : PipeInputStream = createPipe(sourceBytes, stream);
        targetBytes = Bytes.alloc((sourceBytes.length * 2) - 3);
        assertEquals(3, pipe.skip(3));
        assertEquals(9, pipe.readOffset(targetBytes));
        assertEquals(Bytes.ofString('B3C4D5E6F').toHex(), targetBytes.toHex());
        assertEquals(0, pipe.skip(3));
   }

    public function testObserver() {
        var sourceBytes : Bytes;
        var stream : ByteArrayInputStream;

        sourceBytes = Bytes.ofString('123456');

        stream = new ByteArrayInputStream(sourceBytes);
        var pipe : PipeInputStream = createPipe(sourceBytes, stream);
        var ob : TestTestPipeInputSteamObserver = new TestTestPipeInputSteamObserver();
        pipe.attach(ob, InputStreamEvent.DATA);
        assertEquals(12, ob.read);
        assertEquals(Bytes.ofString('1A2B3C4D5E6F').toHex(), ob.targetBytes.toHex());
    }

}

/**
 * Class TestTestPipeInputSteamObserver
 *
 * @author        Maximilian Ruta <mr@xtain.net>
 * @copyright     Copyright (c) 2013 XTAIN oHG, <https://company.xtain.net>
 * @package       io.xun.test.unit.io.TestPipeInputSteam
 */
class TestTestPipeInputSteamObserver implements IObserver {

    public var targetBytes : Bytes;
    public var read : Int;

    public function new() {
        targetBytes = Bytes.alloc(12);
    }

    public function onUpdate( type : Int, source : IObservable, userData : Dynamic ) : Void {
        switch(type) {
            case InputStreamEvent.DATA:
                var stream : InputStream = cast source;
                read = stream.readOffset(targetBytes);
        }
    }

}