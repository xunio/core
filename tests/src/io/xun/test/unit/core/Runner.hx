package io.xun.test.unit.core;

class Runner {

    public static function main() : Bool {
        var result : Bool = true;
        result = result && io.xun.test.unit.core.util.Runner.main();
        result = result && io.xun.test.unit.core.event.Runner.main();

        //var r = new haxe.unit.TestRunner();
        //r.run();
        return result;
    }
}
