package ;

import sys.net.Address;
import sys.net.Host;
import sys.net.Address;
import io.xun.async.sys.net.dgram.ISocket.SocketEvent;
import io.xun.core.event.IObserver;
import io.xun.core.event.IObservable;
import io.xun.async.sys.net.dgram.UdpSocket;

class UdpServer implements IObserver
{

    public function onUpdate( type : Int, source : IObservable, userData : Dynamic ) : Void
    {
        trace(type);
        trace(userData);
    }

    public function new()
    {
        /*
        var socket = new sys.net.UdpSocket(4);
        var host = new Host(Host.localhost());

        socket.bind(host, 1234);

        while (true) {

            try {
                trace(socket.input.read(4));
            } catch (e:Dynamic) {
                trace("exception: " + e);
            }

        }

        */
        var s : UdpSocket = new UdpSocket();
        var a : Address = new Address();
        var h : Host = new Host("127.0.0.1");
        a.host = h.ip;
        a.port = 1234;
        s.bind(a);
        s.attach(this, SocketEvent.DATA);
        while (true) {
            trace('loop');
            s.loop();
        }
    }

    public static function test() : Void
    {
        var n : UdpServer = new UdpServer();
    }

    public static function main() : Void
    {
        #if (js && nodejs)
        new js.nodejs.Node.NodeFiber(UdpServer.test).run();
        #else
        UdpServer.test();
        #end
    }
}
