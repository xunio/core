package io.xun.test.unit.haxe;

class Runner {

    public static function main() : Bool {
        var result : Bool = true;
        result = result && io.xun.test.unit.haxe.ds.Runner.main();

        return result;
    }
}
