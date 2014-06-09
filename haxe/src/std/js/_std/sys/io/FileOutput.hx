package sys.io;

#if nodejs
typedef FileOutput = js.nodejs.sys.io.FileOutput;
#else
#error
typedef FileOutput = js.nodejs.sys.io.FileOutput;
#end