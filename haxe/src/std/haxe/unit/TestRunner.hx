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
 * @package       io.xun.test
 * @license       http://www.gnu.org/licenses/agpl-3.0.html GNU Affero General Public License
 */

package haxe.unit;

/* imports and uses */

import Reflect;
import haxe.unit.TestResult;
import haxe.unit.TestCase;
import haxe.unit.TestStatus;


/**
 * Class TestRunner
 *
 * @author        Maximilian Ruta <mr@xtain.net>
 * @copyright     Copyright (c) 2013 XTAIN oHG, <https://company.xtain.net>
 * @package       io.xun.test
 */
class TestRunner {
    public var result(default, null) : TestResult;
    var cases  : List<TestCase>;

#if flash9
	static var tf : flash.text.TextField = null;
#elseif flash
	static var tf : flash.TextField = null;
#end

    public static dynamic function print( v : Dynamic ) untyped {
        #if flash9
			if( tf == null ) {
				tf = new flash.text.TextField();
				tf.selectable = false;
				tf.width = flash.Lib.current.stage.stageWidth;
				tf.autoSize = flash.text.TextFieldAutoSize.LEFT;
				flash.Lib.current.addChild(tf);
			}
			tf.appendText(v);
		#elseif flash
			var root = flash.Lib.current;
			if( tf == null ) {
				root.createTextField("__tf",1048500,0,0,flash.Stage.width,flash.Stage.height+30);
				tf = root.__tf;
				tf.selectable = false;
				tf.wordWrap = true;
			}
			var s = flash.Boot.__string_rec(v,"");
			tf.text += s;
			while( tf.textHeight > flash.Stage.height ) {
				var lines = tf.text.split("\r");
				lines.shift();
				tf.text = lines.join("\n");
			}
		#elseif neko
			__dollar__print(v);
		#elseif php
			php.Lib.print(v);
		#elseif cpp
			cpp.Lib.print(v);
		#elseif js
			if( untyped __js__('typeof document == "undefined"') ) {
                process.stdout.write(js.Boot.__string_rec(v,""));
			} else {
    			var msg = StringTools.htmlEscape(js.Boot.__string_rec(v,"")).split("\n").join("<br/>");
                var d = document.getElementById("haxe:trace");
                if( d == null )
                    alert("haxe:trace element not found")
                else
                    d.innerHTML += msg;
            }
		#elseif cs
			var str:String = v;
			untyped __cs__("System.Console.Write(str)");
		#elseif java
			var str:String = v;
			untyped __java__("java.lang.System.out.print(str)");
		#end
    }

    private static function customTrace( v, ?p : haxe.PosInfos ) {
        print(p.fileName+":"+p.lineNumber+": "+Std.string(v)+"\n");
    }

    public function new() {
        result = new TestResult();
        cases = new List();
    }

    public function add( c:TestCase ) : Void{
        cases.add(c);
    }

    public function run() : Bool {
        result = new TestResult();
        for ( c in cases ){
            runCase(c);
        }
        print(result.toString());
        return result.success;
    }

    function runCase( t:TestCase ) : Void 	{
        var old = haxe.Log.trace;
        haxe.Log.trace = customTrace;

        var cl = Type.getClass(t);
        var fields = Type.getInstanceFields(cl);

        print( "Class: "+Type.getClassName(cl)+" ");
        for ( f in fields ){
            var fname = f;
            var field = Reflect.field(t, f);
            if ( StringTools.startsWith(fname,"test") && Reflect.isFunction(field) ){
                t.currentTest = new TestStatus();
                t.currentTest.classname = Type.getClassName(cl);
                t.currentTest.method = fname;
                t.setup();

                try {
                    Reflect.callMethod(t, field, new Array());

                    if( t.currentTest.done ){
                        t.currentTest.success = true;
                        print(".");
                    }else{
                        t.currentTest.success = false;
                        t.currentTest.error = "(warning) no assert";
                        print("W");
                    }
                }catch ( e : TestStatus ){
                    print("F");
                    t.currentTest.backtrace = haxe.CallStack.toString(haxe.CallStack.exceptionStack());
                }catch ( e : Dynamic ){
                    print("E");
                    #if js
					if( e.message != null ){
						t.currentTest.error = "exception thrown : "+e+" ["+e.message+"]";
					}else{
						t.currentTest.error = "exception thrown : "+e;
					}
					#else
                    t.currentTest.error = "exception thrown : "+e;
                    #end
                    t.currentTest.backtrace = haxe.CallStack.toString(haxe.CallStack.exceptionStack());
                }
                result.add(t.currentTest);
                t.tearDown();
            }
        }

        print("\n");
        haxe.Log.trace = old;
    }
}
