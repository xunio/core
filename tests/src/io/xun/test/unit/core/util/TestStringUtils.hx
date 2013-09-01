package io.xun.test.unit.core.util;

import io.xun.core.util.StringUtils;

class TestStringUtils extends haxe.unit.TestCase {

    public function testUpperCaseWords() {
        assertEquals(StringUtils.upperCaseWords('test test ddasd adsad'), 'Test Test Ddasd Adsad');
        assertEquals(StringUtils.upperCaseWords(' test test ddasd adsad '), ' Test Test Ddasd Adsad ');
        assertEquals(StringUtils.upperCaseWords(' test 5test 7ddasd adsad '), ' Test 5test 7ddasd Adsad ');
        assertEquals(StringUtils.upperCaseWords('test 5test'), 'Test 5test');
        assertEquals(StringUtils.upperCaseWords('Test 5test'), 'Test 5test');
        assertEquals(StringUtils.upperCaseWords('5test'), '5test');
    }

}
