package io.xun.core.dependencyinjection.ref;
class Parameter implements IArgument {

    public var key(default, null) : String;
    public var value(default, null) : Dynamic;

    public function new(key : String, value : Dynamic) {
        this.key = key;
        this.value = value;
    }

}
