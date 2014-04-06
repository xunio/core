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
 * @package       io.xun.test.unit.async
 * @license       http://www.gnu.org/licenses/agpl-3.0.html GNU Affero General Public License
 */

package io.xun.test.unit.async;

import io.xun.async.Promise;

/**
 * Class TestPromise
 *
 * @author        Maximilian Ruta <mr@xtain.net>
 * @copyright     Copyright (c) 2013 XTAIN oHG, <https://company.xtain.net>
 * @package       io.xun.test.unit.async
 */
class TestPromise extends haxe.unit.TestCase {

    private var _promiseValue : Int = 0;

    public function testPromise() {
        var promise : Promise<Int> = new Promise<Int>();

        _promiseValue = 0;
        promise.then(function (value : Int) {
            _promiseValue = value;
            assertEquals(1, _promiseValue);
        });

        assertEquals(0, _promiseValue);
        promise.resolve(1);
    }

}

