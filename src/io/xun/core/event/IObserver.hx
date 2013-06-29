package io.xun.core.event;

/**
 * <p>An object observing the state of an <em>IObservable</em> implementation.</p>
 * <p>See <a href="http://en.wikipedia.org/wiki/Observer_pattern" target="_blank">http://en.wikipedia.org/wiki/Observer_pattern</a>.</p>
 */
@:build(io.xun.core.event.ObserverMacro.guid())
@:autoBuild(io.xun.core.event.ObserverMacro.guid())
interface IObserver
{
	/**
	 * Invoked upon state changes of an <em>IObservable</em> object.
	 * @param type     the event type encoded as bit flags.
	 * @param source   the event source.
	 * @param userData the event data or null if no additional information was passed.
	 */
	public function onUpdate(type:Int, source:IObservable, userData:Dynamic):Void;
}