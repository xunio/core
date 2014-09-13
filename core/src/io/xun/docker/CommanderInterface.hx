package io.xun.docker;

interface CommanderInterface
{

	public function execute(command : CommandInterface) : CommandProcessInterface;

}
