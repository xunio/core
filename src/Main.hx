package ;

/*
import io.xun.mvc.Model;
import io.xun.core.dependencyinjection.ref.Parameter;
import io.xun.core.dependencyinjection.Definition;
import io.xun.core.dependencyinjection.Container;
*/

import io.xun.core.util.StringUtils;
import io.xun.core.util.Inflector;

@:expose
class Main {

    //public static var container : Container;
    //public static var dependency : Definition;


    public static function assetTrue( s : Dynamic, r : Dynamic ) : Bool {
        var res : Bool = s == r;
        if(!res) {
            trace(s, r);
        } else {
            trace(res);
        }
        return res;
    }

    public static function main() {

        /*
        container = new Container();
        container.setParameter(new Parameter('mailer.transport', 'sendmail'));
        container.set('test', Model);
        dependency.addArgument(container.getParameter('mailer.transport'));
        trace(dependency);

        trace(container);

        trace(container.get('test'));
        trace(container.get('foo'));
        */

        assetTrue(StringUtils.upperCaseWords('test test ddasd adsad'), 'Test Test Ddasd Adsad');
        assetTrue(StringUtils.upperCaseWords(' test test ddasd adsad '), ' Test Test Ddasd Adsad ');
        assetTrue(StringUtils.upperCaseWords(' test 5test 7ddasd adsad '), ' Test 5test 7ddasd Adsad ');
        assetTrue(StringUtils.upperCaseWords('test 5test'), 'Test 5test');
        assetTrue(StringUtils.upperCaseWords('Test 5test'), 'Test 5test');
        assetTrue(StringUtils.upperCaseWords('5test'), '5test');

        assetTrue(Inflector.underscore('TestThing'), 'test_thing');
        assetTrue(Inflector.underscore('testThing'), 'test_thing');
        assetTrue(Inflector.underscore('TestThingExtra'), 'test_thing_extra');
        assetTrue(Inflector.underscore('testThingExtra'), 'test_thing_extra');

        assetTrue(Inflector.underscore('TestThing'), 'test_thing');
        assetTrue(Inflector.underscore('testThing'), 'test_thing');
        assetTrue(Inflector.underscore('TestThingExtra'), 'test_thing_extra');
        assetTrue(Inflector.underscore('testThingExtra'), 'test_thing_extra');

        assetTrue(Inflector.underscore(''), '');
        assetTrue(Inflector.underscore('0'), '0');


        assetTrue(Inflector.variable('test_field'), 'testField');
        assetTrue(Inflector.variable('test_fieLd'), 'testFieLd');
        assetTrue(Inflector.variable('test field'), 'testField');
        assetTrue(Inflector.variable('Test_field'), 'testField');

        assetTrue(Inflector.humanize('posts'), 'Posts');
        assetTrue(Inflector.humanize('posts_tags'), 'Posts Tags');
        assetTrue(Inflector.humanize('file_systems'), 'File Systems');
        assetTrue(Inflector.humanize(' foo file_systems ba '), ' Foo File Systems Ba ');

    }

}

