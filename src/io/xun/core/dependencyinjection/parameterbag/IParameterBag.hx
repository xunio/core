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
 * @package       io.xun.core.dependencyinjection.parameterbag
 * @license       http://www.gnu.org/licenses/agpl-3.0.html GNU Affero General Public License
 */

package io.xun.core.dependencyinjection.parameterbag;

import io.xun.core.dependencyinjection.ref.Parameter;

/**
 * Interface IParameterBag
 *
 * @author        Maximilian Ruta <mr@xtain.net>
 * @copyright     Copyright (c) 2013 XTAIN oHG, <https://company.xtain.net>
 * @package       io.xun.core.dependencyinjection.parameterbag
 */
interface IParameterBag {

    public function clear() : Void;

    public function add( parameters : Array<Parameter> ) : Void;

    public function isFrozen() : Bool;

    public function set( key : String, parameter : Parameter ) : Void;

    public function get( key : String ) : Parameter;

    public function parameterExists( parameter : Parameter ) : Bool;

    public function exists( key : String ) : Bool;

    public function remove( key : String ) : Bool;

    public function keys() : Iterator<String>;

    public function iterator() : Iterator<Parameter>;

}
