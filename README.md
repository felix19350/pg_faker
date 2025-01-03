# pg_faker

DISCLAIMER: This is merely a learning exercise to get familiarized with the development of Postgresql custom functions.

The full reference can be found [here](https://www.postgresql.org/docs/current/xfunc-c.html).
This project provides a set of C custom functions that implement various utility methods to create mock data, somewhat inspired by projects like [Faker](https://faker.readthedocs.io/en/master/).

The full reference for custom functions can be found [here](https://www.postgresql.org/docs/current/xfunc-c.html).

## Project structure

The project has the following structure:

```
├── src
│   └── c    // C source code for the custom functions
└── tests
    └── c
        ├── expected // Expected results for each test
        └── sql      // SQL test scripts

```

The `src` folder contains different implementations of a simple function in different languages (currently only C).

The `tests` folder contains the unit tests for the implemented
custom functions.

The project provides a Postgres 17 docker image that mounts the project directory to `/usr/share/pg-custom-functions` and can be used as a self-contained development environment - don't use it for production purposes.

You can build the Docker image using the `make build-container` command and then run it using `make run-container`. From there you can create a shell to that container and start hacking or attach Visual Studio Code to a running docker container.

## Building the project

In order to build the custom function the the libraries and headers for C language backend development are required (`postgresql-server-dev-17`).

The `./src/c` directory contains the source code for the extension and it needs to be compiled as a shared library so it can be dynamically loaded by Postgresql (see [official docs](https://www.postgresql.org/docs/17/xfunc-c.html#DFUNC) for more details).

This can be accomplished by running the `make build` command. The `build` target compiles the custom functions and moves the resulting shared library to the posgresql lib dir where the custom functions can be resolved by Postgresql.

## Using the custom functions

In order to use the custom functions in Postgresql you need to connect to the server (if using the provided docker image the default username is `postgres` and the default password is `password`) using for instance the psql client (`psql -h 127.0.0.1 -p 5432 -U postgres`).

The custom functions need to be created in the server and this can be achieved with the following commands:

```sql
CREATE FUNCTION fake_person_name() RETURNS text AS 'pg_faker', 'fake_person_name' LANGUAGE C STRICT;
CREATE FUNCTION fake_age() RETURNS integer AS 'pg_faker', 'fake_age_no_minimum' LANGUAGE C STRICT;
CREATE FUNCTION fake_age(integer) RETURNS integer AS 'pg_faker', 'fake_age' LANGUAGE C STRICT;
```

At this point the functions can be executed, for example:

```sql
SELECT fake_age();
```

Or for a more practical example of populating a database with mock data:

```sql
CREATE TABLE person(id BIGSERIAL PRIMARY KEY, name TEXT, age INTEGER);
INSERT INTO person(name, age) VALUES (fake_name(), fake_age(18));
SELECT * FROM person;
```

The select statement will return something along these lines:
```
 id |      name       | age 
----+-----------------+-----
  1 | Magnus O'Connor |  59
```

## Running the tests

The tests use the existing Postgresql test infrastructure (pg_regress). The tests are located in the `./tests/c` directory.

A test is comprised of two elements:
* The test SQL script to execute (in the `sql` directory)
* The expected outputs for the test (in the `expected` directory)

The tests can be executed by running the `make installcheck` command, which will connect to the development server and run the test SQL script and compare the output with the expectations.

The Makefile in this directory extends from the Postgresql extensions makefile and sets the `REGRESS` variable to point to the test SQL scripts (without the .sql extension).

After running the tests a new `results` directory is created with the output and the diff (if there are any differences between the expectations and the output).

The reference documentation for running tests can be found [here](https://www.postgresql.org/docs/current/regress-run.html).
