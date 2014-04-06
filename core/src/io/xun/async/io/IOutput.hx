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

interface IOutput {

    public function flush(callback : Null<Exception> -> Void) : Void;

    public function close(callback : Null<Exception> -> Void) : Void;

    public function writeByte(c : Int, callback : Null<Exception> -> Void) : Void;

    public function writeBytes( buf : Bytes, pos : Int, len : Int ) : Promise<Int>;

    #if flash9
    public function writeFloat( f : Float, callback : Null<Exception> -> Void ) : Void;

    public function writeDouble( f : Float, callback : Null<Exception> -> Void ) : Void;

    public function writeInt8( x : Int, callback : Null<Exception> -> Void ) : Void;

    public function writeInt16( x : Int, callback : Null<Exception> -> Void ) : Void;

    public function writeUInt16( x : Int, callback : Null<Exception> -> Void ) : Void;

    public function writeInt32( x : Int, callback : Null<Exception> -> Void ) : Void;

    public function prepare( size : Int, callback : Null<Exception> -> Void ) : Void;

    public function writeString( s : String, callback : Null<Exception> -> Void ) : Void;
    #end

}
