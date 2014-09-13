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
 * @license       http://www.gnu.org/licenses/agpl-3.0.html GNU Affero General Public License
 */

package ;

/* imports and uses */
import io.xun.docker.Commander;
import io.xun.docker.Container;

/**
 * Class Main
 *
 * @author        Maximilian Ruta <mr@xtain.net>
 * @copyright     Copyright (c) 2013 XTAIN oHG, <https://company.xtain.net>
 */
class DockerClient {

	public static function main() {
		var container : Container = new Container('test');
		container.setCommander(new Commander('docker'));
		trace(container.isAvailable());
		trace(container.getId());
		trace(container.getState());
	}

}

