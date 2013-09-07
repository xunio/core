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
 * @package       io.xun.test.unit.core.event
 * @license       http://www.gnu.org/licenses/agpl-3.0.html GNU Affero General Public License
 */

package io.xun.test.unit.core.event;

/* imports and uses */

import io.xun.core.event.IObservable;
import io.xun.core.event.IObserver;
import io.xun.core.event.Observable;


/**
 * Class TestObservable
 *
 * @author        Maximilian Ruta <mr@xtain.net>
 * @copyright     Copyright (c) 2013 XTAIN oHG, <https://company.xtain.net>
 * @package       io.xun.test.unit.core.event
 */
class TestObservable extends haxe.unit.TestCase {
    /*
    public function testConstruct() {
        var mockObservable : MockObservable = new MockObservable();
        assertTrue(true);
    }

    public function testAttach() {
        var mockObservable : MockObservable = new MockObservable();

        var mockObserver : MockObserver = new MockObserver();
        mockObservable.attach(mockObserver, 1);

        assertEquals(null, mockObserver.data);
        mockObservable.observable.notify(1, 'foo');
        assertEquals('foo', mockObserver.data);
    }

    public function testDetach() {
        var mockObservable : MockObservable = new MockObservable();

        var mockObserver : MockObserver = new MockObserver();
        mockObservable.attach(mockObserver, 1);

        assertEquals(null, mockObserver.data);
        mockObservable.observable.notify(1, 'foo');

        assertEquals('foo', mockObserver.data);
        mockObservable.detach(mockObserver);
        mockObservable.observable.notify(1, 'foo1');
        assertEquals('foo', mockObserver.data);
    }

    public function testMaskDetach() {
        var mockObservable : MockObservable = new MockObservable();

        var mockObserver : MockObserver = new MockObserver();
        mockObservable.attach(mockObserver, 1 | 2);

        assertEquals(null, mockObserver.data);
        mockObservable.observable.notify(1, 'foo');

        assertEquals('foo', mockObserver.data);
        mockObservable.detach(mockObserver, 1);
        mockObservable.observable.notify(1, 'foo1');
        assertEquals('foo', mockObserver.data);
        mockObservable.observable.notify(2, 'foo2');
        assertEquals('foo2', mockObserver.data);
    }

    public function testCorrectCalling() {
        var mockObservable : MockObservable = new MockObservable();

        var mockObserver : MockObserver = new MockObserver();
        mockObservable.attach(mockObserver, 1);

        assertEquals(null, mockObserver.data);
        mockObservable.observable.notify(1, 'foo');
        assertEquals('foo', mockObserver.data);
        mockObservable.observable.notify(3, 'foo2');
        assertEquals('foo', mockObserver.data);
        mockObservable.observable.notify(2, 'foo1');
        assertEquals('foo', mockObserver.data);
    }
    */
    public function testGetEventObservers() {
        var mockObservable : MockObservable = new MockObservable();
        var mockObserver : MockObserver = new MockObserver();
        mockObservable.attach(mockObserver, 1 | 2);

        var observers : Array<IObserver> = mockObservable.observable.getEventObservers(1);
        assertEquals(1, observers.length);
        var observers : Array<IObserver> = mockObservable.observable.getEventObservers(2);
        assertEquals(1, observers.length);
        var observers : Array<IObserver> = mockObservable.observable.getEventObservers(3);
        assertEquals(1, observers.length);
        var observers : Array<IObserver> = mockObservable.observable.getEventObservers(4);
        assertEquals(0, observers.length);
    }

}

/**
 * Class MockObservable
 *
 * @author        Maximilian Ruta <mr@xtain.net>
 * @copyright     Copyright (c) 2013 XTAIN oHG, <https://company.xtain.net>
 * @package       io.xun.test.unit.core.event.TestObservable
 */
class MockObservable implements IObservable {

    public var observable : Observable;

    public function new() {
        observable = new Observable(this);
    }

    public function attach( o : IObserver, mask : Null<Int> = 0 ) : Void {
        observable.attach(o, mask);
    }

    public function detach( o : IObserver, mask : Null<Int> = null ) : Void {
        observable.detach(o, mask);
    }

}

/**
 * Class MockObserver
 *
 * @author        Maximilian Ruta <mr@xtain.net>
 * @copyright     Copyright (c) 2013 XTAIN oHG, <https://company.xtain.net>
 * @package       io.xun.test.unit.core.event.TestObservable
 */
class MockObserver implements IObserver {

    public var data : Null<Dynamic> = null;

    public function new() {
    }

    public function onUpdate( type : Int, source : IObservable, userData : Dynamic ) : Void {
        data = userData;
    }

}