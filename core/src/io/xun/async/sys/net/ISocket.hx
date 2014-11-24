package io.xun.async.sys.net;

import haxe.io.Bytes;
import sys.net.Address;
import haxe.io.BytesData;
import io.xun.core.event.IObservable;
import io.xun.core.event.ObserverMacro;
import io.xun.async.Promise;

interface ISocket implements IObservable
{

    public function connect(address : Address) : Void;

    public function setFastSend(fastSend : Bool) : Void;

    public function write(data : Bytes) : Void;

    public function close() : Void;

    public function setTimeout(timeout : Int) : Void;

    public function loop() : Void;

}

/**
 * Class SocketEvent
 *
 * @author        Maximilian Ruta <mr@xtain.net>
 * @copyright     Copyright (c) 2013 XTAIN oHG, <https://company.xtain.net>
 * @package       io.xun.async.sys.net.ISocket
 */
@:build(io.xun.core.event.ObserverMacro.create([
CONNECT,
DATA,
END,
TIMEOUT,
DRAIN,
ERROR,
CLOSE
]))
class SocketEvent {
    public inline static var CONNECT;
    public inline static var DATA;
    public inline static var END;
    public inline static var TIMEOUT;
    public inline static var DRAIN;
    public inline static var ERROR;
    public inline static var CLOSE;
    public inline static var GROUP_ID;
    public inline static var GROUP_MASK;
    public inline static var EVENT_MASK;
}
