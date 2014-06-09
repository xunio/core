package sys.io;

#if nodejs
typedef File = js.nodejs.sys.io.File;
#else
#error
typedef File = js.nodejs.sys.io.File;
#end