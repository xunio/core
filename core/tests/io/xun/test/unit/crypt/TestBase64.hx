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
 * @package       io.xun.test.unit.crypt
 * @license       http://www.gnu.org/licenses/agpl-3.0.html GNU Affero General Public License
 */

package io.xun.test.unit.crypt;

import haxe.io.Bytes;
import haxe.io.Bytes;
import haxe.io.Bytes;
import io.xun.crypt.algorithm.implementation.Base64Encoder;
import io.xun.crypt.algorithm.Base64;
import haxe.io.Bytes;
import io.xun.io.ByteArrayInputStream;
import io.xun.crypt.algorithm.implementation.Base64Decoder;
import haxe.ds.StringMap;

/**
 * Class TestBase64
 *
 * @author        Maximilian Ruta <mr@xtain.net>
 * @copyright     Copyright (c) 2013 XTAIN oHG, <https://company.xtain.net>
 * @package       io.xun.test.unit.crypt
 */
class TestBase64 extends haxe.unit.TestCase {

    public function testEncodeAndDecode() {

        var map : StringMap<String> = [
            '' => '',
            "\n" => 'Cg==',
            "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut "
            + "labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores "
            + "et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem "
            + "ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et "
            + "dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. "
            + "Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit "
            + "amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna "
            + "aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita "
            + "kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet." =>
            "TG9yZW0gaXBzdW0gZG9sb3Igc2l0IGFtZXQsIGNvbnNldGV0dXIgc2FkaXBzY2luZyBlbGl0ciwg"
            + "c2VkIGRpYW0gbm9udW15IGVpcm1vZCB0ZW1wb3IgaW52aWR1bnQgdXQgbGFib3JlIGV0IGRvbG9y"
            + "ZSBtYWduYSBhbGlxdXlhbSBlcmF0LCBzZWQgZGlhbSB2b2x1cHR1YS4gQXQgdmVybyBlb3MgZXQg"
            + "YWNjdXNhbSBldCBqdXN0byBkdW8gZG9sb3JlcyBldCBlYSByZWJ1bS4gU3RldCBjbGl0YSBrYXNk"
            + "IGd1YmVyZ3Jlbiwgbm8gc2VhIHRha2ltYXRhIHNhbmN0dXMgZXN0IExvcmVtIGlwc3VtIGRvbG9y"
            + "IHNpdCBhbWV0LiBMb3JlbSBpcHN1bSBkb2xvciBzaXQgYW1ldCwgY29uc2V0ZXR1ciBzYWRpcHNj"
            + "aW5nIGVsaXRyLCBzZWQgZGlhbSBub251bXkgZWlybW9kIHRlbXBvciBpbnZpZHVudCB1dCBsYWJv"
            + "cmUgZXQgZG9sb3JlIG1hZ25hIGFsaXF1eWFtIGVyYXQsIHNlZCBkaWFtIHZvbHVwdHVhLiBBdCB2"
            + "ZXJvIGVvcyBldCBhY2N1c2FtIGV0IGp1c3RvIGR1byBkb2xvcmVzIGV0IGVhIHJlYnVtLiBTdGV0"
            + "IGNsaXRhIGthc2QgZ3ViZXJncmVuLCBubyBzZWEgdGFraW1hdGEgc2FuY3R1cyBlc3QgTG9yZW0g"
            + "aXBzdW0gZG9sb3Igc2l0IGFtZXQuIExvcmVtIGlwc3VtIGRvbG9yIHNpdCBhbWV0LCBjb25zZXRl"
            + "dHVyIHNhZGlwc2NpbmcgZWxpdHIsIHNlZCBkaWFtIG5vbnVteSBlaXJtb2QgdGVtcG9yIGludmlk"
            + "dW50IHV0IGxhYm9yZSBldCBkb2xvcmUgbWFnbmEgYWxpcXV5YW0gZXJhdCwgc2VkIGRpYW0gdm9s"
            + "dXB0dWEuIEF0IHZlcm8gZW9zIGV0IGFjY3VzYW0gZXQganVzdG8gZHVvIGRvbG9yZXMgZXQgZWEg"
            + "cmVidW0uIFN0ZXQgY2xpdGEga2FzZCBndWJlcmdyZW4sIG5vIHNlYSB0YWtpbWF0YSBzYW5jdHVz"
            + "IGVzdCBMb3JlbSBpcHN1bSBkb2xvciBzaXQgYW1ldC4=",
            'test' => 'dGVzdA==',
            "test\ntest" => 'dGVzdAp0ZXN0',
            'teäst' => 'dGXDpHN0'
        ];
        var key : String;

        for(key in map.keys()) {
            assertEquals(
                Bytes.ofString(
                    map.get(key)
                ).toHex(),
                Base64.encode(
                    Bytes.ofString(key)
                ).toHex()
            );
            assertEquals(
                Bytes.ofString(
                    key
                ).toHex(),
                Base64.decode(
                    Bytes.ofString(
                        map.get(key)
                    )
                ).toHex()
            );
        }
    }

    public function testBytes() {
        var dataDecoded : Bytes = Bytes.ofString('Lorem ipsum dolor');
        dataDecoded.set(5, 1);
        dataDecoded.set(6, 192);
        dataDecoded.set(7, 1000);
        assertEquals('4c6f72656d01c0e873756d20646f6c6f72', dataDecoded.toHex());
        var dataEncoded : Bytes = Bytes.ofString('TG9yZW0BwOhzdW0gZG9sb3I=');

        assertEquals(dataEncoded.toString(), Base64.encode(dataDecoded).toString());
        assertEquals(dataDecoded.toHex(), Base64.decode(dataEncoded).toHex());


    }

    public function testSpecialDecode() {
        assertEquals(
            Bytes.ofString(
              "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut "
                + "labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores "
                + "et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem "
                + "ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et "
                + "dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. "
                + "Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit "
                + "amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna "
                + "aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita "
                + "kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet."
            ).toHex(), Base64.decode(Bytes.ofString(
                "TG9yZW0gaXBzdW0gZG9sb3Igc2l0IGFtZXQsIGNvbnNldGV0dXIgc2FkaXBzY2luZyBlbGl0ciwg\n"
                + "c2VkIGRpYW0gbm9udW15IGVpcm1vZCB0ZW1wb3IgaW52aWR1bnQgdXQgbGFib3JlIGV0IGRvbG9y"
                + "ZSBtYWduYSBhbGlxdXlhbSBlcmF0LCBzZWQgZGlhbSB2b2x1cHR1YS4gQXQgdmVybyBlb3MgZXQg\n"
                + "YWNjdXNhbSBldCBqdXN0byBkdW8gZG9sb3JlcyBldCBlYSByZWJ1bS4gU3RldCBjbGl0YSBrYXNk\n"
                + "IGd1YmVyZ3Jlbiwgbm8gc2VhIHRha2ltYXRhIHNhbmN0dXMgZXN0IExvcmVtIGlwc3VtIGRvbG9y\n"
                + "IHNpdCBhbWV0LiBMb3JlbSBpcHN1bSBkb2xvciBzaXQgYW1ldCwgY29uc2V0ZXR1ciBzYWRpcHNj\n"
                + "aW5nIGVsaXRyLCBzZWQgZGlhbSBub251bXkgZWlybW9kIHRlbXBvciBpbnZpZHVudCB1dCBsYWJv\n"
                + "cmUgZXQgZG9sb3JlIG1hZ25hIGFsaXF1eWFtIGVyYXQsIHNlZCBkaWFtIHZvbHVwdHVhLiBBdCB2\n"
                + "ZXJvIGVvcyBldCBhY2N1c2FtIGV0IGp1c3RvIGR1byBkb2xvcmVzIGV0IGVhIHJlYnVtLiBTdGV0\n"
                + "IGNsaXRhIGthc2QgZ3ViZXJncmVuLCBubyBzZWEgdGFraW1hdGEgc2FuY3R1cyBlc3QgTG9yZW0g\n"
                + "aXBzdW0gZG9sb3Igc2l0IGFtZXQuIExvcmVtIGlwc3VtIGRvbG9yIHNpdCBhbWV0LCBjb25zZXRl\n"
                + "dHVyIHNhZGlwc2NpbmcgZWxpdHIsIHNlZCBkaWFtIG5vbnVteSBlaXJtb2QgdGVtcG9yIGludmlk\n"
                + "dW50IHV0IGxhYm9yZSBldCBkb2xvcmUgbWFnbmEgYWxpcXV5YW0gZXJhdCwgc2VkIGRpYW0gdm9s\n"
                + "dXB0dWEuIEF0IHZlcm8gZW9zIGV0IGFjY3VzYW0gZXQganVzdG8gZHVvIGRvbG9yZXMgZXQgZWEg\n"
                + "cmVidW0uIFN0ZXQgY2xpdGEga2FzZCBndWJlcmdyZW4sIG5vIHNlYSB0YWtpbWF0YSBzYW5jdHVz\n"
                + "IGVzdCBMb3JlbSBpcHN1bSBkb2xvciBzaXQgYW1ldC4="
            )).toHex());

    }

    public function testShort() {
        var res : Bytes = Base64.decode(
            Bytes.ofString(
                'dGVzdDEyMzQ1Ng=='
            )
        );
        assertEquals(
            'test123456',
            res.toString()
        );
        var res : Bytes = Base64.encode(
            Bytes.ofString(
                'test123456'
            )
        );
        assertEquals(
            'dGVzdDEyMzQ1Ng==',
            res.toString()
        );

    }

}

