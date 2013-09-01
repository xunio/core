package io.xun.test.unit.core.event;

class Runner {

    public static function main() : Bool {
        var r = new io.xun.test.TestRunner();
        r.add(new TestObservable());
        return r.run();
    }
}
