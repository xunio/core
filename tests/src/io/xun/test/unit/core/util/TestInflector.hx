package io.xun.test.unit.core.util;

import io.xun.core.util.Inflector;

class TestInflector extends haxe.unit.TestCase {

    public function testUnderscore() {
        assertEquals(Inflector.underscore('TestThing'), 'test_thing');
        assertEquals(Inflector.underscore('testThing'), 'test_thing');
        assertEquals(Inflector.underscore('TestThingExtra'), 'test_thing_extra');
        assertEquals(Inflector.underscore('testThingExtra'), 'test_thing_extra');

        assertEquals(Inflector.underscore('TestThing'), 'test_thing');
        assertEquals(Inflector.underscore('testThing'), 'test_thing');
        assertEquals(Inflector.underscore('TestThingExtra'), 'test_thing_extra');
        assertEquals(Inflector.underscore('testThingExtra'), 'test_thing_extra');

        assertEquals(Inflector.underscore(''), '');
        assertEquals(Inflector.underscore('0'), '0');
    }

    public function testVariable() {
        assertEquals(Inflector.variable('test_field'), 'testField');
        assertEquals(Inflector.variable('test_fieLd'), 'testFieLd');
        assertEquals(Inflector.variable('test field'), 'testField');
        assertEquals(Inflector.variable('Test_field'), 'testField');
    }

    public function testHumanize() {
        assertEquals(Inflector.humanize('posts'), 'Posts');
        assertEquals(Inflector.humanize('posts_tags'), 'Posts Tags');
        assertEquals(Inflector.humanize('file_systems'), 'File Systems');
        assertEquals(Inflector.humanize(' foo file_systems ba '), ' Foo File Systems Ba ');
    }


}
