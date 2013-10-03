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

import haxe.ds.ObjectMap;
import io.xun.core.event.IObserver;
import io.xun.core.event.Observable;
import io.xun.core.event.IObservable;
import io.xun.core.exception.OutOfBoundsException;
import haxe.io.Bytes;

/**
 * Class ByteArrayInputStream
 *
 * @author        Maximilian Ruta <mr@xtain.net>
 * @copyright     Copyright (c) 2013 XTAIN oHG, <https://company.xtain.net>
 * @package       io.xun.io
 */
class ByteArrayInputStream extends InputStream {

    private var buffer : Bytes;
    private var pos : Int = 0;
    private var markCurrent : Int = 0;
    private var count : Int;
    private var observable : Observable;
    private var alreadyNotified : ObjectMap<IObserver, Bool>;

    public function new(buffer : Bytes, offset : Int = 0, length : Null<Int> = null) {
        this.buffer = buffer;
        this.pos = offset;
        this.markCurrent = offset;
        if (length == null) {
            this.count = buffer.length;
        } else {
            this.count = Math.round(Math.min(offset + length, buffer.length));
        }
        this.observable = new Observable(this);
        this.alreadyNotified = new ObjectMap<IObserver, Bool>();
    }

    override public function readOffset(bytes : Bytes, offset : Int = 0, length : Null<Int> = null) : Int {
        if (length == null) {
            length = bytes.length - offset;
        }
        if (offset < 0 || length < 0 || length > bytes.length - offset) {
            throw new OutOfBoundsException();
        }
        if (pos >= count) {
            return -1;
        }
        if (pos + length > count) {
            length = count - pos;
        }
        if (length <= 0) {
            return 0;
        }
        bytes.blit(offset, buffer, pos, length);
        pos += length;
        return length;
    }

    override public function skip(n : Int) : Int {
        if (pos + n > count) {
            n = count - pos;
        }
        if (n < 0) {
            return 0;
        }
        pos += n;
        return n;
    }

    override public function available() : Int {
        var r : Int = count - pos;
        if (r < 0) {
            return 0;
        }
        return r;
    }

    override public function markSupported() : Bool {
        return true;
    }

    override public function mark(readLimit : Int) : Void {
        markCurrent = pos;
    }

    override public function reset() : Void {
        pos = markCurrent;
    }

    override public function close() : Void {
    }

    override public function attach(o : IObserver, mask : Null<Int> = 0) : Void {
        this.observable.attach(o, mask);
        if (!(this.alreadyNotified.exists(o) && this.alreadyNotified.get(o))) {
            this.observable.notify(InputStream.InputStreamEvent.DATA, null);
            this.alreadyNotified.set(o, true);
        }
    }

    override public function detach(o : IObserver, mask : Null<Int> = null) : Void {
        this.observable.detach(o, mask);
    }
}
