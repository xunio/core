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
 * @package       io.xun.core.dependencyinjection
 * @license       http://www.gnu.org/licenses/agpl-3.0.html GNU Affero General Public License
 */

package io.xun.core.dependencyinjection;

/**
 * Class Scope
 *
 * @author        Maximilian Ruta <mr@xtain.net>
 * @copyright     Copyright (c) 2013 XTAIN oHG, <https://company.xtain.net>
 * @package       io.xun.core.dependencyinjection
 */
class Scope implements IScope {

    private var name : String;
    private var parentName : String;

    /**
     * Constructor
     *
     * @author Maximilian Ruta <mr@xtain.net>
     */
    public function new(name : String, parentName : Null<String> = null) {
        if (parentName == null) {
            parentName = IContainer.IContainerConst.SCOPE_CONTAINER;
        }
        this.name = name;
        this.parentName = parentName;
    }

    /**
     * Gets the name
     *
     * @author Maximilian Ruta <mr@xtain.net>
     */
    public function getName() {
        return name;
    }

    /**
     * Gets the parent name
     *
     * @author Maximilian Ruta <mr@xtain.net>
     */
    public function getParentName() {
        return parentName;
    }

}
