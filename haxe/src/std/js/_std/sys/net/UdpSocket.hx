package sys.net;

#if nodejs
typedef UdpSocket = js.nodejs.sys.net.UdpSocket;
#else
#error
typedef UdpSocket = js.nodejs.sys.net.UdpSocket;
#end