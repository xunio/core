package io.xun.docker;

class Commander implements CommanderInterface
{
    var binary : String;

    public function new(binary : String)
    {
        this.binary = binary;
    }

    public function execute(command : CommandInterface) : CommandProcessInterface
    {
        return new CommandProcess(this.binary, command);
    }
}
