#include <string.h>
#include <stdlib.h>
#include "postgres.h"
#include "fmgr.h"
#include "varatt.h"
#include "utils/builtins.h"

/*  Ensure the dynamically loaded object file is not loaded into an incompatible server, */
PG_MODULE_MAGIC;

/*  Postgres native C function calling convention. */
/*  Each function made available to postgres should be registered with the PG_FUNCTION_INFO_V1 macro */

PG_FUNCTION_INFO_V1(fake_person_name);
Datum
fake_person_name(PG_FUNCTION_ARGS)
{
	char	   *names[] = {
		"Xiomara",
		"Priya",
		"Aoife",
		"Ibrahim",
		"Yuki",
		"Kenzo",
		"Chioma",
		"Magnus",
		"Zhen",
	"Miriam"};
	int			names_len = sizeof(names) / sizeof(names[0]);

	char	   *surnames[] = {
		"Patel",
		"Kim",
		"Müller",
		"Chen",
		"Silva",
		"O'Connor",
		"Popov",
		"Nguyen",
		"García",
	"Kowalski"};
	int			surnames_len = sizeof(surnames) / sizeof(surnames[0]);

	char	   *selected_name = names[rand() % names_len];
	char	   *selected_surname = surnames[rand() % surnames_len];

	int			length = strlen(selected_name) + 1 + strlen(selected_surname);
	char		full_name[length];

	sprintf(full_name, "%s %s", selected_name, selected_surname);

	/*
	 * See:
	 * https://github.com/postgres/postgres/blob/11012c503759f8018d8831bc6eb1f998eba7ad25/src/backend/utils/adt/varlena.c#L184
	 */
	PG_RETURN_TEXT_P(cstring_to_text(full_name));
}

int
_fake_age(int min_age)
{
	const int	max_reasonable_age = 100;

	if (min_age > max_reasonable_age)
	{
		char		error_msg[64];

		sprintf(error_msg, "That is not a reasonable age. Max supported age is %.13d", max_reasonable_age);
		ereport(ERROR, errcode(ERRCODE_FEATURE_NOT_SUPPORTED), errmsg(error_msg));
	}

	return min_age + (rand() % (max_reasonable_age - min_age));
}

PG_FUNCTION_INFO_V1(fake_age);
Datum
fake_age(PG_FUNCTION_ARGS)
{
	int			min_age = PG_GETARG_INT32(0);

	PG_RETURN_INT32(_fake_age(min_age));
}

PG_FUNCTION_INFO_V1(fake_age_no_minimum);
Datum
fake_age_no_minimum(PG_FUNCTION_ARGS)
{
	PG_RETURN_INT32(_fake_age(0));
}
