package sys.net;

#if nodejs
typedef Host = js.nodejs.sys.net.Host;
#else
#error
typedef Host = js.nodejs.sys.net.Host;
#end