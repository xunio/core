package js.io.xun.ui.ec;

import io.xun.core.event.IObservable;
import io.xun.core.event.IObserver;
import io.xun.core.event.Observable;
import js.JQuery;
import js.html.Element;


class PinnedElement implements IObservable {

    private var _element : JQuery;
    private var _containerElement : JQuery;
    private var _observer : Observable;
    private var _isPinned : Bool = false;
    private var _offset : { top : Int, left : Int };

    public function new(element : Element) {
        this._element = new JQuery(element);
        this._containerElement = new JQuery(js.Browser.window);

        bindEvents();
        calculateOffset();
        _observer = new Observable(this);
    }

    public function getElement() : Element {
        return _element.get()[0];
    }

    private function pin() {
        if(!_isPinned) {
            _observer.notify(PinnedElementEvent.PIN, null);
            _isPinned = true;
        }
    }

    private function unpin() {
        if(_isPinned) {
            _observer.notify(PinnedElementEvent.UNPIN, null);
            _isPinned = false;
        }
    }

    private function calculateOffset() {
        var offset = _element.offset();
        _offset = {
            top: Math.round(offset.top),
            left: Math.round(offset.left)
        }
    }

    private function checkOutOfBoundaries() {
        var scrollTop : Int = _containerElement.scrollTop();
        var scrollLeft : Int = _containerElement.scrollLeft();

        if(_offset.left < scrollLeft || _offset.top < scrollTop) {
            pin();
        } else {
            unpin();
        }
    }

    private function resizeCheck() {
        unpin();
        calculateOffset();
        checkOutOfBoundaries();
    }

    private function bindEvents() {
        _containerElement.scroll(function(event : js.JqEvent) {
            checkOutOfBoundaries();
        });
        new JQuery(js.Browser.window).resize(function(event : js.JqEvent) {
            resizeCheck();
        });
    }

    public function attach(o : IObserver, mask : Null<Int> = 0) : Void {
        _observer.attach(o, mask);
    }

    public function detach(o : IObserver, mask : Null<Int> = null) : Void {
        _observer.detach(o, mask);
    }

}

@:build(io.xun.core.event.ObserverMacro.create([
    PIN,
    UNPIN
]))
class PinnedElementEvent {
    public inline static var PIN;
    public inline static var UNPIN;
    public inline static var GROUP_ID;
    public inline static var GROUP_MASK;
    public inline static var EVENT_MASK;
}

