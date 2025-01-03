REGRESS = test-fake-person-name test-fake-age
REGRESS_OPTS = --user=postgres --port=5432
PG_CONFIG = pg_config

PGXS := $(shell $(PG_CONFIG) --pgxs)
include $(PGXS)