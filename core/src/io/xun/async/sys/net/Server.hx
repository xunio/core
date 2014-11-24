package io.xun.async.sys.net;

import sys.net.Address;
import io.xun.async.sys.net.ISocket.SocketEvent;
import io.xun.async.sys.net.Socket;
import io.xun.async.sys.net.IServer.ServerEvent;
import io.xun.core.event.Observable;
import io.xun.core.event.IObservable;
import io.xun.core.event.IObserver;
import sys.net.Host;
import haxe.io.Error;
import io.xun.async.Promise;

class Server implements IServer implements IObserver
{

    public static inline var MODE_NONBLOCKING = 0;

    private var observer : Observable;
    private var socket : sys.net.Socket;
    private var open : Bool = true;
    private var mode : Int = MODE_NONBLOCKING;
    private var clients : Array<sys.net.Socket> = [];

    public function new()
    {
        mode = getMode();
        observer = new Observable(this);
        socket = new Socket();
        switch (mode) {
            case MODE_NONBLOCKING:
                socket.setBlocking(false);
            default:
                throw new UnsupportedSocketMode("Mode " + Std.string(mode) + " not supported");
        }
    }

    private function removeClient(client : Socket)
    {
        client.detach(this);
        clients.remove(client);
    }

    public function onUpdate(type : Int, source : IObservable, userData : Dynamic) : Void
    {
        switch (type) {
            case SocketEvent.CLOSE:
                removeClient(cast source);
        }
    }

    public function getConnections() : Promise<Int>
    {
        var p : Promise<Int> = new Promise<Int>();
        p.resolve(clients.length);
        return p;
    }

    public function loop() : Void
    {
        switch (mode) {
            case MODE_NONBLOCKING:
                try {
                    var client : Socket = new Socket(socket.accept());
                    clients.push(client);
                    client.attach(this, SocketEvent.CLOSE);
                    observer.notify(ServerEvent.CONNECTION, new SocketConnectionEvent(client));
                } catch (e : Dynamic) {
                    switch (e) {
                        case haxe.io.Error.Blocked:
                            return;
                        default:
                            observer.notify(ServerEvent.ERROR, new ServerErrorEvent(e));
                            throw e;
                    }
                }
            default:
                throw new UnsupportedSocketMode("Mode " + Std.string(mode) + " not supported");
        }
    }

    public function listen(address : Address) : Void
    {
        try {
            socket.bind(address.getHost().toString(), address.port);
            socket.listen(1);
            observer.notify(ServerEvent.LISTENING, null);
        } catch (e : Dynamic) {
            observer.notify(ServerEvent.ERROR, new ServerErrorEvent(e));
            throw e;
        }
    }

    public function close() : Void
    {
        try {
            for (client in clients) {
                client.close();
            }
            socket.close();
            open = false;
            observer.notify(ServerEvent.CLOSE, null);
        } catch (e : Dynamic) {
            observer.notify(ServerEvent.ERROR, new ServerErrorEvent(e));
            throw e;
        }
    }

    public function attach(o : IObserver, mask : Null<Int>) : Void
    {
        observer.attach(o, mask);
    }

    public function detach(o : IObserver, mask : Null<Int>) : Void
    {
        observer.detach(o, mask);
    }

    public static function getMode() : Int
    {
        return MODE_NONBLOCKING;
    }
}
