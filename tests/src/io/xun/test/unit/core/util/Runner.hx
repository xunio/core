package io.xun.test.unit.core.util;

class Runner {

    public static function main() {
        var r = new haxe.unit.TestRunner();
        r.add(new TestStringUtils());
        r.add(new TestInflector());
        r.run();
    }
}
