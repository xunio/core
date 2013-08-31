package io.xun.core.dependencyinjection.parameterbag;

import io.xun.core.dependencyinjection.ref.Parameter;

interface IParameterBag {

    public function clear() : Void;

    public function add( parameters : Array<Parameter> ) : Void;

    public function freeze() : FrozenParameterBag;

    public function set( key : String, parameter : Parameter ) : Void;

    public function get( key : String ) : Parameter;

    public function parameterExists( parameter : Parameter ) : Bool;

    public function exists( key : String ) : Bool;

    public function remove( key : String ) : Bool;

    public function keys() : Iterator<String>;

    public function iterator() : Iterator<Parameter>;

}
