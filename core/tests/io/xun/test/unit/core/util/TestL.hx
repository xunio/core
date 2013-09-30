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
            assertEquals('targetPos is higher than gratest index of target', e.getMessage());
            return;
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
            assertEquals('source fewer items that sould be copied', e.getMessage());
            return;
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

}
