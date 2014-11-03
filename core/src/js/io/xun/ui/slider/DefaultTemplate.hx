package js.io.xun.ui.slider;

import js.JQuery;
import js.html.Element;

class DefaultTemplate implements ISliderTemplate
{
    var _container : JQuery;

    public function addStage(stage:IStage):Void {
    }

    public function switchStage(stagePosition:Int):Void {
    }

    public function getContainer():Element {
        return _container.get(0);
    }

    public function getStagesContainer():Element {
        return _container.find(".stagesContainer").get(0);
    }

    public function getStageContainer(stage:IStage):Element {
        return stage.getContent();
    }

    public function getNextButton():Null<Element> {
        return _container.find(".next").get(0);
    }

    public function getPrevButton():Null<Element> {
        return _container.find(".prev").get(0);
    }

    public function getSlideButtonContainer():Null<Element> {
        return _container.find(".slideButtons").get(0);
    }

    public function new(mainElement : Element) {
        _container = new JQuery(mainElement);
	}
}
