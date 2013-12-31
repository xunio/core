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
 * @package       io.xun.core.util.clipboard
 * @license       http://www.gnu.org/licenses/agpl-3.0.html GNU Affero General Public License
 */

package io.xun.core.util.clipboard;

import io.xun.core.util.clipboard.Clipboard.ClipboardEvent;
import io.xun.core.exception.NotImplementedException;
import io.xun.core.event.Observable;
import io.xun.core.event.IObserver;
import io.xun.core.event.IObservable;
import haxe.Timer;

/**
 * Class AbstractClipboard
 *
 * @author        Maximilian Ruta <mr@xtain.net>
 * @copyright     Copyright (c) 2013 XTAIN oHG, <https://company.xtain.net>
 * @package       io.xun.core.util.clipboard
 */
class AbstractClipboard implements IObservable {

    public static inline var INTERVAL = 5;
    private var observable : Observable;
    private var pollingTimer : Timer;
    private var lastText : Null<String> = null;

    /**
     * Constructor
     *
     * @author Maximilian Ruta <mr@xtain.net>
     */
    private function new() {
        observable = new Observable(this);
        #if !(neko || php || cpp)
        if (!Std.is(this, NotifiableClipboard)) {
            pollingTimer = new haxe.Timer(INTERVAL);
            pollingTimer.run = fallbackToPolling;
            poll();
        }
        #end
    }

    public function poll() : Void {
        var newText : Null<String> = this.getText();
        if (newText != null && lastText != newText) {
            lastText = newText;
            observable.notify(ClipboardEvent.CHANGED, newText);
        }
    }

    public function isNotifiable() : Bool {
        #if !(neko || php || cpp)
        return true;
        #else
        return false;
        #end
    }

    public function isAvailable() : Bool {
        throw new NotImplementedException();
        return false;
    }

    public function getText() : Null<String> {
        throw new NotImplementedException();
        return null;
    }

    public function setText(value : String) : Void {
        throw new NotImplementedException();
    }

    public function attach(o : IObserver, ?mask : Null<Int>) : Void {
        if (!isNotifiable()) {
            throw new NotImplementedException();
        }
        observable.attach(o, mask);
    }

    public function detach(o : IObserver, ?mask : Null<Int>) : Void {
        observable.detach(o, mask);
    }

}
