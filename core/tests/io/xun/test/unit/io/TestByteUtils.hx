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
 * @package       io.xun.test.unit.io
 * @license       http://www.gnu.org/licenses/agpl-3.0.html GNU Affero General Public License
 */

package io.xun.test.unit.io;

import io.xun.core.exception.OutOfBoundsException;
import haxe.io.Bytes;
using io.xun.io.ByteUtils;

/**
 * Class TestByteUtils
 *
 * @author        Maximilian Ruta <mr@xtain.net>
 * @copyright     Copyright (c) 2013 XTAIN oHG, <https://company.xtain.net>
 * @package       io.xun.test.unit.io
 */
class TestByteUtils extends haxe.unit.TestCase {

    public function testLtrim() {
        var source : Bytes;

        source = Bytes.ofString('123456');
        source.set(0, 0);
        source.set(1, 0);
        source.set(2, 0);

        assertEquals('343536', source.ltrim().toHex());

        source = Bytes.ofString('123456');
        source.set(0, 0);
        source.set(1, 0);
        source.set(2, 0);
        source.set(4, 0);

        assertEquals('340036', source.ltrim().toHex());

        source = Bytes.ofString('123456');
        source.set(0, 0);
        source.set(1, 0);
        source.set(2, 0);
        source.set(5, 0);

        assertEquals('343500', source.ltrim().toHex());

        source = Bytes.ofString('123456');
        source.set(0, 0);
        source.set(1, 0);
        source.set(2, 0);
        source.set(4, 0);
        source.set(5, 0);

        assertEquals('340000', source.ltrim().toHex());

        source = Bytes.ofString('123456');
        source.set(0, 0);
        source.set(1, 1);
        source.set(2, 0);
        source.set(4, 0);
        source.set(5, 0);

        assertEquals('340000', source.ltrim([0, 1]).toHex());
    }

    public function testRtrim() {
        var source : Bytes;

        source = Bytes.ofString('123456');
        source.set(5, 0);
        source.set(4, 0);
        source.set(3, 0);

        assertEquals('313233', source.rtrim().toHex());

        source = Bytes.ofString('123456');
        source.set(5, 0);
        source.set(4, 0);
        source.set(3, 0);
        source.set(1, 0);

        assertEquals('310033', source.rtrim().toHex());

        source = Bytes.ofString('123456');
        source.set(5, 0);
        source.set(4, 0);
        source.set(3, 0);
        source.set(0, 0);

        assertEquals('003233', source.rtrim().toHex());

        source = Bytes.ofString('123456');
        source.set(5, 0);
        source.set(4, 0);
        source.set(3, 0);
        source.set(1, 0);
        source.set(0, 0);

        assertEquals('000033', source.rtrim().toHex());

        source = Bytes.ofString('123456');
        source.set(5, 0);
        source.set(4, 1);
        source.set(3, 0);
        source.set(1, 0);
        source.set(0, 0);

        assertEquals('000033', source.rtrim([0, 1]).toHex());
    }

    public function testTrim() {
        var source : Bytes;

        source = Bytes.ofString('123456');
        source.set(5, 0);
        source.set(4, 0);
        source.set(1, 0);
        source.set(0, 0);

        assertEquals('3334', source.trim().toHex());

        source = Bytes.ofString('123456789');
        source.set(0, 0);
        source.set(1, 0);
        source.set(8, 0);
        source.set(7, 0);
        source.set(4, 0);
        source.set(5, 0);

        assertEquals('3334000037', source.trim().toHex());

        source = Bytes.ofString('123456789');
        source.set(0, 0);
        source.set(1, 1);
        source.set(8, 0);
        source.set(7, 2);
        source.set(4, 0);
        source.set(5, 2);

        assertEquals('3334000237', source.trim([0, 1, 2]).toHex());
    }

    public function testAppend() {
        var one : Bytes;
        var two: Bytes;

        one = Bytes.ofString('123');
        two = Bytes.ofString('ABCDEF');
        assertEquals('313233414243444546', one.append(two).toHex());
    }

    public function testPrepend() {
        var one : Bytes;
        var two: Bytes;

        one = Bytes.ofString('123');
        two = Bytes.ofString('ABCDEF');
        assertEquals('414243444546313233', one.prepend(two).toHex());
    }

    public function testAppendByte() {
        var one : Bytes;
        var two: Bytes;

        one = Bytes.ofString('123');
        two = Bytes.ofString('ABCDEF');
        one = one.appendByte(two.get(0));
        one = one.appendByte(two.get(1));
        one = one.appendByte(two.get(2));
        one = one.appendByte(two.get(3));
        one = one.appendByte(two.get(4));
        one = one.appendByte(two.get(5));
        assertEquals('313233414243444546', one.toHex());
    }

    public function testPrependByte() {
        var one : Bytes;
        var two: Bytes;

        one = Bytes.ofString('123');
        two = Bytes.ofString('ABCDEF');
        one = one.prependByte(two.get(5));
        one = one.prependByte(two.get(4));
        one = one.prependByte(two.get(3));
        one = one.prependByte(two.get(2));
        one = one.prependByte(two.get(1));
        one = one.prependByte(two.get(0));
        assertEquals('414243444546313233', one.toHex());
    }


    public function testInsert() {
        var one : Bytes;
        var two: Bytes;


        one = Bytes.ofString('ABCDEF');
        two = Bytes.alloc(0);
        assertEquals('414243444546', one.insert(two).toHex());

        one = Bytes.ofString('ABCDEF');
        two = Bytes.ofString('123');
        assertEquals('313233444546', one.insert(two).toHex());
        assertEquals('414231323346', one.insert(two, 2).toHex());
        assertEquals('414243444546', one.toHex());
        assertEquals('4142434445313233', one.insert(two, 5).toHex());
        try {
            one.insert(two, 6).toHex();
            assertTrue(false);
        } catch(e : OutOfBoundsException) {
            assertTrue(true);
        } catch(e : Dynamic) {
            assertTrue(false);
        }
    }


}
