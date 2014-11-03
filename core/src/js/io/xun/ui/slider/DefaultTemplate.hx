package js.io.xun.ui.slider;

import js.JQuery;
import js.html.Element;

class DefaultTemplate implements ISliderTemplate
{
    var _container : JQuery;

    public function addStage(stage:IStage):Void {
        new JQuery(getStagesContainer()).append(stage.getContainer());

        // add buttons but only if both the template and the stage does support it
        var buttons : Null<Element> = getSlideButtonContainer();
        if (buttons != null) {
            var button : Null<Element> = stage.getButton();
            if(button != null) {
                new JQuery(buttons).append(button);
            }
        }
    }

    public function switchStage(stagePosition:Int):Void {
    }

    public function getContainer():Element {
        return _container.get(0);
    }

    public function getStagesContainer():Element {
        return getElement(".stagesContainer");
    }

    public function getStageContainer(stage:IStage):Element {
        return stage.getContainer();
    }

    public function getNextButton():Null<Element> {
        return getElement(".next");
    }

    public function getPrevButton():Null<Element> {
        return getElement(".prev");
    }

    public function getSlideButtonContainer():Null<Element> {
        return getElement(".slideButtons");
    }

    public function new(mainElement : Element) {
        _container = new JQuery(mainElement);
	}

    private function getElement(name : String) {
        return _container.find(name).get(0);
    }
}
