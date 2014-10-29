package js.io.xun.ui.slider;

import js.html.Element;
import io.xun.core.event.IObservable;

interface SliderInterface implements IObservable
{
	public function addStage(stage : StageInterface) : Void;

	public function getStage(stagePosition : Int) : StageInterface;

	public function getStages() : Array<StageInterface>;

	public function getContainer() : Element;

	public function getStagesContainer() : Element;

	public function getCurrentStage() : Null<StageInterface>;

	public function getCurrentStagePosition() : Null<Int>;

	public function switchStage(stagePosition : Int) : Void;

	public function switchNextStage() : Void;

	public function switchPrevStage() : Void;

}
