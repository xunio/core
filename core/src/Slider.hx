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

/**
 * Class Slider
 *
 * @author        Maximilian Ruta <mr@xtain.net>
 * @copyright     Copyright (c) 2013 XTAIN oHG, <https://company.xtain.net>
 */
import js.Browser;
import js.html.Document;
import js.html.Element;
class Slider {

	public static function main() {
        var container : Element = js.Browser.document.getElementById("sliderContainer");
		var template : js.io.xun.ui.slider.DefaultTemplate = new js.io.xun.ui.slider.DefaultTemplate(container);
		var slider : js.io.xun.ui.slider.Slider = new js.io.xun.ui.slider.Slider(template);
        var stage : js.io.xun.ui.slider.DefaultStage = new js.io.xun.ui.slider.DefaultStage();
        slider.addStage(stage);
	}

}

