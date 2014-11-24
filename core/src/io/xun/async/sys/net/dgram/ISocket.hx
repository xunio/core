package io.xun.async.sys.net.dgram;

import haxe.io.Bytes;
import sys.net.Address;
import io.xun.core.event.ObserverMacro;
import io.xun.core.event.IObservable;
import haxe.io.BytesData;
import io.xun.async.Promise;

interface ISocket implements IObservable
{

    public function loop() : Void;

    public function send(buffer : Bytes, offset : Int, length : Int, address : Address) : Promise<Int>;

    public function bind(address : Address) : Void;

    public function close() : Void;

    public function setTimeout(timeout : Int) : Void;

}


/**
 * Class SocketEvent
 *
 * @author        Maximilian Ruta <mr@xtain.net>
 * @copyright     Copyright (c) 2013 XTAIN oHG, <https://company.xtain.net>
 * @package       io.xun.async.sys.net.dgram.ISocket
 */
@:build(io.xun.core.event.ObserverMacro.create([
LISTENING,
DATA,
ERROR,
CLOSE
]))
class SocketEvent {
    public inline static var LISTENING;
    public inline static var DATA;
    public inline static var ERROR;
    public inline static var CLOSE;
    public inline static var GROUP_ID;
    public inline static var GROUP_MASK;
    public inline static var EVENT_MASK;
}
