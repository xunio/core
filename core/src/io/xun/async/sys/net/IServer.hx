package io.xun.async.sys.net;

import sys.net.Host;
import io.xun.core.event.ObserverMacro;
import io.xun.core.event.IObservable;

interface IServer implements IObservable
{

	public function listen(host : Host, port : Int) : Void;

	public function close() : Void;

	public function loop() : Void;

	public function getConnections() : Promise<Int>;

}

/**
 * Class ServerEvent
 *
 * @author        Maximilian Ruta <mr@xtain.net>
 * @copyright     Copyright (c) 2013 XTAIN oHG, <https://company.xtain.net>
 * @package       io.xun.async.sys.net.IServer
 */
@:build(io.xun.core.event.ObserverMacro.create([
LISTENING,
CONNECTION,
CLOSE,
ERROR
]))
class ServerEvent {
	public inline static var LISTENING;
	public inline static var CONNECTION;
	public inline static var CLOSE;
	public inline static var ERROR;
	public inline static var GROUP_ID;
	public inline static var GROUP_MASK;
	public inline static var EVENT_MASK;
}
