package io.xun.core.dependencyinjection.parameterbag;

import io.xun.core.dependencyinjection.ref.Parameter;
import haxe.ds.StringMap;

class ParameterBag extends StringMap<Parameter> implements IParameterBag {

    public function clear() : Void {
        for(key in this.keys()) {
            this.remove(key);
        }
    }

    public function add( parameters : Array<Parameter> ) : Void {
        for(parameter in parameters.iterator()) {
            if(this.parameterExists(parameter)) {
                throw new InvalidParameterException("Parameter already exist");
            }
        }
        for(parameter in parameters.iterator()) {
            return this.set(parameter.key, parameter);
        }
    }

    public function isFrozen() : Bool {
        return false;
    }

    override public function set( key : String, parameter : Parameter ) : Void {
        super.set(key, parameter);
    }

    override public function get( key : String ) : Parameter {
        if(this.exists(key)) {
            return super.get(key);
        }
        throw new InvalidParameterException("Parameter does not exist");
    }

    public function parameterExists( parameter : Parameter ) : Bool {
        return this.exists(parameter.key);
    }

    override public function exists( key : String ) : Bool {
        return super.exists(key);
    }

    override public function remove( key : String ) : Bool {
        if(this.exists(key)) {
            return super.remove(key);
        }
        throw new InvalidParameterException("Parameter does not exist");
    }

    override public function keys() : Iterator<String> {
        return super.keys();
    }

    override public function iterator() : Iterator<Parameter> {
        return super.iterator();
    }

    override public function toString() : String {
        return super.toString();
    }

}
