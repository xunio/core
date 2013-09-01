package io.xun.test.unit.core.util;

import io.xun.core.util.BitwiseMask;

class TestBitwiseMask extends haxe.unit.TestCase {

    public function testToString() {
        var mask : BitwiseMask = new BitwiseMask();

        mask.set(0);
        assertEquals('0', mask.toString());
        mask.set(13);
        assertEquals('1011', mask.toString());
    }

    public function testCheck() {
        var mask : BitwiseMask = new BitwiseMask();

        mask.set(13);
        assertFalse(mask.check(2));
        assertFalse(mask.check(15));
        assertTrue(mask.check(8));
        assertTrue(mask.check(12));
    }

    public function testIsZero() {
        var mask : BitwiseMask = new BitwiseMask();
        assertTrue(mask.isZero());
    }

    public function testReset() {
        var mask : BitwiseMask = new BitwiseMask();
        assertTrue(mask.isZero());
        mask.set(13);
        assertTrue(mask.check(13));
        mask.reset();
        assertTrue(mask.isZero());
    }

    public function testUnset() {
        var mask : BitwiseMask = new BitwiseMask();

        mask.set(13);
        assertTrue(mask.check(13));
        assertTrue(mask.check(1));
        assertTrue(mask.check(4));
        assertTrue(mask.check(8));
        assertEquals('1011', mask.toString());

        mask.unset(1);
        assertTrue(mask.check(12));
        assertTrue(mask.check(4));
        assertTrue(mask.check(8));
        assertEquals('0011', mask.toString());

        mask.unset(12);
        assertFalse(mask.check(1));
        assertTrue(mask.check(0));
        assertEquals('0', mask.toString());

    }

    public function testGet() {
        var mask : BitwiseMask = new BitwiseMask();

        mask.set(13);
        assertEquals(mask.get(), 13);

        mask.unset(1);
        assertEquals(mask.get(), 12);
    }

}

