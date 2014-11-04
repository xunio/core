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
import io.xun.core.event.IObservable;
import io.xun.core.event.IObserver;
import js.io.xun.ui.slider.ISlider.SliderEvent;
import js.JQuery;
import js.Browser;
import js.html.Document;
import js.html.Element;
class Slider implements IObserver {


    public function onUpdate(type:Int, source:IObservable, userData:Dynamic):Void {
        switch (type) {
            case SliderEvent.PRE_STAGE_ADDED:
                var slideEvt : js.io.xun.ui.slider.ISlider.SliderEventState = cast userData;
                if(slideEvt.stagePosition == 4)
                    slideEvt.veto = true;
            case SliderEvent.POST_STAGE_ADDED:
                var slideEvt : js.io.xun.ui.slider.ISlider.SliderEventState = cast userData;

                var jc : JQuery = new JQuery(slideEvt.stage.getContainer());
                jc.hide();
                jc.click( function( evt : JqEvent ) { trace("clicked" + evt.currentTarget.textContent); } );

                //add button event if button does exist
                var b : Null<Element> = slideEvt.stage.getButton();
                if(b != null) {
                    new JQuery(b).click( function( evt : JqEvent ) {
                        var slider : js.io.xun.ui.slider.ISlider = cast source;
                        slider.switchStage(slideEvt.stagePosition);
                    } );
                }
            case SliderEvent.VETOED_STAGE_ADDED:
                var slideEvt : js.io.xun.ui.slider.ISlider.SliderEventState = cast userData;
                trace("cant add stage #" + (slideEvt.stagePosition + 1) + "!");

            case SliderEvent.PRE_STAGE_CHANGE:
                var slideEvt : js.io.xun.ui.slider.ISlider.SliderEventState = cast userData;
                if(slideEvt.stagePosition == 1 && slideEvt.oldStagePosition == 3) {
                    slideEvt.veto = true;
                }

            case SliderEvent.POST_STAGE_CHANGE:
                var slideEvt : js.io.xun.ui.slider.ISlider.SliderEventState = cast userData;
                var old : Null<Int> = slideEvt.oldStagePosition;
                if(old != null) {
                    trace("move from " + old + " to " + slideEvt.stagePosition);
                } else {
                    trace("move to " + slideEvt.stagePosition);
                }

            case SliderEvent.VETOED_STAGE_CHANGE:
                var slideEvt : js.io.xun.ui.slider.ISlider.SliderEventState = cast userData;
                var old : Null<Int> = slideEvt.oldStagePosition;
                trace("move from " + old + " to " + slideEvt.stagePosition + " is vetoed!");

        }
    }

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

        slider.attach(
            this,
            SliderEvent.PRE_STAGE_ADDED | SliderEvent.POST_STAGE_ADDED |
            SliderEvent.PRE_STAGE_CHANGE | SliderEvent.POST_STAGE_CHANGE |
            SliderEvent.VETOED_STAGE_ADDED | SliderEvent.VETOED_STAGE_CHANGE
        );

        slider.addStage(new js.io.xun.ui.slider.DefaultStage("AAA"));
        slider.addStage(new js.io.xun.ui.slider.DefaultStage("BBB"));
        slider.addStage(new js.io.xun.ui.slider.DefaultStage("CCC"));
        slider.addStage(new js.io.xun.ui.slider.DefaultStage("DDD"));
        slider.addStage(new js.io.xun.ui.slider.DefaultStage("EEE"));

        slider.switchStage(0);

        //add prev and next buttons, use helper function for that
        addButton(template.getPrevButton, slider.switchPrevStage);
        addButton(template.getNextButton, slider.switchNextStage);

    }

	public static function main() {
        var j : JQuery = new JQuery(js.Browser.document.body);
        j.ready(function(e : JqEvent) {
            new Slider();
        });
	}

}

