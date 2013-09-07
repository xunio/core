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

import Reflect;
import io.xun.core.util.Inflector;
import io.xun.core.util.Inflector;
import io.xun.core.util.StringUtils;
import Reflect;
import haxe.ds.StringMap;

import io.xun.core.dependencyinjection.exception.InvalidServiceType;
import io.xun.core.dependencyinjection.exception.ServiceCircularReferenceException;
import io.xun.core.dependencyinjection.exception.InactiveScopeException;
import io.xun.core.dependencyinjection.exception.ServiceNotFoundException;
import io.xun.core.dependencyinjection.parameterbag.exception.InvalidArgumentException;

import io.xun.core.util.L;

import io.xun.core.dependencyinjection.ref.Parameter;
import io.xun.core.dependencyinjection.parameterbag.FrozenParameterBag;
import io.xun.core.dependencyinjection.parameterbag.ParameterBag;
import io.xun.core.dependencyinjection.parameterbag.IParameterBag;
import io.xun.core.dependencyinjection.IContainer.IContainerConst;

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

    private var services : StringMap<Class<Dynamic>>;
    private var methodMap : StringMap<Dynamic>;
    private var aliases : StringMap<String>;

    private var loading : Array<String>;
    private var scopes : Array<Dynamic>;
    private var scopeChildren : Array<Dynamic>;
    private var scopedServices : Array<Dynamic>;
    private var scopeStacks : Array<Dynamic>;

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

        this.services = new StringMap<Class<Dynamic>>();
        this.methodMap = new StringMap<Dynamic>();
        this.aliases = new StringMap<String>();

        this.loading = new Array<String>();
        this.scopes = new Array<Dynamic>();
        this.scopeChildren = new Array<Dynamic>();
        this.scopedServices = new Array<Dynamic>();
        this.scopeStacks = new Array<Dynamic>();

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
    public function set( id : String, service : Dynamic ) : Void {
        var id : String = id.toLowerCase();

        this.services.set(id, service);

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

        if (Lambda.has(this.loading, id)) {
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
     * @auhtor Maximilian Ruta <mr@xtain.net>
     * @return true if service has already been initialized, false otherwise
     */
    public function initialized( id : String ) : Bool {
        return this.services.exists(id.toLowerCase());
    }

    /**
     * Gets all service ids.
     *
     * @auhtor Maximilian Ruta <mr@xtain.net>
     * @return An array of all defined service ids
     */
    public function getServiceIds() : Array<String> {
        var ids : Array<String> = new Array<String>();
        var fields : Array<String> = Type.getInstanceFields(Type.getClass(this));
        var fieldMatch : EReg = ~/^get(.+)Service$/;

        for(field in fields.iterator()) {
            var field : String = field;
            if (Reflect.isFunction(Reflect.field(this, field))
                 && fieldMatch.match(field)) {
                ids.push(Inflector.underscore(fieldMatch.matched(1)));
            }
        }

        return Lambda.array(
            Lambda.concat(
                ids,
                L.fromIterator(this.services.keys())
            )
        ).unique();
    }

    public static function getMethodName( id : String ) : String {
        return 'get' + Inflector.camelize(id) + 'Service';
    }

    public function register(key : String, dependency : Class<Dynamic>) : Definition {
        return new Definition();
    }

}
