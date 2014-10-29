package js.io.xun.ui.slider;

import js.html.Element;
import io.xun.core.exception.OutOfRangeException;
import io.xun.core.event.Observable;
import io.xun.core.event.ObserverMacro;

class Slider implements SliderInterface
{
	private var _observer : Observable;
	private var _stages : Array<StageInterface> = [];
	private var _currentStage : Null<StageInterface> = null;
	private var _currentStagePosition : Null<Int> = null;
	private var _sliderTemplate : SliderTemplateInterface;

	public function new(sliderTemplate : SliderTemplateInterface)
	{
		_sliderTemplate = sliderTemplate;
		_observer = new Observable(this);
	}

	public function addStage(stage : StageInterface) : Void
	{
		stage.setSlider(this);
		_stages.push(stage);
		_sliderTemplate.addStage(stage);
		stage.initialize();
	}

	public function getStage(stagePosition : Int) : StageInterface
	{
		if (_stages.length <= stagePosition) {
			throw new OutOfRangeException("No stage with index " + stagePosition + " exists");
		}

		return _stages[stagePosition];
	}

	public function getStages() : Array<StageInterface>
	{
		return _stages;
	}

	public function getContainer() : Element
	{
		return _sliderTemplate.getContainer();
	}

	public function getStagesContainer() : Element
	{
		return _sliderTemplate.getStagesContainer();
	}

	public function getCurrentStage() : Null<StageInterface>
	{
		if (_currentStagePosition == null || _stages.length <= 0) {
			return null;
		}

		return _stages[_currentStagePosition];
	}

	public function getCurrentStagePosition() : Null<Int>
	{
		if (_currentStagePosition == null || _stages.length <= 0) {
			return null;
		}

		return _currentStagePosition;
	}

	public function switchStage(stagePosition : Int) : Void
	{
		if (stagePosition >= _stages.length) {
			throw new OutOfRangeException("No stage with index " + stagePosition + " exists");
		}

		var oldStage : Null<StageInterface> = _currentStage;

		_currentStage = _stages[stagePosition];
		_currentStagePosition = stagePosition;
		_sliderTemplate.switchStage(stagePosition);
		var eventData : SliderEventStateChange = {
			stagePosition: _currentStagePosition,
			stage: _currentStage
		};
		_observer.notify(SliderEvent.PRE_STAGE_CHANGE, eventData);
		if (oldStage != null) {
			oldStage.hide();
		}
		_currentStage.show();
		_observer.notify(SliderEvent.POST_STAGE_CHANGE, eventData);
	}

	public function switchPrevStage() : Void
	{
		if (_stages.length <= 0) {
			return;
		}

		var nextPosition : Int = _stages.length - 1;
		if (_currentStagePosition != null && _currentStagePosition > 0) {
			nextPosition = _currentStagePosition - 1;
		}
		switchStage(nextPosition);
	}

	public function switchNextStage() : Void
	{
		if (_stages.length <= 0) {
			return;
		}

		var nextPosition : Int = 0;
		if (_currentStagePosition != null && _currentStagePosition < (_stages.length - 1)) {
			nextPosition = _currentStagePosition + 1;
		}
		switchStage(nextPosition);
	}

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
POST_STAGE_CHANGE
]))
class SliderEvent {
	public inline static var PRE_STAGE_CHANGE;
	public inline static var POST_STAGE_CHANGE;
	public inline static var GROUP_ID;
	public inline static var GROUP_MASK;
	public inline static var EVENT_MASK;
}

/**
 * Type SliderEventStateChange
 *
 * @author        Maximilian Ruta <mr@xtain.net>
 * @copyright     Copyright (c) 2013 XTAIN oHG, <https://company.xtain.net>
 * @package       js.io.xun.ui.slider.Slider
 */
typedef SliderEventStateChange = {
	stagePosition: Int,
	stage: StageInterface
}