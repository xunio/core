package js.nodejs;

import js.nodejs.Node.NodeFiber;
import js.nodejs.Node;
import js.nodejs.io.Input;
import js.nodejs.io.Output;

class Sys
{
	public static inline var ASYNC_WAIT = 0.005;
	private static var _startNanotime : Array<Int>;

	public static function print( v : Dynamic ) : Void {
		Node.process.stdout.write(v, js.nodejs.Node.NodeC.UTF8);
	}

	public static function println( v : Dynamic ) : Void {
		print(v);
		print("\n");
	}

	public static function getChar( echo : Bool ) : Int {
		sleep(0.0001);
		var char : String = stdin().readString(1);

		if (echo) {
			print(char);
		}

		return char.charCodeAt(0);
	}

	public static function stdin() : haxe.io.Input {
		return new js.nodejs.io.Input(js.nodejs.Node.process.stdin);
	}

	public static function stdout() : haxe.io.Output {
		return new js.nodejs.io.Output(js.nodejs.Node.process.stdout);
	}

	public static function stderr() : haxe.io.Output {
		return new js.nodejs.io.Output(js.nodejs.Node.process.stderr);
	}

	public static function args() : Array<String>
	{
		return Node.process.argv.splice(2, Node.process.argv.length);
	}

	public static function getEnv(s : String) : String
	{
		return Reflect.field(Node.process.env, s);
	}

	public static function putEnv( s : String, v : String ) : Void {
		untyped Node.process.env[s] = v;
	}

	public static function processMessages() : Void {
		Node.wait(ASYNC_WAIT);
	}

	public static function sleep( seconds : Float ) : Void {
		Node.wait(seconds);
	}

	public static function setTimeLocale( loc : String ) : Bool {
		return false;
	}

	public static function getCwd() : String {
		return js.nodejs.Node.process.cwd();
	}

	public static function setCwd( s : String ) : Void {
		js.nodejs.Node.process.chdir(s);
	}

	public static function systemName() : String {
		return js.nodejs.Node.os.hostname();
	}

	public static function command( cmd : String, ?args : Array<String> ) : Int {
		if (args == null) {
			args = new Array<String>();
		}
		var process : NodeChildProcess = js.nodejs.Node.child_process.spawn(cmd, args, {
			cwd: getCwd(),
			env: environment()
		});

		process.stdout.on('data', function(data) {
			print(data);
		});
		process.stderr.on('data', function(data) {
			print(data);
		});

		var fiber : NodeFiber = js.nodejs.Node.NodeFiber.current;
		process.on('close', function (code) {
			fiber.run(code);
		});

		return cast js.nodejs.Node.NodeFiber.yield();
	}

	public static function exit(code : Int) : Void
	{
		Node.process.exit(code);
	}

	public static function time() : Float
	{
		return Date.now().getTime() / 1000;
	}

	public static function cpuTime() : Float {
		var timeDiff : Array<Int> = Node.process.hrtime(_startNanotime);
		return (timeDiff[0] * 1000000 + timeDiff[1]) / 1000000;
	}

	public static function executablePath() : String {
		var r = Node.require;
		return untyped __js__('r.main.filename');
	}

	public static function environment() : haxe.ds.StringMap<String>
	{
		return Node.process.env;
	}

	public static function __init__() : Void {
		_startNanotime = Node.process.hrtime();
	}

}