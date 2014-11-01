package io.xun.async.sys.net;

import haxe.io.Bytes;

class SocketDataEvent implements ISocketDataEvent
{
	private var bytes : Bytes;

	public function new(bytes : Bytes)
	{
		this.bytes = bytes;
	}

	public function getBytes() : Bytes
	{
		return bytes;
	}
}
