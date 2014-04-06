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

class Input implements IInput {

    private var input : haxe.io.Input;
    public var bigEndian(get, set) : Bool;

    public function new(input : haxe.io.Input) {
        this.input = input;
    }

    public function set_bigEndian( b: Bool ) : Bool {
        return this.input.bigEndian = b;
    }

    public function get_bigEndian() : Bool {
        return this.input.bigEndian;
    }

    public function readByte() : Promise<Int> {
        var r : Promise<Int> = new Promise<Int>();
        r.resolve(input.readByte());
        return r;
    }

    public function readBytes( s : Bytes, pos : Int, len : Int ) : Promise<Int> {
        var r : Promise<Int> = new Promise<Int>();
        r.resolve(input.readBytes(s, pos, len));
        return r;
    }

    public function close( callback : Null<Exception> -> Void ) : Void {
        try {
            this.input.close();
            callback(null);
        } catch (e : Dynamic) {
            callback(new DefaultException(e));
        }
    }

    public function readAll( ?bufsize : Int ) : Promise<Bytes> {
        var r : Promise<Bytes> = new Promise<Bytes>();
        r.resolve(input.readAll(bufsize));
        return r;
    }

    public function readFullBytes( s : Bytes, pos : Int, len : Int, callback : Null<Exception> -> Void ) : Void {
        try {
            this.input.readFullBytes(s, pos, len);
            callback(null);
        } catch (e : Dynamic) {
            callback(new DefaultException(e));
        }
    }

    public function read( nbytes : Int ) : Promise<Bytes> {
        var r : Promise<Bytes> = new Promise<Bytes>();
        r.resolve(input.read(nbytes));
        return r;
    }

    public function readUntil( end : Int ) : Promise<String> {
        var r : Promise<String> = new Promise<String>();
        r.resolve(input.readUntil(end));
        return r;
    }

    public function readLine() : Promise<String> {
        var r : Promise<String> = new Promise<String>();
        r.resolve(input.readLine());
        return r;
    }

    public function readFloat() : Promise<Float> {
        var r : Promise<Float> = new Promise<Float>();
        r.resolve(input.readFloat());
        return r;
    }

    public function readDouble() : Promise<Float> {
        var r : Promise<Float> = new Promise<Float>();
        r.resolve(input.readDouble());
        return r;
    }

    public function readInt8() : Promise<Dynamic> {
        var r : Promise<Dynamic> = new Promise<Dynamic>();
        r.resolve(input.readInt8());
        return r;
    }

    public function readInt16() : Promise<Dynamic> {
        var r : Promise<Dynamic> = new Promise<Dynamic>();
        r.resolve(input.readInt16());
        return r;
    }

    public function readUInt16() : Promise<Dynamic> {
        var r : Promise<Dynamic> = new Promise<Dynamic>();
        r.resolve(input.readUInt16());
        return r;
    }

    public function readInt24() : Promise<Dynamic> {
        var r : Promise<Dynamic> = new Promise<Dynamic>();
        r.resolve(input.readInt24());
        return r;
    }

    public function readUInt24() : Promise<Dynamic> {
        var r : Promise<Dynamic> = new Promise<Dynamic>();
        r.resolve(input.readUInt24());
        return r;
    }

    public function readInt32() : Promise<Dynamic> {
        var r : Promise<Dynamic> = new Promise<Dynamic>();
        r.resolve(input.readInt32());
        return r;
    }

    public function readString( len : Int ) : Promise<String> {
        var r : Promise<String> = new Promise<String>();
        r.resolve(input.readString(len));
        return r;
    }

    #if (flash || js)
    public function getDoubleSig(bytes : Array<Int>) : Promise<Dynamic> {
        var r : Promise<Dynamic> = new Promise<Dynamic>();
        r.resolve(input.readBype(bytes));
        return r;
    }
    #end

}
