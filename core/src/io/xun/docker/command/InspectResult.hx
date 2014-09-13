package io.xun.docker.command;

typedef InspectResult = {
	var Args : Array<String>;
	var Config : InspectResultConfig;
	var Created : String;
	var Driver : String;
	var ExecDriver : String;
	var HostConfig : InspectResultHostConfig;
	var HostnamePath : String;
	var HostsPath : String;
	var Id : String;
	var Image : String;
	var MountLabel : String;
	var Name : String;
	var NetworkSettings : InspectResultNetworkSettings;
	var Path : String;
	var ProcessLabel : String;
	var ResolvConfPath : String;
	var State : InspectResultState;
	var Volumes : Dynamic;
	var VolumesRW : Dynamic;
}

typedef InspectResultConfig = {
	var AttachStderr : Bool;
	var AttachStdin : Bool;
	var AttachStdout : Bool;
	var Cmd : Array<String>;
	var CpuShares : Int;
	var Cpuset : String;
	var Entrypoint : Null<Dynamic>;
	var Env : Array<String>;
	var ExposedPorts : Null<Dynamic>;
	var Hostname : String;
	var Image : String;
	var Memory : Int;
	var MemorySwap : Int;
	var NetworkDisabled : Bool;
	var OnBuild : Null<Dynamic>;
	var OpenStdin : Bool;
	var PortSpecs : Null<Dynamic>;
	var StdinOnce : Bool;
	var Tty : Bool;
	var User : String;
	var Volumes : Null<Dynamic>;
	var WorkingDir : String;
}

typedef InspectResultHostConfig = {
	var Binds : Null<Dynamic>;
	var CapAdd : Null<Dynamic>;
	var CapDrop : Null<Dynamic>;
	var ContaienrIDFile : String;
	var Devices : Array<Dynamic>;
	var Dns : Null<Dynamic>;
	var DnsSearch : Null<Dynamic>;
	var Links : Null<Dynamic>;
	var LxcConf : Array<Dynamic>;
	var NetworkMode : String;
	var PortBindings : Dynamic;
	var Privileged : Bool;
	var PublishAllPorts : Bool;
	var RestartPolicy : InspectResultHostConfigRestartPolicy;
	var VolumesFrom : Null<Dynamic>;
}

typedef InspectResultHostConfigRestartPolicy = {
	var MaximumRetryCount : Int;
	var Name : String;
}

typedef InspectResultNetworkSettings = {
	var Bridge : String;
	var Gateway : String;
	var IPAddress : String;
	var IPPrefixLen : String;
	var PortMapping : Null<Dynamic>;
	var Ports : Null<Dynamic>;
}

typedef InspectResultState = {
	var ExitCode : Int;
	var FinishedAt : String;
	var Paused : Bool;
	var Pid : Int;
	var Restarting : Bool;
	var Running : Bool;
	var StartedAt : String;
}