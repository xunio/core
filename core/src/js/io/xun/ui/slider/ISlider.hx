package js.io.xun.ui.slider;

import io.xun.core.event.ObserverMacro;
import js.html.Element;
import io.xun.core.event.IObservable;

interface ISlider extends IObservable
{
	public function addStage(stage : IStage) : Void;

	public function getStage(stagePosition : Int) : IStage;

	public function getStages() : Array<IStage>;

	public function getContainer() : Element;

	public function getStagesContainer() : Element;

	public function getCurrentStage() : Null<IStage>;

	public function getCurrentStagePosition() : Null<Int>;

	public function switchStage(stagePosition : Int) : Void;

	public function switchNextStage() : Void;

	public function switchPrevStage() : Void;

    public function startTimer( ms : Int) : Void;

    public function stopTimer() : Void;

}

/**
 * Class SliderEvent
 *
 * @author        Maximilian Ruta <mr@xtain.net>
 * @copyright     Copyright (c) 2013 XTAIN oHG, <https://company.xtain.net>
 * @package       js.io.xun.ui.slider.Slider
 */
@:build(io.xun.core.event.ObserverMacro.create([
PRE_STAGE_CHANGE,
POST_STAGE_CHANGE,
VETOED_STAGE_CHANGE,
PRE_STAGE_ADDED,
POST_STAGE_ADDED,
VETOED_STAGE_ADDED,
STAGE_ENTER,
STAGE_LEAVE
]))
class SliderEvent {
    public inline static var PRE_STAGE_CHANGE;
    public inline static var POST_STAGE_CHANGE;
    public inline static var VETOED_STAGE_CHANGE;
    public inline static var PRE_STAGE_ADDED;
    public inline static var POST_STAGE_ADDED;
    public inline static var VETOED_STAGE_ADDED;
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
typedef SliderEventState = {
stagePosition: Null<Int>,
stage: Null<IStage>,
oldStagePosition: Null<Int>,
oldStage: Null<IStage>,
veto: Bool

}