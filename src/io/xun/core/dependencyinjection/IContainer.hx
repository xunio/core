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
 * Interface IContainerConst
 *
 * @author        Maximilian Ruta <mr@xtain.net>
 * @copyright     Copyright (c) 2013 XTAIN oHG, <https://company.xtain.net>
 * @package       io.xun.core.dependencyinjection
 */
interface IContainer {

}

/**
 * Class IContainerConst
 *
 * @author        Maximilian Ruta <mr@xtain.net>
 * @copyright     Copyright (c) 2013 XTAIN oHG, <https://company.xtain.net>
 * @package       io.xun.core.dependencyinjection.IContainer
 */
class IContainerConst {
    public static inline var EXCEPTION_ON_INVALID_REFERENCE = 1;
    public static inline var NULL_ON_INVALID_REFERENCE      = 2;
    public static inline var IGNORE_ON_INVALID_REFERENCE    = 3;
    public static inline var SCOPE_CONTAINER                = 'container';
    public static inline var SCOPE_PROTOTYPE                = 'prototype';
}
