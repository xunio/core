package js.io.xun.ui.slider;

import io.xun.core.event.IObserver;
import js.html.Element;

interface ISliderTemplate extends IObserver
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
