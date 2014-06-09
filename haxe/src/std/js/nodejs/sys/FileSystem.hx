package js.nodejs.sys;

import sys.FileStat;
import js.nodejs.Node;

#if !macro
/**
	This class allows you to get informations about the files and directories.
**/
class FileSystem {

	public static function exists( path : String ) : Bool {
		return Node.fs.existsSync(path);
	}

	public static function rename( path : String, newPath : String ) : Void {
		Node.fs.renameSync(path, newPath);
	}

	public static function stat( path : String ) : FileStat {
		var nstat : NodeStat = Node.fs.statSync(path);
		return untyped {
			gid: nstat.gid,
			uid: nstat.uid,
			atime: Date.fromTime(nstat.atime.getTime()),
			mtime: Date.fromTime(nstat.mtime.getTime()),
			ctime: Date.fromTime(nstat.ctime.getTime()),
			size: nstat.size,
			dev: nstat.dev,
			ino: nstat.ino,
			nlink: nstat.nlink,
			rdev: nstat.rdev,
			mode: nstat.mode
		};
	}

	public static function fullPath( relPath : String ) : String {
		return Node.path.resolve(null, relPath);
	}

	public static function isDirectory( path : String ) : Bool {
		#if debug
		if (!exists(path)) {
			throw "Path doesn't exist: " +path;
		}
		#end
		if ( Node.fs.statSync(path).isSymbolicLink() ) {
			return false;
		} else {
			return Node.fs.statSync(path).isDirectory();
		}
	}

	public static function createDirectory( path : String ) : Void {
		Node.fs.mkdirSync(path);
	}

	public static function deleteFile( path : String ) : Void {
		Node.fs.unlinkSync(path);
	}

	public static function deleteDirectory( path : String ) : Void {
		Node.fs.rmdirSync(path);
	}

	inline public static function readDirectory( path : String ) : Array<String> {
		return Node.fs.readdirSync(path);
	}

}

#else
class FileSystem
{}
#end
