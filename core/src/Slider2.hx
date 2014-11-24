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
import io.xun.core.event.IObservable;
import io.xun.core.event.Observable;
import io.xun.core.event.IObserver;
import js.io.xun.ui.slider.ISliderTemplate;
import js.io.xun.ui.slider.ISlider;
import js.io.xun.ui.slider.IStage;
import js.JQuery;
import js.Browser;
import js.html.Document;
import js.html.Element;

class ExistingStage implements IStage {

    var _el : Element;
    var _bt : Element;

    public function setSlider(slider:ISlider):Void {
    }

    public function getContainer():Element {
        return _el;
    }

    public function getButton():Null<Element> {
        return _bt;
    }

    public function show():Void {
        new JQuery(_el).show();
    }

    public function hide():Void {
        new JQuery(_el).hide();
    }

    public function initialize(pos:Int):Void {
    }

    public function getAnimation():Bool {
        return true;
    }

    public function setAnimation(ani:Bool):Void {
    }

    public function new(el : Element, bt : Element) {
        _el = el;
        _bt = bt;
    }
}


class ExistingTemplate implements ISliderTemplate
{

    public function attach(o : IObserver, mask : Null<Int> = 0):Void {
    }

    public function detach(o : IObserver, mask : Null<Int> = null):Void {
    }

    var _container : JQuery;
    var _slider : ISlider;
    var _stagecount : Int = 0;
    var _animation : Bool = true;

    public function addStage(stage : IStage) : Void {
    }

    public function switchStage(stagePosition:Int):Void {
    }

    public function getContainer():Element {
        return _container.get(0);
    }

    public function getStagesContainer():Element {
        return getElement(".stagesContainer");
    }

    public function getStageContainer(stage : IStage):Element {
        return stage.getContainer();
    }

    public function getNextButton() : Null<Element> {
        return null; //getElement(".next");
    }

    public function getPrevButton() : Null<Element> {
        return null; //getElement(".prev");
    }

    public function getSlideButtonContainer() : Null<Element> {
        return getElement(".slideButtons");
    }

    public function new(mainElement : Element) {
        _container = new JQuery(mainElement);

    }

    private function getElement(name : String) {
        return _container.find(name).get(0);
    }


    public function onUpdate(type:Int, source:IObservable, userData:Dynamic):Void {

        switch (type) {
            case SliderEvent.POST_STAGE_ADDED:
                var slideEvt : js.io.xun.ui.slider.ISlider.SliderEventState = cast userData;

                var jc : JQuery = new JQuery(slideEvt.stage.getContainer());
                jc.hide();

//add button event if button does exist
                var b : Null<Element> = slideEvt.stage.getButton();
                if(b != null) {
                    new JQuery(b).click( function( evt : JqEvent ) {
                        _slider.switchStage(slideEvt.stagePosition);
                    } );
                }
        }
    }

    public function setSlider(slider:ISlider):Void {
        _slider = slider;
    }

    public function getAnimation():Bool {
        return _animation;
    }

    public function setAnimation(ani:Bool):Void {
        _animation = true;
    }
}

class Slider2 {

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
        var container : Element = js.Browser.document.getElementById("existingSlider");
        var template : js.io.xun.ui.slider.ISliderTemplate = new ExistingTemplate(container);

        var slider : js.io.xun.ui.slider.Slider = new js.io.xun.ui.slider.Slider(template);

        var jqf : JQuery = new js.JQuery(container);
        var jqbuttons : JQuery = new js.JQuery(container).find(".slideButtons > li");
        var jqc : JQuery = jqf.find(".stagesContainer > li");

        jqc.each(function( pos : Int, el : js.html.Element) {
            slider.addStage(new ExistingStage(el, jqbuttons.get(pos)));
        });

        slider.switchStage(0);

        if(jqc.length > 3) {

            //new js.JQuery(container).find(".slideButtons").append();
            //add prev and next buttons, use helper function for that
            addButton(template.getPrevButton, slider.switchPrevStage);
            addButton(template.getNextButton, slider.switchNextStage);
        }
    }

    public static function main() {
        var j : JQuery = new JQuery(js.Browser.document.body);
        j.ready(function(e : JqEvent) {
            new Slider2();
        });
    }

}

