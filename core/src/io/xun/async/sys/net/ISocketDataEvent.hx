package io.xun.async.sys.net;

import haxe.io.Bytes;
import haxe.io.BytesData;

interface ISocketDataEvent
{
	public function getBytes() : Bytes;
}
