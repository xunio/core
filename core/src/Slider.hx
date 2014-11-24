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
import js.JQuery;
import js.Browser;
import js.html.Document;
import js.html.Element;
class Slider {

    // helper function for adding prev and next buttons
    function addButton( get: Void -> Null<Element>, switchfunc: Void -> Void ) {
        var b : Null<Element> = get();
        if(b != null) {
            new JQuery(b).click( function( evt : JqEvent ) {
                switchfunc();
            });
        }

    }

    public function new() {
        var container : Element = js.Browser.document.getElementById("sliderContainer");
        var template : js.io.xun.ui.slider.DefaultTemplate = new js.io.xun.ui.slider.DefaultTemplate(container);

        var slider : js.io.xun.ui.slider.Slider = new js.io.xun.ui.slider.Slider(template);

        slider.addStage(new js.io.xun.ui.slider.DefaultStage("AAA"));
        slider.addStage(new js.io.xun.ui.slider.DefaultStage("BBB"));
        slider.addStage(new js.io.xun.ui.slider.DefaultStage("CCC"));
        slider.addStage(new js.io.xun.ui.slider.DefaultStage("DDD"));
        slider.addStage(new js.io.xun.ui.slider.DefaultStage("EEE"));

        slider.switchStage(0);

        //add prev and next buttons, use helper function for that
        addButton(template.getPrevButton, slider.switchPrevStage);
        addButton(template.getNextButton, slider.switchNextStage);

        slider.startTimer(2000);

    }

    public static function main() {
        var j : JQuery = new JQuery(js.Browser.document.body);
        j.ready(function(e : JqEvent) {
            new Slider();
        });
    }

}

