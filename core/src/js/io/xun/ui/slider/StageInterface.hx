package js.io.xun.ui.slider;

import js.html.Element;

interface StageInterface
{
	public function setSlider(slider : SliderInterface);

	public function getContent() : Element;

	public function show() : Void;

	public function hide() : Void;

	public function initialize() : Void;
}
