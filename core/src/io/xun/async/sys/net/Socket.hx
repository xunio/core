package io.xun.async.sys.net;

import io.xun.async.sys.net.SocketErrorEvent;
import haxe.io.Bytes;
import haxe.io.BytesData;
import io.xun.async.sys.net.ISocket.SocketEvent;
import io.xun.core.event.Observable;
import io.xun.core.event.IObserver;
import haxe.io.BytesData;
import sys.net.Host;
import haxe.io.Error;

class Socket implements ISocket
{

	public static inline var MODE_NONBLOCKING = 0;

	private var observer : Observable;
	private var socket : sys.net.Socket;
	private var mode : Int = MODE_NONBLOCKING;

	public function new(socket : Null<sys.net.Socket> = null)
	{
		mode = getMode();
		observer = new Observable();
		if (socket == null) {
			socket = new sys.net.Socket();
		}
		this.socket = socket;
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
					var buffer : BytesData = Bytes.ofString(this.socket.read()).getData();
					observer.notify(SocketEvent.DATA, new SocketDataEvent(buffer));
				} catch (e : Dynamic) {
					switch (e) {
						case haxe.io.Error.Blocked:
							return;
						default:
							// on end
							observer.notify(SocketEvent.END, null);
							// on timeout
							observer.notify(SocketEvent.TIMEOUT, null);

							observer.notify(SocketEvent.ERROR, new SocketErrorEvent(e));
							destory();
							throw e;
					}
				}
			default:
				throw new UnsupportedSocketMode("Mode " + Std.string(mode) + " not supported");
		}
	}

	public function connect(host : Host, port : Int) : Void
	{
		try {
			this.socket.connect(host, port);
		} catch (e : Dynamic) {
			observer.notify(SocketEvent.ERROR, new SocketErrorEventt(e));
			destory();
			throw e;
		}
		this.observer.notify(SocketEvent.CONNECT, null);
	}

	public function setFastSend(fastSend : Bool) : Void
	{
		try {
			this.socket.setFastSend(fastSend);
		} catch (e : Dynamic) {
			observer.notify(SocketEvent.ERROR, new SocketErrorEventt(e));
			destory();
			throw e;
		}
	}

	public function write(data : BytesData) : Void
	{
		try {
			this.socket.write(data.toString());
		} catch (e : Dynamic) {
			observer.notify(SocketEvent.ERROR, new SocketErrorEventt(e));
			destory();
			throw e;
		}
		observer.notify(SocketEvent.DRAIN, null);
	}

	public function destory() : Void
	{
		try {
			this.socket.close();
		} catch (e : Dynamic) {
			observer.notify(SocketEvent.ERROR, new SocketErrorEventt(e));
			throw e;
		}
		observer.notify(SocketEvent.CLOSE, null);
	}

	public function setTimeout(timeout : Int) : Void
	{
		try {
			this.socket.setTimeout(timeout);
		} catch (e : Dynamic) {
			observer.notify(SocketEvent.ERROR, new SocketErrorEventt(e));
			destory();
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
