package io.xun.docker;

class AbstractCommand
{

    var process : CommandProcessInterface;

    public function setProcess(process : CommandProcessInterface) : Void {
        this.process = process;
    }

    public function getExpectedExitCode() : Int {
        return 0;
    }

}
