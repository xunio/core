package io.xun.core.dependencyinjection;
interface IContainer {

}

class IContainerConst {
    public static inline var EXCEPTION_ON_INVALID_REFERENCE = 1;
    public static inline var NULL_ON_INVALID_REFERENCE      = 2;
    public static inline var IGNORE_ON_INVALID_REFERENCE    = 3;
    public static inline var SCOPE_CONTAINER                = 'container';
    public static inline var SCOPE_PROTOTYPE                = 'prototype';
}
