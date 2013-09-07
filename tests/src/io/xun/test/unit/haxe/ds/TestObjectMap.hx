package io.xun.test.unit.haxe.ds;

import haxe.ds.ObjectMap;

class TestObjectMap extends haxe.unit.TestCase {

    public function testMapping() {
        var map : ObjectMap<TestObjectMapDummyParent, Int> = new ObjectMap<TestObjectMapDummyParent, Int>();
        var instance1 : TestObjectMapDummyOne = new TestObjectMapDummyOne();
        var instance2 : TestObjectMapDummyTwo = new TestObjectMapDummyTwo();

        assertFalse(map.exists(instance1));
        assertFalse(map.exists(instance2));

        map.set(instance1, 1);
        assertTrue(map.exists(instance1));
        assertEquals(1, map.get(instance1));

        map.set(instance2, 2);
        assertTrue(map.exists(instance2));
        assertEquals(2, map.get(instance2));

        map.remove(instance1);
        assertFalse(map.exists(instance1));
        assertTrue(map.exists(instance2));

        map.remove(instance2);
        assertFalse(map.exists(instance1));
        assertFalse(map.exists(instance2));
    }

    public function testMappingKeys() {
        var map : ObjectMap<TestObjectMapDummyParent, Int> = new ObjectMap<TestObjectMapDummyParent, Int>();
        var instance1 : TestObjectMapDummyOne = new TestObjectMapDummyOne();
        var instance2 : TestObjectMapDummyTwo = new TestObjectMapDummyTwo();

        map.set(instance1, 44);
        map.set(instance2, 44);

        for(obj in map.keys()) {
            var res : Null<Int> = map.get(obj);
            assertEquals(44, res);
        }
    }

}

class TestObjectMapDummyParent {}

class TestObjectMapDummyOne extends TestObjectMapDummyParent {

    public function new() {

    }

}

class TestObjectMapDummyTwo extends TestObjectMapDummyParent {

    public function new() {

    }
}