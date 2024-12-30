#include "postgres.h"
#include <string.h>
#include "fmgr.h"
#include "utils/geo_decls.h"
#include "varatt.h"

PG_MODULE_MAGIC;

PG_FUNCTION_INFO_V1(add_one);

Datum add_one(PG_FUNCTION_ARGS)
{
    int32 arg = PG_GETARG_INT32(0);

    PG_RETURN_INT32(arg + 1);
}
