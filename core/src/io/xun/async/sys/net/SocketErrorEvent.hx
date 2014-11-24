package io.xun.async.sys.net;

class SocketErrorEvent implements ISocketErrorEvent
{

    private var error : Dynamic;

    public function new(error : Dynamic)
    {
        this.error = error;
    }

    public function getError()
    {
        return this.error;
    }

}
