PG17_libdir := /usr/lib/postgresql/17/lib

.PHONY: build
build:
	cc -I/usr/include/postgresql/17/server -fPIC -c custom_function.c
	cc -shared -o custom_function.so custom_function.o
	cp custom_function.so /usr/lib/postgresql/17/lib