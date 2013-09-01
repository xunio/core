package io.xun.core.dependencyinjection.parameterbag;

import io.xun.core.dependencyinjection.ref.Parameter;
import io.xun.core.dependencyinjection.parameterbag.exception.InvalidArgumentException;
import haxe.ds.StringMap;

class ParameterBag implements IParameterBag {

    var stringMap : StringMap<Parameter>;

    public function new() : Void {
        stringMap = new StringMap<Parameter>();
    }

    public function clear() : Void {
        for(key in this.keys()) {
            stringMap.remove(key);
        }
    }

    public function add( parameters : Array<Parameter> ) : Void {
        for(parameter in parameters.iterator()) {
            if (this.parameterExists(parameter)) {
                throw new InvalidArgumentException("Parameter already exist");
            }
        }
        for(parameter in parameters.iterator()) {
            return this.set(parameter.key, parameter);
        }
    }

    public function isFrozen() : Bool {
        return false;
    }

    public function set( key : String, parameter : Parameter ) : Void {
        stringMap.set(key, parameter);
    }

    public function get( key : String ) : Parameter {
        if (stringMap.exists(key)) {
            return stringMap.get(key);
        }
        throw new InvalidArgumentException("Parameter does not exist");
    }

    public function parameterExists( parameter : Parameter ) : Bool {
        return stringMap.exists(parameter.key);
    }

    public function exists( key : String ) : Bool {
        return stringMap.exists(key);
    }

    public function remove( key : String ) : Bool {
        if (this.exists(key)) {
            return stringMap.remove(key);
        }
        throw new InvalidArgumentException("Parameter does not exist");
    }

    public function keys() : Iterator<String> {
        return stringMap.keys();
    }

    public function iterator() : Iterator<Parameter> {
        return stringMap.iterator();
    }

    public function toString() : String {
        return stringMap.toString();
    }

}
