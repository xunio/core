package io.xun.async.sys.net;

import haxe.io.BytesData;
class SocketDataEvent implements ISocketDataEvent
{
	private var data : BytesData;

	public function new(data : BytesData)
	{
		this.data = data;
	}

	public function getData() : BytesData
	{
		return data;
	}
}
