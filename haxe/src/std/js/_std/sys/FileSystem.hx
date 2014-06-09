package sys;

#if nodejs
typedef FileSystem = js.nodejs.sys.FileSystem;
#else
#error
typedef FileSystem = js.nodejs.sys.FileSystem;
#end