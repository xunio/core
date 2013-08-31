package io.xun.core.dependencyinjection.parameterbag;

import io.xun.core.dependencyinjection.ref.Parameter;
import haxe.ds.StringMap;

class FrozenParameterBag extends ParameterBag {

    public function new( bag : ParameterBag ) {
        super();
        for (parameter in bag.iterator()) {
            super.set(parameter.key,  parameter);
        }
    }

    override public function freeze() : FrozenParameterBag {
        throw new FrozenParameterBagException("ParameterBag is frozen");
        return this;
    }

    override public function clear() : Void {
        throw new FrozenParameterBagException("ParameterBag is frozen");
    }

    override public function add( parameters : Array<Parameter> ) : Void {
        throw new FrozenParameterBagException("ParameterBag is frozen");
    }

    override public function set( key : String, parameter : Parameter ) : Void {
        throw new FrozenParameterBagException("ParameterBag is frozen");
    }

    override public function remove( key : String ) : Bool {
        throw new FrozenParameterBagException("ParameterBag is frozen");
        return false;
    }

}
