package io.xun.docker;

interface CommandProcessInterface
{

    public function kill() : Void;

    public function wait() : Void;

    public function getCommand() : CommandInterface;

    public function getStdout() : String;

    public function getResult() : Dynamic;

    public function getStderr() : String;

    public function getExitCode() : Int;

    public function wasSucessfull() : Bool;

    public function close() : Void;

}
