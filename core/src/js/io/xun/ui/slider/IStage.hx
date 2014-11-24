package js.io.xun.ui.slider;

import js.html.Element;

interface IStage
{
    public function setSlider(slider : ISlider) : Void;

    public function getContainer() : Element;
    public function getButton() : Null<Element>;

    public function show() : Void;

    public function hide() : Void;

    public function initialize(pos : Int) : Void;

    public function getAnimation() : Bool;
    public function setAnimation(ani : Bool) : Void;
}
