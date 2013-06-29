package io.xun.core.event;

interface IObservable
{
    public function attach(o : IObserver, mask : Null<Int> = 0) : Void;
    public function detach(o : IObserver, mask : Null<Int> = null) : Void;
}