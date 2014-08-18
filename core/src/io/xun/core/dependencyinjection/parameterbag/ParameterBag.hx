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

/* imports and uses */

import io.xun.core.exception.InvalidArgumentException;
import io.xun.core.dependencyinjection.ref.Parameter;
import haxe.ds.StringMap;

/**
 * Class ParameterBag
 *
 * @author        Maximilian Ruta <mr@xtain.net>
 * @copyright     Copyright (c) 2013 XTAIN oHG, <https://company.xtain.net>
 * @package       io.xun.core.dependencyinjection.parameterbag
 */
class ParameterBag implements IParameterBag {

    var stringMap : Map<String, Parameter>;

    public function new() : Void {
        stringMap = new Map<String, Parameter>();
    }

    public function clear() : Void {
        for(key in this.keys()) {
            stringMap.remove(key);
        }
    }

    public function add( parameters : Array<Parameter> ) : Void {
        for(parameter in parameters.iterator()) {
            if (this.parameterExists(parameter)) {
                throw new InvalidArgumentException("Parameter already exist");
            }
        }
        for(parameter in parameters.iterator()) {
            this.set(parameter);
        }
    }

    public function isFrozen() : Bool {
        return false;
    }

    public function set( parameter : Parameter ) : Void {
        parameter.key = parameter.key.toLowerCase();
        stringMap.set(parameter.key, parameter);
    }

	public function get( key : String ) : Parameter {
		key = key.toLowerCase();
		if (stringMap.exists(key)) {
			return stringMap.get(key);
		}
		throw new InvalidArgumentException("Parameter does not exist");
	}

	public function all() : Map<String, Parameter> {
		return stringMap;
	}

	public function parameterExists( parameter : Parameter ) : Bool {
        return stringMap.exists(parameter.key);
    }

    public function exists( key : String ) : Bool {
        return stringMap.exists(key);
    }

    public function remove( key : String ) : Bool {
        if (this.exists(key)) {
            return stringMap.remove(key);
        }
        throw new InvalidArgumentException("Parameter does not exist");
    }

    public function keys() : Iterator<String> {
        return stringMap.keys();
    }

    public function iterator() : Iterator<Parameter> {
        return stringMap.iterator();
    }

    public function toString() : String {
        return stringMap.toString();
    }

}
