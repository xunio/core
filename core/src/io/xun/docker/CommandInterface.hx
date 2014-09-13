package io.xun.docker;

interface CommandInterface
{

	public function setProcess(process : CommandProcessInterface) : Void;

	public function getArguments() : Array<String>;

	public function getExpectedExitCode() : Int;

}
