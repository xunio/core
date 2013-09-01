package

class Runner {

    public static function main() {
        var r = new haxe.unit.TestRunner();
        r.add(new TestStringUtils());
        r.run();
    }
}
