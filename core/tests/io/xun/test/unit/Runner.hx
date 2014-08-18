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
 * @package       io.xun.test.unit
 * @license       http://www.gnu.org/licenses/agpl-3.0.html GNU Affero General Public License
 */

package io.xun.test.unit;

/**
 * Class Runner
 *
 * @author        Maximilian Ruta <mr@xtain.net>
 * @copyright     Copyright (c) 2013 XTAIN oHG, <https://company.xtain.net>
 * @package       io.xun.test.unit
 */
class Runner {

    public static function main(runner : haxe.unit.TestRunner) {
        io.xun.test.unit.sys.Runner.main(runner);
        //io.xun.test.unit.haxe.Runner.main(runner);
        io.xun.test.unit.io.Runner.main(runner);
        io.xun.test.unit.crypt.Runner.main(runner);
        io.xun.test.unit.core.Runner.main(runner);
        //io.xun.test.unit.async.Runner.main(runner);
    }
}
