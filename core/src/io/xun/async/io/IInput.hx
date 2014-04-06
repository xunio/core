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
import io.xun.core.exception.Exception;
import haxe.io.Bytes;

interface IInput {

    public function readByte() : Promise<Int>;
    public function readBytes( s : Bytes, pos : Int, len : Int ) : Promise<Int>;
    public function close( callback : Null<Exception> -> Void ) : Void;
    public function readAll( ?bufsize : Int ) : Promise<Bytes>;
    public function readFullBytes( s : Bytes, pos : Int, len : Int, callback : Null<Exception> -> Void ) : Void;
    public function read( nbytes : Int ) : Promise<Bytes>;
    public function readUntil( end : Int ) : Promise<String>;
    public function readLine() : Promise<String>;
    public function readFloat() : Promise<Float>;
    public function readDouble() : Promise<Float>;
    public function readInt8() : Promise<Dynamic>;
    public function readInt16() : Promise<Dynamic>;
    public function readUInt16() : Promise<Dynamic>;
    public function readInt24() : Promise<Dynamic>;
    public function readUInt24() : Promise<Dynamic>;
    public function readInt32() : Promise<Dynamic>;
    public function readString( len : Int ) : Promise<String>;
    #if (flash || js)
    public function getDoubleSig(bytes : Array<Int>) : Promise<Dynamic>;
    #end

}
