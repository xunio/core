/*
 * xun.io
 * Copyright (c) 2013, XTAIN oHG <https://company.xtain.net>
 *
 * Licensed under GNU Affero General Public License
 * For full copyright and license information, please see the LICENSE
 * Redistributions of files must retain the above copyright notice.
 *
 * @copyright     Copyright (c) 2013, XTAIN oHG <https://company.xtain.net>
 * @link          http://xun.io/ xun.io Project
 * @package       io.xun.test.unit.core.dependencyinjection
 * @license       http://www.gnu.org/licenses/agpl-3.0.html GNU Affero General Public License
 */

package io.xun.test.unit.core.dependencyinjection;

import io.xun.core.dependencyinjection.exception.ServiceCircularReferenceException;
import io.xun.core.dependencyinjection.exception.ServiceNotFoundException;
import io.xun.core.exception.Exception;
import io.xun.core.dependencyinjection.parameterbag.IParameterBag;
import io.xun.core.exception.RuntimeException;
import io.xun.core.dependencyinjection.Scope;
import io.xun.core.exception.InvalidArgumentException;
import io.xun.core.dependencyinjection.parameterbag.FrozenParameterBag;
import io.xun.core.dependencyinjection.parameterbag.ParameterBag;
import io.xun.core.dependencyinjection.IContainer.IContainerConst;
import io.xun.core.dependencyinjection.ref.Parameter;
import io.xun.core.dependencyinjection.Container;

/**
 * Class TestContainer
 *
 * @author        Maximilian Ruta <mr@xtain.net>
 * @copyright     Copyright (c) 2013, XTAIN oHG <https://company.xtain.net>
 * @package       io.xun.test.unit.core.dependencyinjection
 */
class TestContainer extends haxe.unit.TestCase {

    public function testConstructor() {
        var container : Container = new Container();
        assertEquals(container, container.get(Container.CONTAINER));

        var parameter : Parameter = new Parameter('foo', 'bar');
        var parameterBag : ParameterBag = new ParameterBag();
        parameterBag.set(parameter);
        container = new Container(parameterBag);
        assertEquals('bar', container.getParameterBag().get('foo').value);
    }

    public function testIsFrozen() {
        var container : Container = new Container();
        assertFalse(container.isFrozen());
        container.compile();
        assertTrue(container.isFrozen());
    }

    public function testCompile() {
        var parameter : Parameter = new Parameter('foo', 'bar');
        var parameterBag : ParameterBag = new ParameterBag();
        parameterBag.set(parameter);
        var container : Container = new Container(parameterBag);
        container.compile();
        assertTrue(Std.is(container.getParameterBag(), FrozenParameterBag));
        assertEquals('bar', container.getParameterBag().get('foo').value);
    }

    public function testParameter() {
        var container : Container = new Container();
        var parameter : Parameter = new Parameter('foo', 'baa');

        assertFalse(container.hasParameter('foo'));
        container.setParameter(parameter);
        assertTrue(container.hasParameter('foo'));
        assertEquals(parameter.value, container.getParameter('foo').value);
    }

    public function testGetSetParameter() {
        var parameter : Parameter = new Parameter('foo', 'bar');
        var parameterBag : ParameterBag = new ParameterBag();
        parameterBag.set(parameter);
        var container : Container = new Container(parameterBag);

        container.setParameter(new Parameter('bar', 'foo'));
        assertEquals('foo', container.getParameter('bar').value);

        container.setParameter(new Parameter('foo', 'baz'));
        assertEquals('baz', container.getParameter('foo').value);

        container.setParameter(new Parameter('Foo', 'baz1'));
        assertEquals('baz1', container.getParameter('foo').value);
        assertEquals('baz1', container.getParameter('FOO').value);
    }

    public function testSet() {
        var container : Container = new Container();

        assertFalse(container.has('foo'));
        container.set('foo', 'foo2');
        assertTrue(container.has('foo'));

        assertFalse(container.has('foo1'));
        container.set('foo1', 'foo3');
        assertTrue(container.has('foo1'));
    }

    public function testSetWithNullResetTheService() {
        var container : Container = new Container();
        container.set('foo1', null);
        assertFalse(container.has('foo1'));
    }

    public function testSetDoesNotAllowPrototypeScope() {
        var container : Container = new Container();
        try {
            container.set('foo', new Array<Int>(), 'prototype');
            assertTrue(false);
        } catch(e : InvalidArgumentException) {
            assertTrue(true);
        } catch(e : Dynamic) {
            assertTrue(false);
        }
    }

    public function testSetDoesNotAllowInactiveScope() {
        var container : Container = new Container();
        container.addScope(new Scope('foo'));
        try {
            container.set('foo', new Array<Int>(), 'foo');
            assertTrue(false);
        } catch(e : RuntimeException) {
            assertTrue(true);
        } catch(e : Dynamic) {
            assertTrue(false);
        }
    }

    public function testMethodName() {
        assertEquals('getFooService', Container.getMethodName('foo'));
        assertEquals('getFooBaaService', Container.getMethodName('foo.baa'));
        assertEquals('getFooBaaService', Container.getMethodName('foo_baa'));
    }

    public function testHas() {
        var container : ExtendedContainer = new ExtendedContainer();

        assertFalse(container.has('foo'));
        container.set('foo', 'foo2');
        assertTrue(container.has('foo'));

        assertTrue(container.has('baa_da'));

        container.set('foo', ['foo']);
        assertFalse(container.has('foo1'));
        assertTrue(container.has('foo'));
        assertTrue(container.has('bar'));
        assertTrue(container.has('foo_bar'));
        assertTrue(container.has('foo.baz'));

    }

    public function testGet() {
        var container : ExtendedContainer = new ExtendedContainer();
        var foo : Array<String> = ['foo'];
        var bar : Array<String> = ['bar'];

        container.set('foo', foo);
        assertEquals(foo, container.get('foo'));

        assertEquals(container.__bar, container.get('bar'));
        assertEquals(container.__foo_bar, container.get('foo_bar'));
        assertEquals(container.__foo_baz, container.get('foo.baz'));

        container.set('bar', foo);
        assertEquals(foo, container.get('bar'));

        try {
            container.get('');
            assertTrue(false);
        } catch(e : Exception) {
            assertTrue(true);
        } catch(e : Dynamic) {
            assertTrue(false);
        }
    }

    public function testGetServiceIds() {
        var container : ExtendedContainer = new ExtendedContainer();

        container.set('foo', 'foo2');
        container.set('foo1', 'foo3');

        var services : Array<String> = [Container.CONTAINER, 'scoped', 'scoped_foo', 'baa_da', 'bar', 'foo_bar', 'foo_baz', 'foo', 'foo1', 'circular'];
        var valid : Int = 0;

        for ( service in container.getServiceIds() ) {
            if (Lambda.has(services, service)) {
                assertTrue(true);
                valid++;
            } else {
                throw new Exception('service "' + service + '" not expected!');
            }
        }

        assertEquals(services.length, valid);

    }

    public function testGetThrowServiceNotFoundException() {
        var container : ExtendedContainer = new ExtendedContainer();

        container.set('foo', ['test1']);
        container.set('bar', ['test2']);
        container.set('baz', ['test3']);

        try {
            container.get('foo1');
            assertTrue(false);
        } catch(e : ServiceNotFoundException) {
            assertTrue(true);
        } catch(e : Dynamic) {
            assertTrue(false);
        }

        try {
            container.get('bag');
            assertTrue(false);
        } catch(e : ServiceNotFoundException) {
            assertTrue(true);
        } catch(e : Dynamic) {
            assertTrue(false);
        }
    }

    public function testGetCircularReference() {
        var container : ExtendedContainer = new ExtendedContainer();

        try {
            container.get('circular');
            assertTrue(false);
        } catch (e : ServiceCircularReferenceException) {
            assertTrue(true);
        } catch(e : Dynamic) {
            assertTrue(false);
        }
    }

    public function testGetReturnsNullOnInactiveScope() {
        var container : ExtendedContainer = new ExtendedContainer();
        assertEquals(null, container.get('inactive', IContainerConst.NULL_ON_INVALID_REFERENCE));
    }

    public function testInitialized() {
        var container : ExtendedContainer = new ExtendedContainer();

        container.set('foo', ['foo']);
        assertTrue(container.initialized('foo'));
        assertFalse(container.initialized('foo1'));
        assertFalse(container.initialized('baa'));
    }


    public function testHasScope() {
        var container : ExtendedContainer = new ExtendedContainer();
        container.addScope(new Scope('foo'));
        assertTrue(container.hasScope('foo'));
    }
    /*
    public function testEnterLeaveCurrentScope() {
        var container : ExtendedContainer = new ExtendedContainer();

        container.addScope(new Scope('foo'));

        container.enterScope('foo');
        var scoped1 : Array<String> = container.get('scoped');
        var scopedFoo1 : Dynamic = container.get('scoped_foo');

        container.enterScope('foo');
        var scoped2 : Array<String> = container.get('scoped');
        var scoped3 : Array<String> = container.get('scoped');
        var scopedFoo2 : Array<String> = container.get('scoped_foo');

        container.leaveScope('foo');
        var scoped4 : Array<String> = container.get('scoped');
        var scopedFoo3 : Array<String> = container.get('scoped_foo');

        assertTrue(scoped1 != scoped2);

        scoped2.push('test');
        scoped3.push('test2');
        assertEquals(scoped2.length, scoped3.length);
        assertEquals(scoped2[0], scoped3[0]);
        assertEquals(scoped2[1], scoped3[1]);
        assertEquals(scoped2[2], scoped3[2]);

        scoped1.push('foo');
        scoped4.push('foo2');
        assertEquals(scoped1.length, scoped4.length);
        assertEquals(scoped1[0], scoped4[0]);
        assertEquals(scoped1[1], scoped4[1]);
        assertEquals(scoped1[2], scoped4[2]);

        assertTrue(scopedFoo1 != scopedFoo2);

        scopedFoo1.push('foo2');
        scopedFoo3.push('foo3');
        assertEquals(scopedFoo1.length, scopedFoo3.length);
        assertEquals(scopedFoo1[0], scopedFoo3[0]);
        assertEquals(scopedFoo1[1], scopedFoo3[1]);
        assertEquals(scopedFoo1[2], scopedFoo3[2]);

    }
    */

}

/**
 * Class ExtendedContainer
 *
 * @author        Maximilian Ruta <mr@xtain.net>
 * @copyright     Copyright (c) 2013, XTAIN oHG <https://company.xtain.net>
 * @package       io.xun.test.unit.core.dependencyinjection.TestContainer
 */
class ExtendedContainer extends Container {

    public var __bar : Array<String>;
    public var __foo_bar : Array<String>;
    public var __foo_baz : Array<String>;
    public var i : Int = 0;

    public function new( parameterBag : Null<IParameterBag> = null ) {
        super(parameterBag);
        __bar = ['bar'];
        __foo_bar = ['foo_bar'];
        __foo_baz = ['foo_baz'];
    }

    public function getScopedService() : Array<String> {
        if (!scopedServices.exists('foo')) {
            throw new RuntimeException('Invalid call');
        }

        scopedServices.get('foo').set('scoped', ['scoped' + (i++)]);
        services.set('scoped', scopedServices.get('foo').get('scoped'));
        return services.get('scoped');
    }

    public function getScopedFooService() : Array<String> {
        if (!scopedServices.exists('foo')) {
            throw new RuntimeException('Invalid call');
        }

        scopedServices.get('foo').set('scoped_foo', ['scoped_foo' + (i++)]);
        services.set('scoped_foo', scopedServices.get('foo').get('scoped_foo'));
        return services.get('scoped_foo');
    }

    public function getBaaDaService() : String {
        return 'baa';
    }

    public function getBarService() : Array<String> {
        return __bar;
    }

    public function getFooBarService() : Array<String> {
        return __foo_bar;
    }

    public function getFooBazService() : Array<String> {
        return __foo_baz;
    }

    public function getCircularService() {
        return get('circular');
    }

}