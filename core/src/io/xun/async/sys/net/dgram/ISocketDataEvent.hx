package io.xun.async.sys.net.dgram;

import haxe.io.Bytes;
import sys.net.Address;
import haxe.io.BytesData;

interface ISocketDataEvent
{
    public function getData() : Bytes;

    public function getAddress() : Address;
}
