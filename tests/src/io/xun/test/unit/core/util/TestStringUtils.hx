package io.xun.test.unit.core.util;

import io.xun.core.util.StringUtils;

class TestStringUtils extends haxe.unit.TestCase {

    public function testUpperCaseWords() {
        assertEquals('Test Test Ddasd Adsad', StringUtils.upperCaseWords('test test ddasd adsad'));
        assertEquals(' Test Test Ddasd Adsad ', StringUtils.upperCaseWords(' test test ddasd adsad '));
        assertEquals(' Test 5test 7ddasd Adsad ', StringUtils.upperCaseWords(' test 5test 7ddasd adsad '));
        assertEquals('Test 5test', StringUtils.upperCaseWords('test 5test'));
        assertEquals('Test 5test', StringUtils.upperCaseWords('Test 5test'));
        assertEquals('5test', StringUtils.upperCaseWords('5test'));
    }

}
