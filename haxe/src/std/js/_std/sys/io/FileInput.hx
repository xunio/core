package sys.io;

#if nodejs
typedef FileInput = js.nodejs.sys.io.FileInput;
#else
#error
typedef FileInput = js.nodejs.sys.io.FileInput;
#end