package io.xun.docker;

import io.xun.docker.command.InspectResult;
import io.xun.docker.command.InspectResult.InspectResultState;
import io.xun.docker.command.Inspect;

class Container implements ContainerInterface
{

	var commander : CommanderInterface;
	var reference : String;

	public function new(reference : String) {
		this.reference = reference;
	}

	public function getReference() : String {
		return reference;
	}

	public function getName() : String {
		return inspect().Name;
	}

	public function getId() : String {
		return inspect().Id;
	}

	public function getState() : InspectResultState {
		return inspect().State;
	}

	public function setCommander(commander : CommanderInterface) {
		this.commander = commander;
	}

	public function isAvailable() : Bool {
		return commander.execute(new Inspect(this)).wasSucessfull();
	}

	public function start() : Bool {
		throw "Not implemented";
		return false;
	}

	public function stop() : Bool {
		throw "Not implemented";
		return false;
	}

	public function inspect() : InspectResult {
		if (!isAvailable()) {
			throw "Not available!";
		}
		var data : Array<InspectResult> = cast this.commander.execute(new Inspect(this)).getResult();
		return data[0];
	}

}
