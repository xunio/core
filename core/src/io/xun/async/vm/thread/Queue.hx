package io.xun.async.vm.thread;

#if neko
import neko.vm.Mutex;
#elseif cpp
import cpp.vm.Mutex;
#else
#error
#end

class Queue<T>
{

    private var queue : Array<T>;
    public var length(default, null) : Int;
    public var mutex : Mutex;

    public function new()
    {
        queue = new Array<T>();
        length = 0;
        mutex = new Mutex();
    }

    public function push(data : T) : Void
    {
        mutex.acquire();
        queue.push(data);
        mutex.release();
        length++;
    }

    public function shift() : Null<T>
    {
        var value : Null<T> = null;
        mutex.acquire();
        if (queue.length > 0) {
            value = queue.shift();
        }
        mutex.release();
        length--;
        return value;
    }

    public function pop() : Null<T>
    {
        var value : Null<T> = null;
        mutex.acquire();
        if (queue.length > 0) {
            value = queue.pop();
        }
        mutex.release();
        length--;
        return value;
    }
}
