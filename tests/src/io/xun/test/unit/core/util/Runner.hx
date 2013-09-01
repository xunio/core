package io.xun.test.unit.core.util;

class Runner {

    public static function main() : Bool {
        var r = new io.xun.test.TestRunner();
        r.add(new TestL());
        r.add(new TestStringUtils());
        r.add(new TestInflector());
        r.add(new TestBitwiseMask());
        return r.run();
    }
}
