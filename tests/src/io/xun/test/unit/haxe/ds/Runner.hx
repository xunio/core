package io.xun.test.unit.haxe.ds;

class Runner {

    public static function main() : Bool {
        var r = new io.xun.test.TestRunner();
        r.add(new TestObjectMap());
        return r.run();
    }
}
