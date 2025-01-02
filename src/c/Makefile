PG_LIBDIR := /usr/lib/postgresql/17/lib
PG_INCLUDE_DIR := /usr/include/postgresql/17/server
BUILD_DIR := ./build
CUSTOM_FN_FILE := pg_faker

.PHONY: build
build:
# make build dir
	mkdir -p ./build
# Mompile as a shared object
	cc -I${PG_INCLUDE_DIR} -fPIC -Wall -c ${CUSTOM_FN_FILE}.c -o ${BUILD_DIR}/${CUSTOM_FN_FILE}.o
	cc -shared -o ${BUILD_DIR}/${CUSTOM_FN_FILE}.so ${BUILD_DIR}/${CUSTOM_FN_FILE}.o
# Move shared object to the postgresql libdir
	cp ${BUILD_DIR}/${CUSTOM_FN_FILE}.so ${PG_LIBDIR}