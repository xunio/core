package io.xun.test;

class Runner {

    public static function main() : Bool {
        var result : Bool = true;
        result = result && io.xun.test.unit.Runner.main();
        return result;
    }

}
