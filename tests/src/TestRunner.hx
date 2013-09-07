package ;

import io.xun.core.util.BitwiseMask;

class TestRunner {

    public static var TIMES = 1;

    public static function main() {
        var result : Bool = true;
        var i : Int = 0;
        for ( i in 0...TIMES ) {
            result = result && io.xun.test.unit.Runner.main();
        }

        if(!result) {
            #if js
              if( untyped __js__('typeof process != "undefined" && "exit" in process') ) {
                untyped __js__('process.exit(255)');
              }
            #elseif flash
            #else
            Sys.exit(255);
            #end
        }
    }

}
