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
 * @package       io.xun.io
 * @license       http://www.gnu.org/licenses/agpl-3.0.html GNU Affero General Public License
 */

package io.xun.io;

import io.xun.io.InputStream.InputStreamEvent;
import io.xun.core.event.Observable;
import io.xun.core.event.IObserver;
import io.xun.core.exception.NotImplementedException;
import haxe.io.Bytes;
import io.xun.core.exception.OutOfBoundsException;
import io.xun.core.dependencyinjection.parameterbag.exception.InvalidArgumentException;
import io.xun.core.exception.VirtualMethodCallException;
import haxe.io.Bytes;
import io.xun.core.event.IObservable;
using io.xun.io.ByteUtils;

/**
 * Class PipeInputStream
 *
 * @author        Maximilian Ruta <mr@xtain.net>
 * @copyright     Copyright (c) 2013 XTAIN oHG, <https://company.xtain.net>
 * @package       io.xun.io
 */
class PipeInputStream extends InputStream implements IObserver {

    private var inputStream : InputStream;
    private var pipe : Bytes -> Bytes;
    private var buffer : Bytes;
    private var resultBuffer : Bytes;
    private var chunkSize : Int = 0;
    private var observable : Observable;

    /**
     * Constructor
     *
     * @author Maximilian Ruta <mr@xtain.net>
     */
    public function new(inputStream : InputStream, pipe : Bytes -> Bytes, chunkSize : Int = 0) {
        this.inputStream = inputStream;
        this.pipe = pipe;
        this.buffer = Bytes.alloc(0);
        this.resultBuffer = Bytes.alloc(0);
        this.chunkSize = chunkSize;
        this.observable = new Observable(this);
    }

    private function fillBuffer(length : Int) : Bool {
        if (chunkSize > 0) {
            length = Math.ceil(length / cast(chunkSize, Int)) * chunkSize;
        }
        var read : Int;
        var end : Bool = false;
        var result : Bytes;
        do {
            result = Bytes.alloc(length);
            read = this.inputStream.readOffset(result, 0, length - buffer.length);
            if (read <= -1) {
                read = 0;
                end = true;
            }
            buffer = buffer.append(result.sub(0, read));
        } while(end == false && buffer.length < length);
        return end;
    }

    override public function readOffset(bytes : Bytes, offset : Int = 0, length : Null<Int> = null) : Int {
        if (length == null) {
            length = bytes.length - offset;
        }
        if (offset < 0 || length < 0 || length > bytes.length - offset) {
            throw new OutOfBoundsException();
        }
        if (length <= 0) {
            return 0;
        }

        var end : Bool = false;
        var maxReadLength : Int = length;
        if (chunkSize > 0) {
            maxReadLength = chunkSize;
        }
        var readLength : Int;
        var converted : Bytes;
        var firstRun = true;
        while(end == false && resultBuffer.length < length) {
            end = fillBuffer(length);
            if (firstRun) {
                if (end && resultBuffer.length == 0 && buffer.length == 0) {
                    return -1;
                }
                firstRun = false;
            }
            do {
                readLength = maxReadLength;
                if (buffer.length < maxReadLength) {
                    readLength = buffer.length;
                }
                converted = this.pipe(buffer.sub(0, readLength));
                buffer = buffer.sub(readLength, buffer.length - readLength);
                resultBuffer = resultBuffer.append(converted);
            } while(buffer.length > 0);
        }

        readLength = length;
        if (resultBuffer.length > length) {
            var part : Bytes = resultBuffer.sub(0, length);
            bytes.blit(offset, part, 0, part.length);
            resultBuffer = resultBuffer.sub(length, resultBuffer.length - length);
        } else {
            readLength = resultBuffer.length;
            bytes.blit(offset, resultBuffer, 0, resultBuffer.length);
            resultBuffer = Bytes.alloc(0);
        }

        return readLength;
    }

    override public function close() : Void {
        this.inputStream.close();
    }

    public function onUpdate(type : Int, source : IObservable, userData : Dynamic) : Void {
        this.observable.notify(type, userData);
    }

    override public function attach(o : IObserver, mask : Null<Int> = 0) : Void {
        this.observable.attach(o, mask);
        this.inputStream.attach(this, mask);
    }

    override public function detach(o : IObserver, mask : Null<Int> = null) : Void {
        this.observable.detach(o, mask);
    }

}
