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

import haxe.Timer;
import js.JQuery.JqEvent;
import js.html.Document;
import io.xun.core.event.IObserver;
import io.xun.core.event.Observable;
import io.xun.core.event.IObservable;

/**
 * Class Window
 *
 * @author        Maximilian Ruta <mr@xtain.net>
 * @copyright     Copyright (c) 2014 XTAIN oHG, <https://company.xtain.net>
 * @package       js.io.xun.ui.ec
 */
class Window implements IObservable {

    public static inline var EVENT_GAP = 300;
    private static var eventBound : Bool = false;
    private static var instance : Null<Window> = null;
    private static var observable : Observable;
    private static var resizing : Bool = false;
    private static var timer : Null<Timer> = null;

    private static function stop() {
        resizing = false;
        observable.notify(WindowEvent.RESIZE_STOP, null);
    }

    private static function onResize() {
        if (!resizing) {
            resizing = true;
            observable.notify(WindowEvent.RESIZE_START, null);
        }
        observable.notify(WindowEvent.RESIZE, null);
        if (timer != null) {
            timer.stop();
        }
        timer = Timer.delay(stop, EVENT_GAP);
    }

    private static function bindEvent() {
        if (!eventBound) {
            eventBound = true;
            trace('bind');
            new JQuery(js.Browser.window).resize(function(e : JqEvent) : Void {
                if (untyped e.target == js.Browser.window) {
                    onResize();
                }
            });
        }
    }

    private function new() {
        observable = new Observable(this);
    }

    public static function getInstance() : Window {
        if (instance == null) {
            instance = new Window();
        }
        return instance;
    }

    public function attach(o : IObserver, mask : Null<Int> = 0) : Void {
        bindEvent();
        observable.attach(o, mask);
    }

    public function detach(o : IObserver, mask : Null<Int> = 0) : Void {
        observable.detach(o, mask);
    }

}

/**
 * Class WindowEvent
 *
 * @author        Maximilian Ruta <mr@xtain.net>
 * @copyright     Copyright (c) 2013 XTAIN oHG, <https://company.xtain.net>
 * @package       js.io.xun.ui.ec.Window
 */
@:build(io.xun.core.event.ObserverMacro.create([
RESIZE_START,
RESIZE,
RESIZE_STOP,
FAR
]))
class WindowEvent {
    public inline static var RESIZE_START;
    public inline static var RESIZE;
    public inline static var RESIZE_STOP;
    public inline static var GROUP_ID;
    public inline static var GROUP_MASK;
    public inline static var EVENT_MASK;
}

