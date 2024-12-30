# Postgresql user defined functions

Postgresql allows for defining user defined functions in C (or any language that compiles to C). These functions are compiled as `dynamically loadable objects` that are
loaded by Postgres using the `CREATE FUNCTION add(integer, integer)  AS 'funcs', 'add' LANGUAGE C STRICT;`

The full reference can be found [here](https://www.postgresql.org/docs/current/xfunc-c.html).

## Project structure

The `src` folder contains different implementations of a simple function in different languages.

## Running the project

The project provides a Postgres 17 docker image that mounts the `src` directory in the `/usr/local/pg-functions` and adds the later to the `dynamic_library_path` parameter in `postgresql.conf`.
