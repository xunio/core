package ;

#if nodejs
typedef Sys = js.nodejs.Sys;
#else
#error
typedef Sys = js.nodejs.Sys;
#end