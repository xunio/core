package js.io.xun.ui.slider;

import js.html.Element;
import io.xun.core.event.IObservable;

interface ISlider implements IObservable
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

}
