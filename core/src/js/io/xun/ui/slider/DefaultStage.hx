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
        var j : JQuery = new JQuery(getContainer());
        //j.scrollLeft(25);
        //j.show();
        j.fadeIn(300);
        //j.scrollLeft(25);
    }

    public function hide():Void {
        var j : JQuery = new JQuery(getContainer());
        //j.scrollLeft(-25);
        j.fadeOut(300);
        //j.hide();
        //j.scrollLeft(-25);
    }

    public function initialize():Void {
    }

    public function new( content : String ) {
        stageContainer = new JQuery('<li>' + content + '</li>');

        buttonContainer = new JQuery('<li>' + content + '</li>');
	}
}
