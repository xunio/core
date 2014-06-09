package sys.net;

#if nodejs
typedef Socket = js.nodejs.sys.net.Socket;
#else
#error
typedef Socket = js.nodejs.sys.net.Socket;
#end