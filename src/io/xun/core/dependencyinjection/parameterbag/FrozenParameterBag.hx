package io.xun.core.dependencyinjection.parameterbag;

import io.xun.core.dependencyinjection.parameterbag.exception.FrozenParameterBagException;
import io.xun.core.dependencyinjection.ref.Parameter;
import haxe.ds.StringMap;

class FrozenParameterBag extends ParameterBag {

    public function new( bag : IParameterBag ) {
        super();
        for(parameter in bag.iterator()) {
            super.set(parameter.key,  parameter);
        }
    }

    override public function isFrozen() : Bool {
        return true;
    }

    override public function clear() : Void {
        throw new FrozenParameterBagException("Impossible to call clear() on a frozen ParameterBag.");
    }

    override public function add( parameters : Array<Parameter> ) : Void {
        throw new FrozenParameterBagException("Impossible to call add() on a frozen ParameterBag");
    }

    override public function set( key : String, parameter : Parameter ) : Void {
        throw new FrozenParameterBagException("Impossible to call set() on a frozen ParameterBag");
    }

    override public function remove( key : String ) : Bool {
        throw new FrozenParameterBagException("Impossible to call remove() on a frozen ParameterBag");
        return false;
    }

}
