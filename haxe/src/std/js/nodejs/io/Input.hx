
package js.nodejs.io;

import haxe.io.Bytes;
import js.nodejs.Node;

class Input extends haxe.io.Input {

	private var stream : NodeReadStream;
	private var end : Bool = false;

	public function new( stream : NodeReadStream ) {
		this.stream = stream;
		this.stream.once('end', function() : Void {
			end = true;
		});
		this.stream.once('close', function() : Void {
			end = true;
		});
	}

	override public function readByte() : Int {
		var b : Null<NodeBuffer>;

		if (end) {
			throw new haxe.io.Eof();
		}

		do {
			b = this.stream.read(1);
			if (b != null) {
				break;
			}
			js.nodejs.Sys.processMessages();
		} while(end == false);

		if (b == null) {
			if (end == true) {
				throw new haxe.io.Eof();
			}
			throw haxe.io.Error.Blocked;
		}

		//if (!bigEndian) {
		//	return b.readInt8(0);
		//}

		return b.readInt8(0);
	}

	override public function readBytes( s : Bytes, pos : Int, len : Int ) : Int {
		var k = len;
		var bd = s.getData();
		if( pos < 0 || len < 0 || pos + len > s.length )
			throw haxe.io.Error.OutsideBounds;

		if (end) {
			throw new haxe.io.Eof();
		}

		var b : Null<NodeBuffer>;
		do {
			b = this.stream.read(len);
			if (b != null) {
				break;
			}
			js.nodejs.Sys.processMessages();
		} while(end == false);

		if (b == null) {
			if (end == true) {
				throw new haxe.io.Eof();
			}
			throw haxe.io.Error.Blocked;
		}

		var i : Int = 0;
		while( k > 0 ) {
			if ( i >= b.length ) {
				break;
			} else {
				bd[pos] = b[i];
			}
			i++;
			pos++;
			k--;
		}

		if (k > 0) {
			s.fill(pos, k, 0);
		}

		return b.length;
	}
}