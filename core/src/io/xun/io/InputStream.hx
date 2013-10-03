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

import io.xun.core.event.IObservable;
import io.xun.core.event.IObserver;
import haxe.io.Bytes;
import io.xun.core.exception.VirtualMethodCallException;
using io.xun.io.ByteUtils;

/**
 * Class InputStream
 *
 * @author        Maximilian Ruta <mr@xtain.net>
 * @copyright     Copyright (c) 2013 XTAIN oHG, <https://company.xtain.net>
 * @package       io.xun.io
 */
class InputStream implements ICloseable implements IObservable {

    // SKIP_BUFFER_SIZE is used to determine the size of skipBuffer
    private static inline var SKIP_BUFFER_SIZE : Int = 2048;
    // skipBuffer is initialized in skip(long), if needed.
    private var skipBuffer : Bytes;

    public function read(bytes : Bytes) : Int {
        return this.readOffset(bytes, 0, 1);
    }

    public function readOffset(bytes : Bytes, offset : Int = 0, length : Null<Int> = null) : Int {
        throw new VirtualMethodCallException();
        return 0;
    }

    public function skip(n : Int) : Int {
        var remaining : Int = n;
        var nr : Int;
        if (skipBuffer == null) {
            skipBuffer = Bytes.alloc(SKIP_BUFFER_SIZE);
        }
        var localSkipBuffer : Bytes = skipBuffer;
        if (n <= 0) {
            return 0;
        }
        while (remaining > 0) {
            nr = readOffset(localSkipBuffer, 0, cast(Math.min(SKIP_BUFFER_SIZE, remaining), Int));
            if (nr < 0) {
                break;
            }
            remaining -= nr;
        }
        return n - remaining;
    }

    public function available() : Int {
        return 0;
    }

    public function markSupported() : Bool {
        return false;
    }

    public function mark(readLimit : Int) : Void {}

    public function reset() : Void {
        throw new IOException("mark/reset not supported");
    }

    public function close() : Void {
        throw new VirtualMethodCallException();
    }

    public function toBytes() : Bytes {
        var result : Bytes = Bytes.alloc(0);
        var buffer : Bytes;
        var nr : Int;
        while (true) {
            buffer = Bytes.alloc(SKIP_BUFFER_SIZE);
            nr = readOffset(buffer, 0, SKIP_BUFFER_SIZE);
            if (nr < 0) {
                break;
            }
            result = result.append(buffer.sub(0, nr));
        }
        return result;
    }

    public function attach(o : IObserver, mask : Null<Int> = 0) : Void {
        throw new VirtualMethodCallException();
    }

    public function detach(o : IObserver, mask : Null<Int> = null) : Void {
        throw new VirtualMethodCallException();
    }

}

/**
 * Class InputStreamEvent
 *
 * @author        Maximilian Ruta <mr@xtain.net>
 * @copyright     Copyright (c) 2013 XTAIN oHG, <https://company.xtain.net>
 * @package       io.xun.io.InputStreamEvent
 */
@:build(io.xun.core.event.ObserverMacro.create([
DATA
]))
class InputStreamEvent {
    public inline static var DATA;
    public inline static var GROUP_ID;
    public inline static var GROUP_MASK;
    public inline static var EVENT_MASK;
}

