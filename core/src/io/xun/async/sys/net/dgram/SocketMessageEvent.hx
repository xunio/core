package io.xun.async.sys.net.dgram;

import haxe.io.BytesData;

class SocketMessageEvent implements ISocketMessageEvent
{
	private var message : BytesData;

	private var remoteInfo : RemoteInfo;

	public function new(message : BytesData, remoteInfo : RemoteInfo)
	{
		this.message = message;
		this.remoteInfo = remoteInfo;
	}

	public function getMessage() : BytesData
	{
		return message;
	}

	public function getRemoteInfo() : RemoteInfo
	{
		return remoteInfo;
	}
}
