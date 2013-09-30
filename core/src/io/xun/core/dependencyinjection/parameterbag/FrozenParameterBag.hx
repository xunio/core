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

import io.xun.core.dependencyinjection.parameterbag.exception.FrozenParameterBagException;
import io.xun.core.dependencyinjection.ref.Parameter;
import haxe.ds.StringMap;

/**
 * Class FrozenParameterBag
 *
 * @author        Maximilian Ruta <mr@xtain.net>
 * @copyright     Copyright (c) 2013 XTAIN oHG, <https://company.xtain.net>
 * @package       io.xun.core.dependencyinjection.parameterbag
 */
class FrozenParameterBag extends ParameterBag {

    private var frozen : Bool = false;

    public function new( bag : IParameterBag ) {
        super();
        for(parameter in bag.iterator()) {
            this.set(parameter);
        }
        frozen = true;
    }

    override public function isFrozen() : Bool {
        return frozen;
    }

    override public function clear() : Void {
        if (isFrozen()) {
            throw new FrozenParameterBagException("Impossible to call clear() on a frozen ParameterBag.");
        }
        super.clear();
    }

    override public function add( parameters : Array<Parameter> ) : Void {
        if (isFrozen()) {
            throw new FrozenParameterBagException("Impossible to call add() on a frozen ParameterBag");
        }
        super.add(parameters);
    }

    override public function set( parameter : Parameter ) : Void {
        if (isFrozen()) {
            throw new FrozenParameterBagException("Impossible to call set() on a frozen ParameterBag");
        }
        super.set(parameter);
    }

    override public function remove( key : String ) : Bool {
        if (isFrozen()) {
            throw new FrozenParameterBagException("Impossible to call remove() on a frozen ParameterBag");
        }
        return super.remove(key);
    }

}
