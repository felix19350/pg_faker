# pg_faker

DISCLAIMER: This is merely a learning exercise to get familiarized with the development of Postgresql extensions.

This extension provides a set of C custom functions that implement various utility methods to create mock data, somewhat inspired by projects like [Faker](https://faker.readthedocs.io/en/master/).

## Project structure

The project has the following structure:

```
├── dev-infra // Development infrastructure
├── extension // Postgres extension definition
├── src
│   └── c    // C source code for the custom functions
└── tests
    └── c
        ├── expected // Expected results for each test
        └── sql      // SQL test scripts

```

The `dev-infra` folder contains a ready to use Postgres 17 container that can be used as a development environment

The `extension` folder contains the Postgresql extension definition and the Makefile that should be used to build and test the extension

The `src` folder contains different implementations of a simple function in different languages (currently only C).

The `tests` folder contains the unit tests for the implemented custom functions.

## Using the provided development environment

The project provides a Postgres 17 docker image that mounts the project directory to `/usr/share/pg-custom-functions` and can be used as a self-contained development environment - don't use it for production purposes.

You can build the Docker image using Makefile in the `dev-infra` folder. Use `make build-container` command and then run it using `make run-container`. From there you can create a shell to that container and start hacking or attach Visual Studio Code to a running docker container.

## Building the project

In order to build the custom function the the libraries and headers for C language backend development are required (`postgresql-server-dev-17`).

The `./src/c` directory contains the source code for the extension and it needs to be compiled as a shared library so it can be dynamically loaded by Postgresql. In order to build the code, use the Makefile in
the `extension` directory and run the `make install` command. If this command is successful, you are ready to go.

This basically takes the compiled shared library and places it in the correct directory (e.g. `/usr/lib/postgresql/17/lib`) and copies the extension control and data file to the correct directory (e.g. `/usr/share/postgresql/17/extension`)

## Using the custom functions

In order to use the custom functions in Postgresql you need to connect to the server (if using the provided docker image the default username is `postgres` and the default password is `password`) using for instance the psql client (`psql -h 127.0.0.1 -p 5432 -U postgres`).

The custom functions need to be created in the server and this can be achieved with the following commands:

```sql
CREATE EXTENSION pg_faker;
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

The tests can be executed by running the `make installcheck` command (from the Makefile in the `extension` directory), which will connect to the development server
and run the test SQL script and compare the output with the expectations.

After running the tests a new `results` directory is created with the output and the diff (if there are any differences between the expectations and the output).


## Development tips and tricks

### Formating the code

You can format the code using the [pgindent](https://github.com/postgres/postgres/tree/master/src/tools/pgindent) utility. For this, use the Makefile in
the `extension` directory and run the `make format` command

### Setting up VS Code

If you are using VS Code you can create a specific configuration for the provided container development environment by creating a `.vscode/c_cpp_properties.json` file with the following contents (your mileage may vary especially if you are using an ARM CPU):

```json
    "configurations": [
        {
            "name": "Dev container",
            "intelliSenseMode": "linux-gcc-x86",
            "includePath": [
                "${workspaceFolder}/src",
                "/usr/include/postgresql/17/server",
                "/usr/include/postgresql",
                "/usr/include/x86_64-linux-gnu"
            ],
            "cStandard": "c89",
            "compilerPath": "/usr/bin/gcc",
            "compilerArgs": [
                "-I/usr/include/postgresql -I/usr/include/postgresql/17/server -Wall"
            ]
        }
    ]
```

## Useful Resources:

* [Postgres custom functions](https://www.postgresql.org/docs/current/xfunc-c.html)
* [Postgres extensions](https://www.postgresql.org/docs/17/extend-extensions.html)
* [Postgres test infrastructure](https://www.postgresql.org/docs/current/regress-run.html)
