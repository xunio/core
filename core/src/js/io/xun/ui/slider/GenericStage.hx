package js.io.xun.ui.slider;

import js.html.Element;

class GenericStage implements IStage {

    var _animation : Bool = true;

    var _stageContainer : Element;
    var _buttonContainer : Element;

    var _showClass : String;
    var _activeClass : String;


    public function setSlider(slider:ISlider):Void {
    }

    public function getContainer():Element {
        return _stageContainer;
    }

    public function getButton():Null<Element> {
        return _buttonContainer;
    }

    public function show():Void {
        var jqsc : JQuery = new JQuery(_stageContainer);
        if(_showClass == "")
            jqsc.show();
        else
            jqsc.addClass(_showClass);

        if(getButton() != null && _activeClass != "") {
            new JQuery(getButton()).addClass(_activeClass);
        }
    }

    public function hide():Void {
        var jqsc : JQuery = new JQuery(_stageContainer);
        if(_showClass == "")
            jqsc.hide();
        else
            jqsc.removeClass(_showClass);

        if(getButton() != null && _activeClass != "") {
            new JQuery(getButton()).removeClass(_activeClass);
        }
    }

    public function initialize(pos:Int):Void {
    }

    public function getAnimation():Bool {
        return _animation;
    }

    public function setAnimation(ani:Bool):Void {
        _animation = ani;
    }

    public function new(
        stageContainer : Element, buttonContainer : Element, ?showClass : String = "", ?activeClass : String = ""
    ) {
        _stageContainer = stageContainer;

        _buttonContainer = buttonContainer;

        _showClass = showClass;
        _activeClass = activeClass;
    }
}
