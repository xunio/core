package js.io.xun.ui.slider;

import js.html.Element;

interface IStage
{
	public function setSlider(slider : ISlider);

	public function getContent() : Element;

	public function show() : Void;

	public function hide() : Void;

	public function initialize() : Void;
}
