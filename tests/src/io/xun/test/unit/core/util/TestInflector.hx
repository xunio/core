package io.xun.test.unit.core.util;

import io.xun.core.util.Inflector;

class TestInflector extends haxe.unit.TestCase {

    public function testUnderscore() {
        assertEquals('test_thing', Inflector.underscore('TestThing'));
        assertEquals('test_thing', Inflector.underscore('testThing'));
        assertEquals('test_thing_extra', Inflector.underscore('TestThingExtra'));
        assertEquals('test_thing_extra', Inflector.underscore('testThingExtra'));

        assertEquals('test_thing', Inflector.underscore('TestThing'));
        assertEquals('test_thing', Inflector.underscore('testThing'));
        assertEquals('test_thing_extra', Inflector.underscore('TestThingExtra'));
        assertEquals('test_thing_extra', Inflector.underscore('testThingExtra'));

        assertEquals('', Inflector.underscore(''));
        assertEquals('0', Inflector.underscore('0'));
    }

    public function testVariable() {
        assertEquals('testField', Inflector.variable('test_field'));
        assertEquals('testFieLd', Inflector.variable('test_fieLd'));
        assertEquals('testField', Inflector.variable('test field'));
        assertEquals('testField', Inflector.variable('Test_field'));
        assertEquals('testField', Inflector.variable('  Test_field'));
        assertEquals('testEstField', Inflector.variable('test est_field'));
    }

    public function testHumanize() {
        assertEquals('Posts', Inflector.humanize('posts'));
        assertEquals('Posts Tags', Inflector.humanize('posts_tags'));
        assertEquals('File Systems', Inflector.humanize('file_systems'));
        assertEquals(' Foo File Systems Ba ', Inflector.humanize(' foo file_systems ba '));
    }

    public function testCamelize() {
        assertEquals('Posts', Inflector.camelize('posts'));
        assertEquals('PostsTags', Inflector.camelize('posts_tags'));
        assertEquals('FileSystems', Inflector.camelize('file_systems'));
        assertEquals('FooFileSystemsBa', Inflector.camelize(' foo file_systems ba '));
    }


}
