/*
 * xun.io
 * Copyright (c) 2013 XTAIN oHG, <https://company.xtain.net>
 *
 * Licensed under GNU Affero General Public License
 * For full copyright and license information, please see the LICENSE
 * Redistributions of files must retain the above copyright notice.
 *
 * @copyright     Copyright (c) 2013 XTAIN oHG, <https://company.xtain.net>
 * @link          http://xun.io/ xun.io Project
 * @package       io.xun.test.unit.core.util
 * @license       http://www.gnu.org/licenses/agpl-3.0.html GNU Affero General Public License
 */

package io.xun.test.unit.core.util;

/* imports and uses */

import io.xun.core.exception.OutOfBoundsException;
using Lambda;
using io.xun.core.util.L;
using io.xun.core.util.L.ArrayExtension;

/**
 * Class TestL
 *
 * @author        Maximilian Ruta <mr@xtain.net>
 * @copyright     Copyright (c) 2013 XTAIN oHG, <https://company.xtain.net>
 * @package       io.xun.test.unit.core.util
 */
class TestL extends haxe.unit.TestCase {

    public function testUnique() {

        var checksum : Int = 0;
        for(i in [1, 1, 2, 3, 4, 4, 5].unique()) {
            checksum = checksum + i;
        }
        assertEquals(15, checksum);

    }

    public function testCopyTo() {
        var arr1 : Array<Int> = [1, 2, 3, 4, 5];
        var arr2 : Array<Int> = [10, 20, 30, 40, 50];

        arr1.copyTo(arr2, 3);

        assertEquals(1, arr1[0]);
        assertEquals(2, arr1[1]);
        assertEquals(3, arr1[2]);
        assertEquals(4, arr1[3]);
        assertEquals(5, arr1[4]);

        assertEquals(1, arr2[0]);
        assertEquals(2, arr2[1]);
        assertEquals(3, arr2[2]);
        assertEquals(40, arr2[3]);
        assertEquals(50, arr2[4]);
    }

    public function testCopyToOverCopy() {
        var arr1 : Array<Int> = [1, 2, 3, 4, 5];
        var arr2 : Array<Int> = [10, 20, 30, 40, 50];

        try {
            arr1.copyTo(arr2, 3, 0, 6);
            assertTrue(false);
        } catch(e : OutOfBoundsException) {
            assertEquals('targetPos is higher than gratest index of target', e.message);
            return;
        } catch(e : Dynamic) {
            assertTrue(false);
        }
        assertTrue(false);
    }

    public function testCopyToOverCopySource() {
        var arr1 : Array<Int> = [1, 2, 3, 4, 5];
        var arr2 : Array<Int> = [10, 20, 30, 40, 50];

        try {
            arr1.copyTo(arr2, 6, 0, 6);
            assertTrue(false);
        } catch(e : OutOfBoundsException) {
            assertEquals('source fewer items that sould be copied', e.message);
            return;
        } catch(e : Dynamic) {
            assertTrue(false);
        }
        assertTrue(false);
    }

    public function testCopyToPosition() {
        var arr1 : Array<Int> = [1, 2, 3, 4, 5];
        var arr2 : Array<Int> = [10, 20, 30, 40, 50];

        arr1.copyTo(arr2, 3, 0, 2);

        assertEquals(1, arr1[0]);
        assertEquals(2, arr1[1]);
        assertEquals(3, arr1[2]);
        assertEquals(4, arr1[3]);
        assertEquals(5, arr1[4]);

        assertEquals(10, arr2[0]);
        assertEquals(20, arr2[1]);
        assertEquals(1, arr2[2]);
        assertEquals(2, arr2[3]);
        assertEquals(3, arr2[4]);
    }

    public function testCopyToPositionOverlap() {
        var arr1 : Array<Int> = [1, 2, 3, 4, 5];
        var arr2 : Array<Int> = [10, 20, 30, 40, 50];

        arr1.copyTo(arr2, 4, 0, 2);

        assertEquals(1, arr1[0]);
        assertEquals(2, arr1[1]);
        assertEquals(3, arr1[2]);
        assertEquals(4, arr1[3]);
        assertEquals(5, arr1[4]);

        assertEquals(10, arr2[0]);
        assertEquals(20, arr2[1]);
        assertEquals(1, arr2[2]);
        assertEquals(2, arr2[3]);
        assertEquals(3, arr2[4]);
        assertEquals(4, arr2[5]);
    }

    public function testCopyToPositionEnd() {
        var arr1 : Array<Int> = [1, 2, 3, 4, 5];
        var arr2 : Array<Int> = [10, 20, 30, 40, 50];

        arr1.copyTo(arr2, 2, 2, 5);

        assertEquals(1, arr1[0]);
        assertEquals(2, arr1[1]);
        assertEquals(3, arr1[2]);
        assertEquals(4, arr1[3]);
        assertEquals(5, arr1[4]);

        assertEquals(10, arr2[0]);
        assertEquals(20, arr2[1]);
        assertEquals(30, arr2[2]);
        assertEquals(40, arr2[3]);
        assertEquals(50, arr2[4]);
        assertEquals(3, arr2[5]);
        assertEquals(4, arr2[6]);
    }

    public function testFlatten() {
        var arr : Array<Array<Int>> = [
            [10, 11, 12, 13, 14],
            [15, 16],
            [17, 18, 19]
        ];

        var result : Array<Int> = arr.flatten();
        assertEquals(10, result[0]);
        assertEquals(11, result[1]);
        assertEquals(12, result[2]);
        assertEquals(13, result[3]);
        assertEquals(14, result[4]);
        assertEquals(15, result[5]);
        assertEquals(16, result[6]);
        assertEquals(17, result[7]);
        assertEquals(18, result[8]);
        assertEquals(19, result[9]);
    }

    public function testDiff() {
        var arr1 : Array<Int> = [1, 2, 3, 4, 10, 13, 15, 20, 21];
        var arr2 : Array<Int> = [
            10, 11, 12, 13, 14, 15, 16, 17, 18, 19
        ];

        arr1 = arr1.iterator().diff(arr2);
        assertEquals(6, arr1.length);
        assertTrue(Lambda.has(arr1, 1));
        assertTrue(Lambda.has(arr1, 2));
        assertTrue(Lambda.has(arr1, 3));
        assertTrue(Lambda.has(arr1, 4));
        assertTrue(Lambda.has(arr1, 20));
        assertTrue(Lambda.has(arr1, 21));
    }

    public function testAppend() {
        var arr1 : Map<String, String> = [
            "test1" => "foo1",
            "test2" => "foo2",
            "test3" => "foo3"
        ];
        var arr2 : Map<String, String> = [
            "test0" => "baa0",
            "test1" => "baa1",
            "test2" => "baa2",
            "test4" => "baa4",
            "test5" => "baa5"
        ];

        arr1.append(arr2);
        assertEquals(6, arr1.keys().fromIterator().length);
        assertEquals('baa0', arr1.get('test0'));
        assertEquals('foo1', arr1.get('test1'));
        assertEquals('foo2', arr1.get('test2'));
        assertEquals('foo3', arr1.get('test3'));
        assertEquals('baa4', arr1.get('test4'));
        assertEquals('baa5', arr1.get('test5'));
    }

    public function testToMap() {
        var d : {
        test1 : String,
        test2 : String
        } = {
        test1 : 'foo1',
        test2 : 'foo2'
        };

        var m : Map<String, Dynamic> = L.toMap(d);

        assertEquals('foo1', m.get('test1'));
        assertEquals('foo2', m.get('test2'));
    }

}
