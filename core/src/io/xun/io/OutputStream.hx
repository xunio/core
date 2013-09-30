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

import io.xun.core.exception.VirtualMethodCallException;
import io.xun.core.exception.OutOfBoundsException;
import io.xun.core.exception.Exception;
import haxe.io.Bytes;
import haxe.io.BytesData;

/**
 * Class OutputStream
 *
 * @author        Maximilian Ruta <mr@xtain.net>
 * @copyright     Copyright (c) 2013 XTAIN oHG, <https://company.xtain.net>
 * @package       io.xun.io
 */
class OutputStream implements IFlushable implements ICloseable {

    public function write(b : BytesData) : Void {
        throw new VirtualMethodCallException();
    }

    /**
     * Writes len bytes from the specified byte array starting at offset off to this output stream. The general
     * contract for write(b, off, len) is that some of the bytes in the array b are written to the output stream in
     * order; element b[off] is the first byte written and b[off + len - 1] is the last byte written by this operation.
     * The write method of OutputStream calls the write method of one argument on each of the bytes to be written out.
     * Subclasses are encouraged to override this method and provide a more efficient implementation.
     *
     * If off is negative, or len is negative, or off + len is greater than the length of the array b, then an
     * IndexOutOfBoundsException is thrown.
     *
     * @author Maximilian Ruta <mr@xtain.net>
     * @throws io.xun.exception.IndexOutOfBoundsException
     */
    public function writeOffset(b : BytesData, offset : Int, length : Int) : Void {
        var bytes : Bytes = Bytes.ofData(b);

        if (offset < 0 || (offset + length) > bytes.length) {
            throw new OutOfBoundsException();
        }

        bytes = bytes.readString(offset, length);
        this.write(bytes.getData());
    }

    /**
     *
     * @author Maximilian Ruta <mr@xtain.net>
     */
    public function writeByte(b : Int) : Void {
        var bytes : Bytes = new Bytes();
        bytes.set(0, b);
        this.write(bytes.getData());
    }


    /*
     * Flushes this stream by writing any buffered output to the underlying stream.
     *
     * @author Maximilian Ruta <mr@xtain.net>
     * @throws io.xun.io.IOException If an I/O error occurs
     */
    public function flush() : Void {
        throw new VirtualMethodCallException();
    }

    /*
     * Closes this stream and releases any system resources associated with it. If the stream is already closed then
     * invoking this method has no effect.
     *
     * @author Maximilian Ruta <mr@xtain.net>
     * @throws io.xun.io.IOException If an I/O error occurs
     */
    public function close() : Void {
        throw new VirtualMethodCallException();
    }

}
