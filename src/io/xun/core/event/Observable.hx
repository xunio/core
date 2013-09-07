/*
 * xun.io
 * Copyright (c) 2013 XTAIN oHG, <https://company.xtain.net>
 *
 * Licensed under GNU Affero General Public License
 * For full copyright and license information, please see the LICENSE
 * Redistributions of files must retain the above copyright notice.
 *
 * @copyright     Copyright (c) 2013 XTAIN oHG, <https://company.xtain.net>
 * @link          http://xun.io/ xun.io Project
 * @package       io.xun.core.event
 * @license       http://www.gnu.org/licenses/agpl-3.0.html GNU Affero General Public License
 */

package io.xun.core.event;

/* imports and uses */

import io.xun.core.util.BitwiseMask;
import io.xun.core.util.ObjectMap;

/**
 * Class Observable
 *
 * @author        Maximilian Ruta <mr@xtain.net>
 * @copyright     Copyright (c) 2013 XTAIN oHG, <https://company.xtain.net>
 * @package       io.xun.core.event
 */
class Observable implements IObservable {

    private static var _registry : Array<Observable>;

    private var _observable : IObservable;
    private var _observer : ObjectMap<IObserver, Int>;
    private var _eventObserversCache : Map<Int, Array<IObserver>>;

    private static function getRegistry() : Array<Observable> {
        if (_registry == null) {
            _registry = new Array<Observable>();
        }
        return _registry;
    }

    public function new(observable : IObservable) {
        getRegistry().push(this);
        _observable = observable;
        _observer = new ObjectMap<IObserver, Int>();
        clearEventObserversCache();
    }

    public function clearEventObserversCache() {
        _eventObserversCache = new Map<Int, Array<IObserver>>();
    }

    public function getEventObservers(event : Int) : Array<IObserver> {
        var observers : Array<IObserver>;
        if(_eventObserversCache.exists(event)) {
            return _eventObserversCache.get(event);
        } else {
            observers = new Array<IObserver>();
        }

        for(observer in _observer.keys()) {
            var flags : BitwiseMask = new BitwiseMask(_observer.get(observer));
            if(flags.isZero() || flags.check(event)) {
                observers.push(observer);
            }
        }

        _eventObserversCache.set(event, observers);
        return observers;
    }

    public function notify(event : Int, userData : Dynamic) {
        var observers : Array<IObserver> = getEventObservers(event);
        for(observer in observers.iterator()) {
            var ob : IObserver = observer;
            ob.onUpdate(event, _observable, userData);
        }
    }

    public function attach(o : IObserver, mask : Null<Int> = null) : Void {
        clearEventObserversCache();
        if(mask == null) {
            _observer.set(o, 0);
        } else {
            _observer.set(o, mask);
        }
    }

    public function detach(o : IObserver, mask : Null<Int> = null) : Void {
        if(_observer.exists(o)) {
            clearEventObserversCache();

            var flags : BitwiseMask = new BitwiseMask(_observer.get(o));

            if(mask == null) {
                flags.reset();
            } else {
                flags.unset(mask);
            }

            if(flags.isZero()) {
                _observer.remove(o);
            } else {
                _observer.set(o, flags.get());
            }

        }
    }

}