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
    private var _interval : Int;
    private var _offset : { top : Int, left : Int };

    private inline static var FORCE_RECHECK = 1500;

    public function new(element : Element) {
        this._element = new JQuery(element);
        this._containerElement = new JQuery(js.Browser.window);

        bindEvents();
        calculateOffset();
        _observer = new Observable(this);

        _interval = js.Browser.window.setInterval(function() {
            trace(_element.get()[0]);
            if(!JQuery.contains(js.Browser.document.documentElement, _element.get()[0])) {
                destroy();
            } else {
                resizeCheck();
            }
        }, FORCE_RECHECK);

        resizeCheck();
    }

    public function destroy() {
        js.Browser.window.clearInterval(_interval);
        _containerElement.unbind('scroll', scrollCallback);
        new JQuery(js.Browser.window).unbind('resize', resizeCallback);
        _observer = null;
    }

    public function getElement() : Element {
        return _element.get()[0];
    }

    private function pin() {
        if(!_isPinned) {
            trace('pin');
            _observer.notify(PinnedElementEvent.PIN, null);
            _isPinned = true;
        }
    }

    private function unpin() {
        if(_isPinned) {
            trace('unpin');
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

    public function resizeCheck() {
        unpin();
        calculateOffset();
        checkOutOfBoundaries();
    }

    private function resizeCallback(event : js.JqEvent) {
        resizeCheck();
    }

    private function scrollCallback(event : js.JqEvent) {
        checkOutOfBoundaries();
    }

    private function bindEvents() {
        _containerElement.bind('scroll', scrollCallback);
        new JQuery(js.Browser.window).bind('resize', resizeCallback);
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

