package io.xun.async.sys.net.dgram;

import sys.net.Host;
import io.xun.core.event.ObserverMacro;
import io.xun.core.event.IObservable;
import haxe.io.BytesData;

interface ISocket implements IObservable
{

	public function send(buffer : BytesData, offset : Int, length : Int, host : Host, port : Int) : Promise<BytesData>;

	public function bind(host : Host, port : Int);

	public function close();

	public function setTimeout(timeout : Int);

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
MESSAGE,
ERROR,
CLOSE
]))
class SocketEvent {
	public inline static var LISTENING;
	public inline static var MESSAGE;
	public inline static var ERROR;
	public inline static var CLOSE;
	public inline static var GROUP_ID;
	public inline static var GROUP_MASK;
	public inline static var EVENT_MASK;
}
