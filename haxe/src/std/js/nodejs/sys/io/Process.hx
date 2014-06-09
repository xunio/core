/*
 * Copyright (C)2005-2012 Haxe Foundation
 *
 * Permission is hereby granted, free of charge, to any person obtaining a
 * copy of this software and associated documentation files (the "Software"),
 * to deal in the Software without restriction, including without limitation
 * the rights to use, copy, modify, merge, publish, distribute, sublicense,
 * and/or sell copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
 * DEALINGS IN THE SOFTWARE.
 */
package js.nodejs.sys.io;

import js.nodejs.Node.NodeChildProcess;

class Process {

	public var stdout(default, null) : haxe.io.Input;
	public var stderr(default, null) : haxe.io.Input;
	public var stdin(default, null) : haxe.io.Output;
	var childProcess : NodeChildProcess;
	var childProcessExitCode : Null<Int> = null;

	public function new( cmd : String, args : Array<String> ) : Void {
		childProcess = Node.child_process.spawn(cmd, args);
		childProcess.once('close', function(code : Int, signal : String) : Void {
			childProcessExitCode = code;
		});
		stdin = new js.nodejs.io.Output(childProcess.stdin);
		stdout = new js.nodejs.io.Input(childProcess.stdout);
		stderr = new js.nodejs.io.Input(childProcess.stderr);
	}

	public function getPid() : Int {
		return childProcess.pid;
	}

	public function exitCode() : Int {
		while (childProcessExitCode == null) {
			js.nodejs.Sys.processMessages();
		}
		return childProcessExitCode;
	}

	public function close() : Void {
		childProcess.kill('SIGKILL');
	}

	public function kill() : Void {
		childProcess.kill('SIGTERM');
	}
}