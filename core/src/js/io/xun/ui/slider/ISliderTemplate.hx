package js.io.xun.ui.slider;

import io.xun.core.event.ObserverMacro;
import io.xun.core.event.IObservable;
import io.xun.core.event.IObserver;
import js.html.Element;

interface ISliderTemplate extends IObserver extends IObservable
{
    public function setSlider(slider : ISlider) : Void;
	public function addStage(stage : IStage) : Void;

	public function switchStage(stagePosition : Int) : Void;

	public function getContainer() : Element;

	public function getStagesContainer() : Element;

	public function getStageContainer(stage : IStage) : Element;

	public function getNextButton() : Null<Element>;

	public function getPrevButton() : Null<Element>;

	public function getSlideButtonContainer() : Null<Element>;

    public function getAnimation() : Bool;
    public function setAnimation(ani : Bool) : Void;
}

/**
 * Class SliderTemplateEvent
 *
 * @author        Maximilian Ruta <mr@xtain.net>
 * @copyright     Copyright (c) 2013 XTAIN oHG, <https://company.xtain.net>
 * @package       js.io.xun.ui.slider.Slider
 */
@:build(io.xun.core.event.ObserverMacro.create([
STAGE_ENTER,
STAGE_LEAVE
]))
class SliderTemplateEvent {
    public inline static var STAGE_ENTER;
    public inline static var STAGE_LEAVE;
    public inline static var GROUP_ID;
    public inline static var GROUP_MASK;
    public inline static var EVENT_MASK;
}

/**
 * Type SliderEventState
 *
 * @author        Maximilian Ruta <mr@xtain.net>
 * @copyright     Copyright (c) 2013 XTAIN oHG, <https://company.xtain.net>
 * @package       js.io.xun.ui.slider.Slider
 */
typedef SliderTemplateEventState = {
    stagePosition: Null<Int>,
    stage: Null<IStage>
}