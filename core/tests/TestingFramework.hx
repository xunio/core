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

//import io.xun.test.Runner;
import io.xun.test.Runner;

/**
 * Class TestingFramework
 *
 * @author        Maximilian Ruta <mr@xtain.net>
 * @copyright     Copyright (c) 2013 XTAIN oHG, <https://company.xtain.net>
 * @package
 */
class TestingFramework {

    #if XUN_IO_BENCH
    public static var RUNS = 100;
    #else
    public static var RUNS = 1;
    #end

    public static function main() {
        var result : Bool = true;
        var runner : haxe.unit.TestRunner = new haxe.unit.TestRunner();
        Runner.main(runner);

        var i : Int = 0;
        for ( i in 0...RUNS ) {
            result = runner.run();
        }

        if(!result) {
            #if js
            //Sys.exit();
            untyped __js__("process.exit(255)");
            #elseif flash
            #else
            Sys.exit(255);
            #end
        }
    }

}
