package io.xun.core.dependencyinjection;

import io.xun.core.dependencyinjection.ref.IArgument;
import io.xun.core.exception.Exception;

class Definition
{

    private var arguments : List<IArgument>;

    public function new() {
        arguments = new List<IArgument>();
    }

    public function addArgument(argument : IArgument) : Void {
        arguments.add(argument);
    }

}
