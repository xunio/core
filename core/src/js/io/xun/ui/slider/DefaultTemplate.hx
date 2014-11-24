package js.io.xun.ui.slider;


import js.JQuery;
import js.html.Element;

import io.xun.core.event.IObservable;

import js.io.xun.ui.slider.ISlider;
import js.io.xun.ui.slider.ISlider.SliderEvent;
import js.io.xun.ui.slider.ISlider.SliderEventState;

class DefaultTemplate implements ISliderTemplate
{

    var _container : JQuery;
    var _slider : ISlider;
    var _stagecount : Int = 0;
    var _animation : Bool = true;

    public function addStage(stage:IStage):Void {
        new JQuery(getStagesContainer()).append(stage.getContainer());

        // add buttons but only if both the template and the stage does support it
        var buttons : Null<Element> = getSlideButtonContainer();
        if (buttons != null) {
            var button : Null<Element> = stage.getButton();
            if(button != null) {
                new JQuery(buttons).append(button);
            }
        }


        var jqstate : JQuery = new JQuery(stage.getContainer());

        // set eventData object. Fill it with both new stage data
        var eventData : SliderEventState = {
        stagePosition:  _stagecount,
        stage: stage,
        oldStagePosition: null,
        oldStage: null,
        veto: false
        };

        _stagecount += 1;

        jqstate.mouseenter( function( evt : JqEvent) {

            //notify stage enter event
            _slider.notify(SliderEvent.STAGE_ENTER, eventData);
        });

        jqstate.mouseleave( function( evt : JqEvent) {

            //notify stage leave event
            _slider.notify(SliderEvent.STAGE_LEAVE, eventData);
        });
    }

    public function switchStage(stagePosition:Int):Void {
    }

    public function getContainer():Element {
        return _container.get(0);
    }

    public function getStagesContainer():Element {
        return getElement(".stagesContainer");
    }

    public function getStageContainer(stage:IStage):Element {
        return stage.getContainer();
    }

    public function getNextButton():Null<Element> {
        return getElement(".next");
    }

    public function getPrevButton():Null<Element> {
        return getElement(".prev");
    }

    public function getSlideButtonContainer():Null<Element> {
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
                    var bt : Null<Element> = slideEvt.oldStage.getButton();
                    if(bt != null)
                        new JQuery(bt).removeClass("highlight");
                } else {
                    trace("move to " + slideEvt.stagePosition);
                }

                var bt : Null<Element> = slideEvt.stage.getButton();
                if(bt != null)
                    new JQuery(bt).addClass("highlight");

            case SliderEvent.VETOED_STAGE_CHANGE:
                var slideEvt : js.io.xun.ui.slider.ISlider.SliderEventState = cast userData;
                var old : Null<Int> = slideEvt.oldStagePosition;
                trace("move from " + old + " to " + slideEvt.stagePosition + " is vetoed!");

            case SliderEvent.STAGE_ENTER:
                trace("stage enter");
                _slider.stopTimer();
            case SliderEvent.STAGE_LEAVE:
                trace("stage leave");
                _slider.startTimer(2000);

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
