package io.xun.async.sys.net.dgram;

#if neko
import io.xun.async.vm.thread.Queue;
import neko.vm.Thread;
import neko.vm.Deque;
import neko.vm.Mutex;
#elseif cpp
import io.xun.async.vm.thread.Queue;
import cpp.vm.Thread;
import cpp.vm.Deque;
import cpp.vm.Mutex;
#end

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
    public static inline var MODE_THREAD = 1;
    public static inline var DEFAULT_MTU = 65507;

    private var observer : Observable;
    private var socket : sys.net.UdpSocket;
    private var mode : Int = MODE_NONBLOCKING;
    private var mtu : Int = DEFAULT_MTU;
    #if (neko || cpp)
    private var thread : Thread;
    private var dataQueue : Queue<ISocketDataEvent>;
    private var errorQueue : Queue<ISocketErrorEvent>;
    #end

    public function new(mtu : Int = DEFAULT_MTU)
    {
        mode = getMode();
        this.mtu = mtu;
        observer = new Observable(this);
        socket = new sys.net.UdpSocket();
        switch (mode) {
            case MODE_NONBLOCKING:
                this.socket.setBlocking(false);
            #if (neko || cpp)
            case MODE_THREAD:
                this.socket.setBlocking(true);
                dataQueue = new Queue<ISocketDataEvent>();
                errorQueue = new Queue<ISocketErrorEvent>();
                thread = Thread.create(threadLoop);
                thread.sendMessage(Thread.current());
                thread.sendMessage(socket);
                thread.sendMessage(dataQueue);
                thread.sendMessage(errorQueue);
                thread.sendMessage(mtu);
            #end
            default:
                throw new UnsupportedSocketMode("Mode " + Std.string(mode) + " not supported");
        }
    }

    #if (neko || cpp)
    private static function threadLoop() : Void
    {
        var main : Thread = Thread.readMessage(true);
        var socket : sys.net.UdpSocket = Thread.readMessage(true);
        var dataQueue : Queue<ISocketDataEvent> = Thread.readMessage(true);
        var errorQueue : Queue<ISocketErrorEvent> = Thread.readMessage(true);
        var mtu : Int = Thread.readMessage(true);
        while (true) {
            try {
                var buffer : Bytes = Bytes.alloc(mtu);
                var addr : Address = new Address();
                //var length : Int = socket.readFrom(buffer, 0, buffer.length, addr);
                var length : Int = socket.input.readBytes(buffer, 0, buffer.length);
                dataQueue.push(new SocketDataEvent(buffer, length, addr));
            } catch (e : Dynamic) {
                switch (e) {
                    default:
                        errorQueue.push(new SocketErrorEvent(e));
                        throw e;
                }
            }
        }
    }
    #end

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
            #if (neko || cpp)
            case MODE_THREAD:
                while (dataQueue.length > 0) {
                    var data : ISocketDataEvent = dataQueue.shift();
                    observer.notify(SocketEvent.DATA, data);
                }
                while (errorQueue.length > 0) {
                    var error : ISocketErrorEvent = errorQueue.pop();
                    observer.notify(SocketEvent.ERROR, error);
                    close();
                    throw error.getError();
                }
            #end
            default:
                throw new UnsupportedSocketMode("Mode " + Std.string(mode) + " not supported");
        }
    }

    public function send(buffer : Bytes, offset : Int, length : Int, address : Address) : Promise<Int>
    {
        var p : Promise<Int> = new Promise<Int>();
        try {
            p.resolve(socket.sendTo(buffer, offset, length, address));
        } catch (e : Dynamic) {
            p.reject(e);
        }
        return p;
    }

    public function bind(address : Address) : Void
    {
        socket.bind(address.getHost(), address.port);
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

    public function attach(o : IObserver, mask : Null<Int> = null) : Void
    {
        observer.attach(o, mask);
    }

    public function detach(o : IObserver, mask : Null<Int> = null) : Void
    {
        observer.detach(o, mask);
    }

    public static function getMode() : Int
    {
        #if (neko || cpp)
        return MODE_THREAD;
        #else
        return MODE_NONBLOCKING;
        #end
    }

}
