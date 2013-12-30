all:
	g++ ./src/clipboard.cpp -shared -o ./bin/clipboard.ndll -I./include -Wall -lX11 -lXmu -ldl -fPIC -fpermissive
test:
	g++ ./src/clipboard.cpp -o ./bin/clipboard -I./include -Wall -lX11 -lXmu -ldl -fPIC  -fpermissive
