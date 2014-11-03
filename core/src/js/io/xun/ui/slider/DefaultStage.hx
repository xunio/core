package js.io.xun.ui.slider;

import js.html.Element;
class DefaultStage implements IStage
{
    var _slider : ISlider;

    public function setSlider(slider:ISlider):Void {
        _slider = slider;
    }

    public function getContent():Element {
        return js.Browser.document.body;
    }

    public function show():Void {
        new JQuery(getContent()).show();
    }

    public function hide():Void {
        new JQuery(getContent()).hide();
    }

    public function initialize():Void {
    }

    public function new( ) {
	}
}
