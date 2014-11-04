package js.io.xun.ui.slider;

import js.io.xun.ui.slider.ISlider.SliderEventState;
import js.io.xun.ui.slider.ISlider.SliderEvent;
import io.xun.core.event.IObserver;
import js.html.Element;
import io.xun.core.exception.OutOfRangeException;
import io.xun.core.event.Observable;

class Slider implements ISlider
{

    public function attach(o:IObserver, mask:Null<Int> = 0):Void {
        _observer.attach(o,mask);
    }

    public function detach(o:IObserver, mask:Null<Int> = null):Void {
        _observer.detach(o,mask);
    }

    private var _observer : Observable;
	private var _stages : Array<IStage> = [];
	private var _currentStage : Null<IStage> = null;
	private var _currentStagePosition : Null<Int> = null;
	private var _sliderTemplate : ISliderTemplate;

	public function new(sliderTemplate : ISliderTemplate)
	{
		_sliderTemplate = sliderTemplate;
		_observer = new Observable(this);
	}

	public function addStage(stage : IStage) : Void
	{
		stage.setSlider(this);

        var eventData : SliderEventState = {
        stagePosition: _stages.length,
        stage: stage,
        oldStagePosition: null,
        oldStage: null,
        veto: false
        };
        _observer.notify(SliderEvent.PRE_STAGE_ADDED, eventData);

        if(eventData.veto) {
            _observer.notify(SliderEvent.VETOED_STAGE_ADDED, eventData);
            return;
        }
        _stages.push(stage);
        _sliderTemplate.addStage(stage);

        _observer.notify(SliderEvent.POST_STAGE_ADDED, eventData);

		stage.initialize();
	}

	public function getStage(stagePosition : Int) : IStage
	{
		if (_stages.length <= stagePosition) {
			throw new OutOfRangeException("No stage with index " + stagePosition + " exists");
		}

		return _stages[stagePosition];
	}

	public function getStages() : Array<IStage>
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

	public function getCurrentStage() : Null<IStage>
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

        //dont make the stage events if stage position does not change
        if(_currentStagePosition == stagePosition) {
            return;
        }

		var oldStage : Null<IStage> = _currentStage;
        var oldStagePosition : Null<Int> = _currentStagePosition;

		var eventData : SliderEventState = {
			stagePosition: stagePosition,
			stage: _stages[stagePosition],
            oldStage: oldStage,
            oldStagePosition: oldStagePosition,
            veto: false
		};
		_observer.notify(SliderEvent.PRE_STAGE_CHANGE, eventData);

        if(eventData.veto) {
            _observer.notify(SliderEvent.VETOED_STAGE_CHANGE, eventData);
            return;
        }

        _currentStage = _stages[stagePosition];
        _currentStagePosition = stagePosition;
        _sliderTemplate.switchStage(stagePosition);

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
