package io.xun.docker;

import io.xun.docker.command.InspectResult;
import io.xun.docker.command.InspectResult.InspectResultState;

interface ContainerInterface {

    public function getReference() : String;

    public function getName() : String;

    public function getId() : String;

    public function getState() : InspectResultState;

    public function isAvailable() : Bool;

    public function start() : Bool;

    public function stop() : Bool;

    public function inspect() : InspectResult;

}
