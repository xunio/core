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
 * @package       io.xun.core.dependencyinjection
 * @license       http://www.gnu.org/licenses/agpl-3.0.html GNU Affero General Public License
 */

package io.xun.core.dependencyinjection;

/* imports and uses */

import io.xun.core.exception.InvalidArgumentException;
import haxe.ds.StringMap;
import io.xun.core.exception.RuntimeException;
import Reflect;
import io.xun.core.util.Inflector;
import io.xun.core.util.StringUtils;

import io.xun.core.dependencyinjection.exception.InvalidServiceType;
import io.xun.core.dependencyinjection.exception.ServiceCircularReferenceException;
import io.xun.core.dependencyinjection.exception.InactiveScopeException;
import io.xun.core.dependencyinjection.exception.ServiceNotFoundException;

import io.xun.core.dependencyinjection.ref.Parameter;
import io.xun.core.dependencyinjection.parameterbag.FrozenParameterBag;
import io.xun.core.dependencyinjection.parameterbag.ParameterBag;
import io.xun.core.dependencyinjection.parameterbag.IParameterBag;
import io.xun.core.dependencyinjection.IContainer.IContainerConst;

using Lambda;
using io.xun.core.util.L;
using io.xun.core.util.L.ArrayExtension;

/**
 * Class Container
 *
 * @author        Maximilian Ruta <mr@xtain.net>
 * @copyright     Copyright (c) 2013 XTAIN oHG, <https://company.xtain.net>
 * @package       io.xun.core.dependencyinjection
 */
class Container implements IIntrospectableContainer {

    public static inline var CONTAINER = 'service_container';

    public var parameterBag(default, null) : IParameterBag;

    private var services : ServiceMap;
    private var methodMap : Map<String, Dynamic>;
    private var aliases : Map<String, String>;

    private var loading : Array<String>;
    private var scopes : Map<String, String>;
    private var scopeChildren : Map<String, Array<String>>;
    private var scopedServices : Map<String, ServiceMap>;
    private var scopeStacks : Map<String, Array<Map<String, ServiceMap>>>;

    /**
     * Constructor
     *
     * @author Maximilian Ruta <mr@xtain.net>
     */
    public function new( parameterBag : Null<IParameterBag> = null ) {
        if (parameterBag == null) {
            parameterBag = new ParameterBag();
        }
        this.parameterBag = parameterBag;

        this.services = new ServiceMap();
        this.methodMap = new Map<String, Dynamic>();
        this.aliases = new Map<String, String>();

        this.loading = new Array<String>();
        this.scopes = new Map<String, String>();
        this.scopeChildren = new Map<String, Array<String>>();
        this.scopedServices = new Map<String, ServiceMap>();
        this.scopeStacks = new Map<String, Array<Map<String, ServiceMap>>>();

        this.set(CONTAINER, this);
    }

    /**
     * Compiles the container.
     *
     * This method does two things:
     *
     *  - Parameter values are resolved;
     *  - The parameter bag is frozen.
     *
     * @author Maximilian Ruta <mr@xtain.net>
     */
    public function compile() {
        if (!parameterBag.isFrozen()) {
            parameterBag = new FrozenParameterBag(parameterBag);
        }
    }

    /**
     * Returns true if the container parameter bag are frozen.
     *
     * @author Maximilian Ruta <mr@xtain.net>
     * @return true if the container parameter bag are frozen, false otherwise
     */
    public function isFrozen() : Bool {
        return parameterBag.isFrozen();
    }

    /**
     * Gets an parameter from ParameterBag.
     *
     * @author Maximilian Ruta <mr@xtain.net>
     * @throws io.xun.core.dependencyinjection.parameterbag.InvalidArgumentException if the parameter is not defined
     */
    public function getParameterBag() : IParameterBag {
        return this.parameterBag;
    }

    /**
     * Gets an parameter from ParameterBag.
     *
     * @author Maximilian Ruta <mr@xtain.net>
     * @throws io.xun.core.dependencyinjection.parameterbag.InvalidArgumentException if the parameter is not defined
     */
    public function getParameter( key : String ) : Parameter {
        return this.parameterBag.get(key);
    }

    /**
     * Checks if a parameter exists.
     *
     * @author Maximilian Ruta <mr@xtain.net>
     */
    public function hasParameter( key : String ) : Bool {
        return this.parameterBag.exists(key);
    }

    /**
     * Sets a parameter.
     *
     * @author Maximilian Ruta <mr@xtain.net>
     */
    public function setParameter( parameter : Parameter ) : Void {
        this.parameterBag.set(parameter);
    }

    /**
     * Sets a service.
     *
     * Setting a service to null resets the service: has() returns false and get()
     * behaves in the same way as if the service was never created.
     *
     * @author Maximilian Ruta <mr@xtain.net>
     */
    public function set( id : String, service : Null<Dynamic>, scope : String = IContainerConst.SCOPE_CONTAINER ) : Void {
        if (IContainerConst.SCOPE_PROTOTYPE == scope) {
            throw new InvalidArgumentException('You cannot set service "${id}" of scope "prototype".');
        }

        var id : String = id.toLowerCase();

        if (IContainerConst.SCOPE_CONTAINER != scope) {
            if (!scopedServices.exists(scope)) {
                throw new RuntimeException('You cannot set service "${id}" of inactive scope.');
            }

            scopedServices.get(scope).set(id, service);
        }

        services.set(id, service);

        var methodName : String = getSynchronizeMethodName(id);
        var method : Dynamic = Reflect.field(this, methodName);
        if (method != null && Reflect.isFunction(method)) {
            Reflect.callMethod(this, method, []);
        }

        if (IContainerConst.SCOPE_CONTAINER != scope && service == null) {
            scopedServices.get(scope).remove(id);
        }

        if (service == null) {
            services.remove(id);
        }
    }

    /**
     * Returns true if the given service is defined.
     *
     * @author Maximilian Ruta <mr@xtain.net>
     * @return true if the service is defined, false otherwise
     */
    public function has( id : String ) : Bool {
        var id : String = id.toLowerCase();

        return this.services.exists(id)
                || this.aliases.exists(id)
                || Reflect.field(this, getMethodName(id)) != null;
    }

    public function get( id : String, invalidBehavior : Int = IContainerConst.EXCEPTION_ON_INVALID_REFERENCE ) : Dynamic {
        var service : Dynamic;
        var method : Dynamic;
        var id : String = id.toLowerCase();

        // resolve aliases
        if (this.aliases.exists(id)) {
            id = this.aliases.get(id);
        }

        // re-use shared service instance if it exists
        if (this.services.exists(id)) {
            /*
            if(Std.is(this.services.get(id), T)) {
                service = cast this.services.get(id);
                return service;
            } else {
                throw new InvalidArgumentException();
            }
            */
            return this.services.get(id);
        }

        if (this.loading.has(id)) {
            throw new ServiceCircularReferenceException(id);
        }

        if (this.methodMap.exists(id)) {
            method = this.methodMap.get(id);
        } else {
            var methodName : String = getMethodName(id);
            method = Reflect.field(this, methodName);
            if (method == null || !Reflect.isFunction(method)) {
                if (IContainerConst.EXCEPTION_ON_INVALID_REFERENCE == invalidBehavior) {
                    throw new ServiceNotFoundException(id);
                }
                return null;
            }
            this.methodMap.set(id, method);
        }


        this.loading.push(id);

        try {
            var methodResult : Dynamic = Reflect.callMethod(this, method, []);
            /*
            if(!Std.is(methodResult, T)) {
                throw new InvalidServiceType(id);
            }
            */
            service = methodResult;
        } catch( e : Dynamic ) {
            this.loading.remove(id);

            if (this.services.exists(id)) {
                this.services.remove(id);
            }

            if (Std.is(e, InactiveScopeException)
                 && IContainerConst.EXCEPTION_ON_INVALID_REFERENCE != invalidBehavior) {
                return null;
            }

            throw e;
        }

        this.loading.remove(id);

        return service;
    }

    /**
     * Returns true if the given service has actually been initialized
     *
     * @author Maximilian Ruta <mr@xtain.net>
     * @return true if service has already been initialized, false otherwise
     */
    public function initialized( id : String ) : Bool {
        return this.services.exists(id.toLowerCase());
    }

    /**
     * Gets all service ids.
     *
     * @author Maximilian Ruta <mr@xtain.net>
     * @return An array of all defined service ids
     */
    public function getServiceIds() : Array<String> {
        var ids : Array<String> = new Array<String>();
        var fields : Array<String> = Type.getInstanceFields(Type.getClass(this));
        var fieldMatch : EReg = ~/^get(.+)Service$/;

        for (field in fields.iterator()) {
            var field : String = field;
            if (Reflect.isFunction(Reflect.field(this, field))
                 && fieldMatch.match(field)) {
                ids.push(Inflector.underscore(fieldMatch.matched(1)));
            }
        }

        return ids.concat(
            this.services.keys().fromIterator()
        ).array().unique();
    }

    public function addScope(scope : IScope) {
        var name : String = scope.getName();
        var parentScope : String = scope.getParentName();

        if (IContainerConst.SCOPE_CONTAINER == name || IContainerConst.SCOPE_PROTOTYPE == name) {
            throw new InvalidArgumentException('The scope "${name}" is reserved.');
        }
        if (scopes.exists(name)) {
            throw new InvalidArgumentException('A scope with name "${name}" already exists.');
        }
        if (IContainerConst.SCOPE_CONTAINER != parentScope && !scopes.exists(parentScope)) {
            throw new InvalidArgumentException('The parent scope "${parentScope}" does not exist, or is invalid.');
        }

        scopes.set(name, parentScope);
        scopeChildren.set(name, new Array<String>());

        // normalize the child relations
        while (parentScope != IContainerConst.SCOPE_CONTAINER) {
            scopeChildren.get(parentScope).push(name);
            parentScope = scopes.get(parentScope);
        }
    }

    /**
     * Returns whether this container has a certain scope
     *
     * @author Maximilian Ruta <mr@xtain.net>
     */
    public function hasScope( name : String ) : Bool {
        return scopes.exists(name);
    }

    /**
     * This is called when you enter a scope
     *
     * @author Maximilian Ruta <mr@xtain.net>
     *
     */
    public function enterScope(name : String) {
        if (!scopes.exists(name))  {
            throw new InvalidArgumentException('The sope "${name}" does not exist.');
        }

        if (IContainerConst.SCOPE_CONTAINER != scopes.get(name)
            && !scopedServices.exists(scopes.get(name))
        ) {
            throw new RuntimeException('The parent scope "${scopes.get(name)}" must be active when entering this scope.');
        }


        // check if a scope of this name is already active, if so we need to
        // remove all services of this scope, and those of any of its child
        // scopes from the global services map
        var services : Map<String, ServiceMap> = new Map<String, ServiceMap>();
        if (scopedServices.exists(name)) {
            var diffs : Array<Array<String>> = new Array<Array<String>>();
            services.set(name, scopedServices.get(name));
            diffs.push(services.get(name).keys().fromIterator());
            scopedServices.remove(name);

            var currentServiceMap : ServiceMap;
            for (child in scopeChildren.get(name).iterator()) {
                if (scopedServices.exists(child)) {
                    currentServiceMap = scopedServices.get(child);
                    scopedServices.remove(child);
                    services.set(child, currentServiceMap);
                    diffs.push(services.get(child).keys().fromIterator());
                }
            }

            var lastServices : ServiceMap = this.services;
            this.services = new ServiceMap();
            for (service in lastServices.keys().diff(diffs.flatten())) {
                this.services.set(service, lastServices.get(service));
            }

            var stack : Array<Map<String, ServiceMap>>;
            if (scopeStacks.exists(name)) {
                stack = scopeStacks.get(name);
            } else {
                stack = new Array<Map<String, ServiceMap>>();
                scopeStacks.set(name, stack);
            }
            stack.push(services);
        }

        scopedServices.set(name, new ServiceMap());
        scopedServices.get(name).set(CONTAINER, this);
    }

    public function leaveScope(name) {
        if (!scopedServices.exists(name)) {
            throw new InvalidArgumentException('The scope "${name}}" is not active.');
        }

        // remove all services of this scope, or any of its child scopes from
        // the global service map
        var diffMap : Map<String, String> = new Map();
        var services : Array<ServiceMap> = new Array<ServiceMap>();
        var removableServices : Array<String> = new Array<String>();

        for (child in [name].concat(scopeChildren.get(name))) {
            if (!scopedServices.exists(child)) {
                continue;
            }

            services.push(scopedServices.get(child));
            removableServices.push(child);

            for (key in scopedServices.get(child).keys()) {
                if (!diffMap.exists(key)) {
                    diffMap.set(key, child);
                }
            }
        }

        var childService : ServiceMap;

        var lastServices : ServiceMap = this.services;
        var services : Array<String> = lastServices.keys().diff(diffMap.keys().fromIterator());
        this.services = new ServiceMap();
        for (service in services) {
            childService = scopedServices.get(diffMap.get(service));
            if (childService.exists(service)) {
                this.services.set(service, childService.get(service));
            }
        }

        for (removableChild in removableServices) {
            scopedServices.remove(removableChild);
        }

        var stackedServiceMap : Map<String, ServiceMap>;
        // check if we need to restore services of a previous scope of this type
        if (scopeStacks.exists(name) && scopeStacks.get(name).length > 0) {
            stackedServiceMap = scopeStacks.get(name).pop();
            scopedServices.append(stackedServiceMap);

            for (array in stackedServiceMap.iterator()) {
                for (id in array.keys()) {
                    set(id, array.get(id), name);
                }
            }
        }
    }

    public static function getMethodName( id : String ) : String {
        return 'get' + Inflector.camelize(id) + 'Service';
    }

    public static function getSynchronizeMethodName( id : String ) : String {
        return 'synchronize' + Inflector.camelize(id) + 'Service';
    }

    public function register(key : String, dependency : Class<Dynamic>) : Definition {
        return new Definition();
    }

}
