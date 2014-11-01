package io.xun.async.sys.net.dgram;

import haxe.io.BytesData;

interface ISocketMessageEvent
{
	public function getMessage() : BytesData;

	public function getRemoteInfo() : RemoteInfo;
}
