package js.io.xun.ui.slider;
import js.html.Element;
import io.xun.core.event.IObservable;
import io.xun.core.event.Observable;
import io.xun.core.event.IObserver;

@:expose
class GenericTemplate implements ISliderTemplate implements IObserver
{

    private var _observer : Observable;
    var _container : JQuery;
    var _animation : Bool = true;

    var _stagesContainer : String;
    var _nextButton : String;
    var _prevButton : String;
    var _buttonContainer : String;

    public function getObserver() : IObserver {
        return this;
    }

    public function setSlider(slider:ISlider):Void {
    }

    public function addStage(stage:IStage):Void {
    }

    public function switchStage(stagePosition:Int):Void {
    }

    public function getContainer():Element {
        return _container.get(0);
    }

    public function getStagesContainer():Element {
        return getElement(_stagesContainer);
    }

    public function getStageContainer(stage:IStage):Element {
        return stage.getContainer();
    }

    public function getStageButton(stage:IStage):Null<Element> {
        return stage.getButton();
    }

    public function getNextButton():Null<Element> {
        return getElement(_nextButton);
    }

    public function getPrevButton():Null<Element> {
        return getElement(_prevButton);
    }

    public function addStageButton(stage:IStage):Void {
    }

    public function getSlideButtonContainer():Null<Element> {
        return getElement(_buttonContainer);
    }

    public function getSlideButtonsPerPage(idx:Int):Array<Element> {
        return [];
    }

    public function getSlideButtonPageContainer(idx:Int):Null<Element> {
        return null;
    }

    public function getSlideButtonPageButtonContainer():Null<Element> {
        return null;
    }

    public function getSlideButtonPagesContainer():Null<Element> {
        return null;
    }

    public function getAnimation():Bool {
        return _animation;
    }

    public function setAnimation(ani:Bool):Void {
        _animation = ani;
    }

    public function onUpdate(type:Int, source:IObservable, userData:Dynamic):Void {
    }

    public function attach(o : IObserver, mask : Null<Int> = 0):Void {
        _observer.attach(o, mask);
    }

    public function detach(o : IObserver, mask : Null<Int> = null):Void {
        _observer.detach(o, mask);
    }


    public function new(mainElement : Element, stagesContainer : String, ?nextButton : String, ?prevButton : String, ?buttonContainer : String) {
        _container = new JQuery(mainElement);
        _observer = new Observable(this);

        _stagesContainer = stagesContainer;
        _nextButton = nextButton;
        _prevButton = prevButton;
        _buttonContainer = buttonContainer;

        this.attach(this);
    }

    private function getElement(name : String) : Null<Element> {
        if(name == "")
            return null;

        var jq : JQuery = _container.find(name);
        return jq.length == 0 ? null : jq.get(0);
    }

}
