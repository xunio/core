package io.xun.async.sys.net.dgram;

import io.xun.async.sys.net.dgram.ISocket.SocketEvent;
import sys.net.Address;
import haxe.io.Bytes;
import io.xun.core.event.Observable;
import io.xun.core.event.IObserver;
import sys.net.Host;
import haxe.io.BytesData;
import io.xun.async.Promise;
import haxe.io.Error;

class UdpSocket implements ISocket
{

    public static inline var MODE_NONBLOCKING = 0;
    public static inline var DEFAULT_MTU = 65507;

    private var observer : Observable;
    private var socket : sys.net.UdpSocket;
    private var mode : Int = MODE_NONBLOCKING;
    private var mtu : Int = DEFAULT_MTU;

    public function new(mtu : Int = DEFAULT_MTU)
    {
        mode = getMode();
        this.mtu = mtu;
        observer = new Observable(this);
        socket = new sys.net.UdpSocket();
        switch (mode) {
            case MODE_NONBLOCKING:
                this.socket.setBlocking(false);
            default:
                throw new UnsupportedSocketMode("Mode " + Std.string(mode) + " not supported");
        }
    }

    public function loop() : Void
    {
        switch (mode) {
            case MODE_NONBLOCKING:
                try {
                    var buffer : Bytes = Bytes.alloc(mtu);
                    var addr : Address = new Address();
                    var length : Int = this.socket.readFrom(buffer, 0, buffer.length, addr);
                    observer.notify(SocketEvent.DATA, new SocketDataEvent(buffer, length, addr));
                } catch (e : Dynamic) {
                    switch (e) {
                        case haxe.io.Error.Blocked:
                            return;
                        default:
                            observer.notify(SocketEvent.ERROR, new SocketErrorEvent(e));
                            close();
                            throw e;
                    }
                }
            default:
                throw new UnsupportedSocketMode("Mode " + Std.string(mode) + " not supported");
        }
    }

    public function send(buffer : Bytes, offset : Int, length : Int, address : Address) : Promise<Int>
    {
        var p : Promise<Int> = new Promise<Int>();
        try {
            p.resolve(socket.sendTo(buffer, offset, length, address))
        } catch (e : Dynamic) {
            p.reject(e);
        }
        return p;
    }

    public function bind(address : Address) : Void
    {
        socket.bind(address.getHost().toString(), address.port);
        observer.notify(SocketEvent.LISTENING, null);
    }

    public function close() : Void
    {
        socket.close();
        observer.notify(SocketEvent.CLOSE, null);
    }

    public function setTimeout(timeout : Int) : Void
    {
        socket.setTimeout(timeout);
    }

    public function attach(o : IObserver, mask : Null<Int>) : Void
    {
        observer.attach(0, mask);
    }

    public function detach(o : IObserver, mask : Null<Int>) : Void
    {
        observer.detach(0, mask);
    }

    public static function getMode() : Int
    {
        return MODE_NONBLOCKING;
    }

}
