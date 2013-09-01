package io.xun.core.util;

class L extends Lambda {

}

class ArrayExtension {

    public static function unique<T>( x : Iterable<T> ) : Array<T> {
        var r : Array<T> = [];
        for (e in x.iterator()) {
            // you can inline exists yourself if you care much about speed.
            // But then you should consider using hash tables or such.
            if (!Lambda.has(r, e)) {
                r.push(e);
            }
        }
        return r;
    }


}
