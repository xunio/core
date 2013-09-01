package io.xun.core.util;

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

}
