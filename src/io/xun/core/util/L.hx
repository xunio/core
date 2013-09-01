package io.xun.core.util;

class L extends Lambda {

    static public function unique<T>( x : Iterable<T> ) : Array<T> {
        var r = [];
        for (e in x.iterator()) {
            // you can inline exists yourself if you care much about speed.
            // But then you should consider using hash tables or such.
            if (!this.has(r.iterator(), e)) {
                r.push(e);
            }
        }
        return r;
    }

}
