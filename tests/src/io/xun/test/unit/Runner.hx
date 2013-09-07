package io.xun.test.unit;

class Runner {

    public static function main() : Bool {
        var result : Bool = true;
        result = result && io.xun.test.unit.haxe.Runner.main();
        result = result && io.xun.test.unit.core.Runner.main();
        return result;
    }
}
