package js.io.xun.ui.slider;

import haxe.Timer;
import js.html.Element;
import js.io.xun.ui.slider.ISlider.SliderEventState;
import js.io.xun.ui.slider.ISlider.SliderEvent;
import io.xun.core.event.IObserver;
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

    private var _timer : Null<Timer> = null;

	public function new(sliderTemplate : ISliderTemplate)
	{
		_sliderTemplate = sliderTemplate;
        _sliderTemplate.setSlider(this);

        _observer = new Observable(this);

        this.attach(
            _sliderTemplate
        );

	}

    public function startTimer( ms : Int) : Void {
        if(_timer != null) {
            _timer.stop();
        }

        _timer = new Timer(ms);
        _timer.run = this.switchNextStage;
    }

    public function stopTimer() : Void {
        if(_timer != null) {
            _timer.stop();
        }
    }

    public function setAnimation(ani : Bool) : Void {
        _sliderTemplate.setAnimation(ani);
        var it = _stages.iterator();
        while(it.hasNext()) {
            it.next().setAnimation(ani);
        }
    }

    public function notify(event : Int, userData : Dynamic) : Void {
        _observer.notify(event, userData);
    }

	public function addStage(stage : IStage) : Void
	{
        // notifiy the stage wich slider it got added
		stage.setSlider(this);

        // set eventData object. Fill it with both new stage data
        var eventData : SliderEventState = {
            stagePosition: _stages.length,
            stage: stage,
            oldStagePosition: null,
            oldStage: null,
            veto: false
        };

        //notify pre stage add event
        _observer.notify(SliderEvent.PRE_STAGE_ADDED, eventData);

        //the stage add got vetoed, throw veto event and breakup operation
        if(eventData.veto) {
            _observer.notify(SliderEvent.VETOED_STAGE_ADDED, eventData);
            return;
        }

        //add stage to the array holder and tell the template that a stage got added
        _stages.push(stage);
        _sliderTemplate.addStage(stage);

        //notify post stage add event
        _observer.notify(SliderEvent.POST_STAGE_ADDED, eventData);

        //run latest init for the added stage
		stage.initialize(_stages.length);

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

    /**
     *  move the slider to the given position
    **/
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
        // set eventData object. Fill it with both old and new stage data
		var eventData : SliderEventState = {
			stagePosition: stagePosition,
			stage: _stages[stagePosition],
            oldStage: oldStage,
            oldStagePosition: oldStagePosition,
            veto: false
		};

        //notify pre stage change event
		_observer.notify(SliderEvent.PRE_STAGE_CHANGE, eventData);

        //the stage change got vetoed, throw veto event and breakup operation
        if(eventData.veto) {
            _observer.notify(SliderEvent.VETOED_STAGE_CHANGE, eventData);
            return;
        }

        //set the current state to the new position
        _currentStage = _stages[stagePosition];
        _currentStagePosition = stagePosition;

        // tell the template that the positions got changed
        _sliderTemplate.switchStage(stagePosition);

        // hide the old stage and show the new one
        if(_sliderTemplate.getAnimation()) {
            if (oldStage != null  && oldStage.getAnimation()) {
                oldStage.hide();
            }

            if(_currentStage.getAnimation()) {
                _currentStage.show();
            }
        }

        //notify post stage change event
		_observer.notify(SliderEvent.POST_STAGE_CHANGE, eventData);
	}

    /**
     *  move the slider to the position before the current one
    **/
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

    /**
     *  move the slider to the position after the current one
    **/
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
