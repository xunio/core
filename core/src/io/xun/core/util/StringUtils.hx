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
 * @package       io.xun.core.util
 * @license       http://www.gnu.org/licenses/agpl-3.0.html GNU Affero General Public License
 */

package io.xun.core.util;

/**
 * Class StringUtils
 *
 * @author        Maximilian Ruta <mr@xtain.net>
 * @copyright     Copyright (c) 2013 XTAIN oHG, <https://company.xtain.net>
 * @package       io.xun.core.util
 */
class StringUtils extends StringTools {

    /**
     * Returns a string with the first character of each word in str
     * capitalized, if that character is alphabetic.
     *
     * The definition of a word is any string of characters that is
     * immediately after a whitespace (These are: space, form-feed,
     * newline, carriage return, horizontal tab, and vertical tab).
     *
     * @author Maximilian Ruta <mr@xtain.net>
     * @return string with the first character of each word in str capitalized
     */
    public static function upperCaseWords( subject : String ) : String {
        #if js
        var uc : EReg = ~/^([a-z\u00E0-\u00FC])|\s+([a-z\u00E0-\u00FC])/g;

        return uc.map(subject, function( match : EReg ) : String {
            return match.matched(0).toUpperCase();
        });
        #elseif php
        return cast(untyped __call__("ucwords", subject), String);
        #else
        var r = '';
        for (v in subject.split(' ')) {
            r += v.substr(0, 1).toUpperCase() + v.substr(1, v.length-1) + ' ';
        }
        return r.substr(0, r.length - 1);
        #end
    }

    public static function escapeShellArgument(arg : String) : String {
        var ret = '';

        var reg : EReg = ~/[^\\]'/;

        ret = reg.map(arg, function (match : EReg) {
            var m : String = match.matched(0);
            return m.substr(0, m.length - 1) + '\\\'';
        });

        return "'" + ret + "'";
    }

}
