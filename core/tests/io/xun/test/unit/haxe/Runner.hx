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
 * @package       io.xun.test.unit.haxe
 * @license       http://www.gnu.org/licenses/agpl-3.0.html GNU Affero General Public License
 */

package io.xun.test.unit.haxe;

/**
 * Class Runner
 *
 * @author        Maximilian Ruta <mr@xtain.net>
 * @copyright     Copyright (c) 2013 XTAIN oHG, <https://company.xtain.net>
 * @package       io.xun.test.unit.haxe
 */
class Runner {

    public static function main() : Array<haxe.unit.TestCase> {
        var tests : Array<haxe.unit.TestCase> = new Array<haxe.unit.TestCase>();
        tests = tests.concat(io.xun.test.unit.haxe.ds.Runner.main());
        return tests;
    }
}
