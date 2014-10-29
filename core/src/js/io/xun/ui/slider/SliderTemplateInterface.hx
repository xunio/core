package js.io.xun.ui.slider;

import js.html.Element;

interface SliderTemplateInterface
{
	public function addStage(stage : StageInterface) : Void;

	public function switchStage(stagePosition : Int) : Void;

	public function getContainer() : Element;

	public function getStagesContainer() : Element;

	public function getStageContainer(stage : StageInterface) : Element;

	public function getNextButton() : Null<Element>;

	public function getPrevButton() : Null<Element>;

	public function getSlideButtonContainer() : Null<Element>;
}
