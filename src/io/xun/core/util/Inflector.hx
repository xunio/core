package io.xun.core.util;

import haxe.ds.StringMap;

class Inflector {

    private static var _cache : Null<StringMap<StringMap<String>>> = null;

    /**
     * Cache inflected values, and return if already available
     *
     * @author Maximilian Ruta <mr@xtain.net>
     * @return Inflected value, from cache
     */
    private static function cache( type : String, key : String, value : Null<String> = null ) : Null<String> {
        var typeMap : StringMap<String>;

        key = '_' + key;
        type = '_' + type;

        if (_cache == null) {
            _cache = new StringMap<StringMap<String>>();
        }

        if (!_cache.exists(type)) {
            typeMap = new StringMap<String>();
            _cache.set(type, typeMap);
        } else {
            typeMap = _cache.get(type);
        }

        if (value != null) {
            typeMap.set(key, value);
        } else if (!typeMap.exists(key)) {
            return null;
        }

        return typeMap.get(key);
    }

    /**
     * Returns the given lower_case_and_underscored_word as a CamelCased word.
     *
     * @author Maximilian Ruta <mr@xtain.net>
     * @return Camelized word. LikeThis.
     */
    public static function camelize( lowerCaseAndUnderscoredWord : String ) : String {
        var result : Null<String> = cache('camelize', lowerCaseAndUnderscoredWord);
        if (result == null) {
            result = StringTools.replace(humanize(lowerCaseAndUnderscoredWord), ' ', '');
            cache('camelize', cast(result, String));
        }
        return cast(result, String);
    }

    /**
     * Returns the given camelCasedWord as an underscored_word.
     *
     * @author Maximilian Ruta <mr@xtain.net>
     * @return Underscore-syntaxed version of the camelCasedWord
     */
    public static function underscore( camelCasedWord : String ) : String {
        var result : Null<String> = cache('underscore', camelCasedWord);
        if (result == null) {
            #if (php || cpp || flash || flash9 || neko)
            var underscoreEReg : EReg = ~/(?<=\w)([A-Z])/g;
            result = underscoreEReg.replace(camelCasedWord, '_$1').toLowerCase();
            #else
            var underscoreEReg : EReg = ~/\W/g;
            var concatEReg : EReg = ~/([a-z\d])([A-Z])/g;
            result = underscoreEReg.replace(camelCasedWord, '_');
            result = concatEReg.replace(result, '$1_$2').toLowerCase();
            #end
            cache('underscore', cast(result, String));
        }
        return cast(result, String);
    }

    /**
     * Returns the given underscored_word_group as a Human Readable Word Group.
     * (Underscores are replaced by spaces and capitalized following words.)
     *
     * @author Maximilian Ruta <mr@xtain.net>
     * @return string Human-readable string
     */
    public static function humanize( lowerCaseAndUnderscoredWord : String ) : String {
        var result : Null<String> = cache('humanize', lowerCaseAndUnderscoredWord);
        if (result == null) {
            result = StringUtils.upperCaseWords(StringTools.replace(lowerCaseAndUnderscoredWord, '_', ' '));
            cache('humanize', cast(result, String));
        }
        return cast(result, String);
    }

    /**
     * Returns camelBacked version of an underscored string.
     *
     * @author Maximilian Ruta <mr@xtain.net>
     * @return string in variable form
     */
    public static function variable( word : String ) : String {
        var result : Null<String> = cache('variable', word);
        if (result == null) {
            var variableEReg : EReg = ~/\w/;
            var camelized : String = camelize(underscore(word));
            var replace : String = camelized.substr(0, 1).toLowerCase();
            result = variableEReg.replace(camelized, replace);
            cache('variable', cast(result, String));
        }
        return cast(result, String);
    }

}
