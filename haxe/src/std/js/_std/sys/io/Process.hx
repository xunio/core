package sys.io;

#if nodejs
typedef Process = js.nodejs.sys.io.Process;
#else
#error
typedef Process = js.nodejs.sys.io.Process;
#end