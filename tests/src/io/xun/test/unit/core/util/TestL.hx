package io.xun.test.unit.core.util;

using io.xun.core.util.L.ArrayExtension;

class TestL extends haxe.unit.TestCase {

    public function testUnderscore() {

        var checksum : Int = 0;
        for(i in [1, 1, 2, 3, 4, 4, 5].unique()) {
            checksum = checksum + i;
        }
        assertEquals(15, checksum);

    }

}
