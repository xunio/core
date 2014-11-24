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