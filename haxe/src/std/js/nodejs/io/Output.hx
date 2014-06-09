
package js.nodejs.io;

import js.nodejs.Node;
import haxe.io.Bytes;

class Output extends haxe.io.Output {

	private var stream : NodeWriteStream;

	public function new( stream : NodeWriteStream ) {
		this.stream = stream;
	}

	override public function writeByte( c : Int ) : Void {
		var buffer : Bytes = Bytes.alloc(1);
		buffer.set(0, c);
		this.stream.write(buffer.getData());
	}

}