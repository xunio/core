package io.xun.test.unit.core.util;

class Runner {

    public static function main() : Bool {
        var r = new io.xun.test.TestRunner();
        r.add(new TestStringUtils());
        r.add(new TestInflector());
        return r.run();
    }
}
