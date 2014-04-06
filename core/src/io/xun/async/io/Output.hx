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
 * @package       io.xun.async.io
 * @license       http://www.gnu.org/licenses/agpl-3.0.html GNU Affero General Public License
 */

package io.xun.async.io;

import io.xun.async.Promise;
import io.xun.core.exception.DefaultException;
import io.xun.core.exception.Exception;
import haxe.io.Bytes;

class Output implements IOutput {

    private var output : haxe.io.Output;
    public var bigEndian(get, set) : Bool;

    public function new(output : haxe.io.Output) {
        this.output = output;
    }

    public function set_bigEndian( b: Bool ) : Bool {
        return this.output.bigEndian = b;
    }

    public function get_bigEndian() : Bool {
        return this.output.bigEndian;
    }

    public function flush(callback : Null<Exception> -> Void) : Void {
        try {
            this.output.flush();
            callback(null);
        } catch (e : Dynamic) {
            callback(new DefaultException(e));
        }
    }

    public function close(callback : Null<Exception> -> Void) : Void {
        try {
            this.output.close();
            callback(null);
        } catch (e : Dynamic) {
            callback(new DefaultException(e));
        }
    }

    public function writeByte(c : Int, callback : Null<Exception> -> Void) : Void {
        try {
            this.output.writeByte(c);
            callback(null);
        } catch (e : Dynamic) {
            callback(new DefaultException(e));
        }
    }

    public function writeBytes( buf : Bytes, pos : Int, len : Int ) : Promise<Int> {
        var r : Promise<Int> = new Promise<Int>();
        r.resolve(output.writeBytes(buf, pos, len));
        return r;
    }

    #if flash9
    public function writeFloat( f : Float, callback : Null<Exception> -> Void ) : Void {
        try {
            this.output.writeFloat(f);
            callback(null);
        } catch (e : Dynamic) {
            callback(new DefaultException(e));
        }
    }

    public function writeDouble( f : Float, callback : Null<Exception> -> Void ) : Void {
        try {
            this.output.writeDouble(f);
            callback(null);
        } catch (e : Dynamic) {
            callback(new DefaultException(e));
        }
    }

    public function writeInt8( x : Int, callback : Null<Exception> -> Void ) : Void {
        try {
            this.output.writeInt8(x);
            callback(null);
        } catch (e : Dynamic) {
            callback(new DefaultException(e));
        }
    }

    public function writeInt16( x : Int, callback : Null<Exception> -> Void ) : Void {
        try {
            this.output.writeInt16(x);
            callback(null);
        } catch (e : Dynamic) {
            callback(new DefaultException(e));
        }
    }

    public function writeUInt16( x : Int, callback : Null<Exception> -> Void ) : Void {
        try {
            this.output.writeUInt16(x);
            callback(null);
        } catch (e : Dynamic) {
            callback(new DefaultException(e));
        }
    }

    public function writeInt32( x : Int, callback : Null<Exception> -> Void ) : Void {
        try {
            this.output.writeInt32(x);
            callback(null);
        } catch (e : Dynamic) {
            callback(new DefaultException(e));
        }
    }

    public function prepare( size : Int, callback : Null<Exception> -> Void ) : Void {
        try {
            this.output.prepare(size);
            callback(null);
        } catch (e : Dynamic) {
            callback(new DefaultException(e));
        }
    }

    public function writeString( s : String, callback : Null<Exception> -> Void ) : Void {
        try {
            this.output.writeString(s);
            callback(null);
        } catch (e : Dynamic) {
            callback(new DefaultException(e));
        }
    }
    #end

}
