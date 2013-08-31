package io.xun.core.dependencyinjection;

import io.xun.core.dependencyinjection.ref.Parameter;
import io.xun.core.dependencyinjection.parameterbag.FrozenParameterBag;
import io.xun.core.dependencyinjection.parameterbag.ParameterBag;
import io.xun.core.dependencyinjection.parameterbag.IParameterBag;

class ContainerBuilder {

    private var parameter : IParameterBag;

    public function new() {
        parameter = new ParameterBag();
    }

    public function setParameter(parameter : Parameter) : Void {
        this.parameter.set(parameter.key, parameter);
    }

    public function getParameter(key : String) : Parameter {
        return this.parameter.get(key);
    }

    public function freezeParameterBag() {
        if(!Std.is(parameter, FrozenParameterBag)) {
            parameter = parameter.freeze();
        }
    }

    public function register(key : String, dependency : Class<Dynamic>) : Definition {
        return new Definition();
    }



}
