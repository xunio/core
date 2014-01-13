/*
 * xun.io
 * Copyright (c) 2014 XTAIN oHG, <https://company.xtain.net>
 *
 * Licensed under GNU Affero General Public License
 * For full copyright and license information, please see the LICENSE
 * Redistributions of files must retain the above copyright notice.
 *
 * @copyright     Copyright (c) 2014 XTAIN oHG, <https://company.xtain.net>
 * @link          http://xun.io/ xun.io Project
 * @package       js.io.xun.ui.ec
 * @license       http://www.gnu.org/licenses/agpl-3.0.html GNU Affero General Public License
 */

package js.io.xun.ui.ec;

import io.xun.core.util.Std;
import io.xun.core.event.IObserver;
import io.xun.core.event.Observable;
import io.xun.core.event.IObservable;
import haxe.ds.ObjectMap;
import js.JQuery;
import js.html.Element;

/**
 * Class NearElement
 *
 * @author        Maximilian Ruta <mr@xtain.net>
 * @copyright     Copyright (c) 2014 XTAIN oHG, <https://company.xtain.net>
 * @package       js.io.xun.ui.ec
 */
class NearElement implements IObservable {

    public var distance(default, null) : Int;
    private var observable : Observable;
    private var isNear : Null<Bool> = null;
    private static var elements : Null<ObjectMap<NearElement, JQuery>> = null;

    /**
     * Constructor
     *
     * @author Maximilian Ruta <mr@xtain.net>
     */
    public function new(element : Element, distance : Int = 20) {
        this.distance = distance;
        observable = new Observable(this);

        if (elements == null) {
            elements = new ObjectMap<NearElement, JQuery>();
            new JQuery(js.Browser.document.body).mousemove(function(event : JqEvent) : Void {
                check(event.pageX, event.pageY);
            });
        }

        elements.set(this, new JQuery(element));
    }

    public function near() {
        if (isNear == null || !isNear) {
            isNear = true;
            trace('near enter');
            observable.notify(NearElementEvent.NEAR_ENTER, null);
        }
        observable.notify(NearElementEvent.NEAR, null);
    }

    public function far() {
        if (isNear == null || isNear) {
            isNear = false;
            trace('near leave');
            observable.notify(NearElementEvent.NEAR_LEAVE, null);
        }
        observable.notify(NearElementEvent.FAR, null);
    }

    private static function check(x : Int, y : Int) : Void {
        var object : NearElement;
        var element : JQuery;
        var distance : Int;
        var d2 : Int;
        var left : Int;
        var top : Int;
        var right : Int;
        var bottom : Int;

        for (object in elements.keys()) {
            element = elements.get(object);
            if (!Std.isUndefined(element)) {
                distance = object.distance;
                d2 = 2 * distance;
                left = element.offset().left - distance;
                top = element.offset().top - distance;
                right = left + element.width() + d2;
                bottom = top + element.height() + d2;

                if ( x > left && x < right && y > top && y < bottom ) {
                    object.near();
                } else {
                    object.far();
                }
            }
        }
    }

    public function destroy() : Void {
        elements.remove(this);
    }

    public function attach(o : IObserver, mask : Null<Int> = 0) : Void {
        observable.attach(o, mask);
    }

    public function detach(o : IObserver, mask : Null<Int> = 0) : Void {
        observable.detach(o, mask);
    }

}

/**
 * Class NearElementEvent
 *
 * @author        Maximilian Ruta <mr@xtain.net>
 * @copyright     Copyright (c) 2013 XTAIN oHG, <https://company.xtain.net>
 * @package       js.io.xun.ui.ec.NearElement
 */
@:build(io.xun.core.event.ObserverMacro.create([
NEAR_ENTER,
NEAR_LEAVE,
NEAR,
FAR
]))
class NearElementEvent {
    public inline static var NEAR_ENTER;
    public inline static var NEAR_LEAVE;
    public inline static var NEAR;
    public inline static var FAR;
    public inline static var GROUP_ID;
    public inline static var GROUP_MASK;
    public inline static var EVENT_MASK;
}

