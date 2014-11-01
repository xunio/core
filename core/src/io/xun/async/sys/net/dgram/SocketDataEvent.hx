package io.xun.async.sys.net.dgram;

import haxe.io.Bytes;
import sys.net.Address;
import haxe.io.BytesData;

class SocketDataEvent implements ISocketMessageEvent
{
	private var data : Bytes;

	private var length : Int;

	private var address : Address;

	public function new(data : Bytes, length : Int, address : Address)
	{
		this.data = data;
		this.length = length;
		this.address = address;
	}

	public function getLength() : Int
	{
		return length;
	}

	public function getData() : Bytes
	{
		return data;
	}

	public function getAddress() : Address
	{
		return address;
	}
}
