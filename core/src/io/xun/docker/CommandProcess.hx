package io.xun.docker;

import haxe.Json;
import sys.io.Process;

class CommandProcess implements CommandProcessInterface {

    var binary : String;
    var command : CommandInterface;
    var process : Process;

    public function new(binary : String, command : CommandInterface) {
        this.binary = binary;
        this.command = command;
        this.command.setProcess(this);
        this.process = new Process(binary, command.getArguments());
    }

    public function kill() : Void {
        process.kill();
    }

    public function wait() : Void {
        getExitCode();
    }

    public function getCommand() : CommandInterface {
        return this.command;
    }

    public function getStdout() : String {
        wait();
        return this.process.stdout.readAll().toString();
    }

    public function getStderr() : String {
        wait();
        return this.process.stderr.readAll().toString();
    }

    public function getResult() : Array<{}> {
        return Json.parse(this.getStdout());
    }

    public function getExitCode() : Int {
        return process.exitCode();
    }

    public function wasSucessfull() : Bool {
        return this.getExitCode() == command.getExpectedExitCode();
    }

    public function close() : Void {
        this.process.close();
    }

}
