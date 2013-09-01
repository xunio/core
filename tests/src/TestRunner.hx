package ;

class TestRunner {

    public static function main() {
        var result : Bool = true;
        result = result && io.xun.test.unit.core.Runner.main();
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
