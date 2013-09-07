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
 * @package
 * @license       http://www.gnu.org/licenses/agpl-3.0.html GNU Affero General Public License
 */

package ;

/* imports and uses */

import io.xun.core.util.BitwiseMask;

/**
 * Class TestRunner
 *
 * @author        Maximilian Ruta <mr@xtain.net>
 * @copyright     Copyright (c) 2013 XTAIN oHG, <https://company.xtain.net>
 * @package
 */
class TestRunner {

    public static function main() {
        var result : Bool = true;
        result = io.xun.test.Runner.main() && result;

        if(!result) {
            #if js
              if( untyped __js__('typeof process != "undefined" && "exit" in process') ) {
                untyped __js__('process.exit(255)');
              }
            #elseif flash
            #else
            Sys.exit(255);
            #end
        }
    }

}
