package js.io.xun.ui.slider;

import js.html.Element;

class DefaultStage implements IStage
{
    var _slider : ISlider;
    var stageContainer : JQuery;
    var buttonContainer : JQuery;

    public function setSlider(slider:ISlider):Void {
        _slider = slider;
    }

    public function getContainer():Element {
        return stageContainer.get(0);
    }
    public function getButton(): Null<Element> {
        return buttonContainer.get(0);
    }

    public function show():Void {
        new JQuery(getContainer()).show();
    }

    public function hide():Void {
        new JQuery(getContainer()).hide();
    }

    public function initialize():Void {
    }

    public function new( content : String ) {
        stageContainer = new JQuery('<li>' + content + '</li>');

        buttonContainer = new JQuery('<li>' + content + '</li>');
	}
}
