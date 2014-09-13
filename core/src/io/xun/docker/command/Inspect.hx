package io.xun.docker.command;

class Inspect extends AbstractCommand implements CommandInterface {

	var container : ContainerInterface;

	public function new(container : ContainerInterface) {
		this.container = container;
	}

	public function getArguments() : Array<String> {
		return [
			'inspect',
			container.getReference()
		];
	}
}
