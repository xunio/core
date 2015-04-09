package js.io.xun.ui.slider;

import js.JQuery;
import js.html.Element;

class PageSliderTemplate extends GenericTemplate {

    var _slider : ISlider;

    var _page_template : ISliderTemplate;
    var _page_slider : ISlider;

    var _boubles : String;

    /*



     */

    public function new(
        mainElement : Element, stagesContainer : String, ?nextButton : String, ?prevButton : String, buttonContainer : String,
        boubles : String, pageStages : String, pagesButtonContainer : String, pageButtons : String, ?showClass : String, ?activeClass : String
    ) {
        super(mainElement,stagesContainer,nextButton,prevButton,buttonContainer);

        var mjq : JQuery = new JQuery(mainElement);

        _boubles = boubles;

        _page_template = new GenericTemplate(mainElement, buttonContainer, null, null, pagesButtonContainer);
        _page_slider = new js.io.xun.ui.slider.Slider(_page_template);


        var pbjq = mjq.find(pageButtons);

        mjq.find(pageStages).each(function( idx : Int, el : Element ){
            var stage : IStage = new GenericStage(el, pbjq.get(idx), showClass, activeClass);
            _page_slider.addStage(stage);
            stage.hide();
            new JQuery(pbjq.get(idx)).click(function(){
                _page_slider.switchStage(idx);
            });
        });
    }

    override public function setSlider(slider:ISlider):Void {
        _slider = slider;
    }

    override public function switchStage(stagePosition:Int):Void {
        var sum : Int = 0;

        for (i in 0 ... (_page_slider.getStages().length)) {
            sum += new JQuery(_page_slider.getStage(i).getContainer()).find(_boubles).length;

            if(sum > stagePosition){
                _page_slider.switchStage(i);
                break;
            }
        }


    }

    override public function getSlideButtonsPerPage(idx:Int):Array<Element> {
        var count : Int = 0;
        var sum : Int = 0;

        for (i in 0 ... (idx + 1)) {
            sum += count;
            count = new JQuery(_page_slider.getStage(i).getContainer()).find(_boubles).length;
        }

        return _slider.getStages().slice(sum, count).map(function(stage : IStage) { return stage.getButton();});
    }

    override public function getSlideButtonPageContainer(idx:Int):Null<Element> {
        return _page_template.getStageContainer(_page_slider.getStage(idx));
    }

    override public function getSlideButtonPagesContainer():Null<Element> {
        return _page_template.getSlideButtonContainer();
    }
}
