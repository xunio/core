package io.xun.async.sys.net;

class SocketConnectionEvent implements IServerConnectionEvent
{
    private var socket : ISocket;

    public function new(socket : ISocket)
    {
        this.socket = socket;
    }

    public function getSocket() : ISocket
    {
        return socket;
    }
}
