EXTENSION := pg_faker
DATA := pg_faker--0.1.sql
MODULE_big := pg_faker
PG_CONFIG := pg_config

# C code compilation setup
SRCDIR := ../src/c
OBJS := $(SRCDIR)/pg_faker.o
PG_CPPFLAGS := -I$(shell $(PG_CONFIG) --includedir) -I$(shell $(PG_CONFIG) --includedir-server) -I$(SRCDIR)

# Regression testing options: can use `make installcheck`
TESTDIR := "../tests/c"
REGRESS := test-extension
REGRESS_OPTS := --user=postgres --port=5432 --inputdir=$(TESTDIR)

# PGXS infrastructure default code
PGXS := $(shell $(PG_CONFIG) --pgxs)
include $(PGXS)

# Compilation
%.o: %.c
	$(CC) $(CFLAGS) $(PG_CPPFLAGS) -c $< -o $@

# Formatting using pgindent
.PHONY: format
format:
	pgindent --typedefs=$(SRCDIR)/typedefs.list $(SRCDIR)/*.c