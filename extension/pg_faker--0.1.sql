CREATE FUNCTION fake_person_name() RETURNS text AS 'pg_faker', 'fake_person_name' LANGUAGE C STRICT;
CREATE FUNCTION fake_age() RETURNS integer AS 'pg_faker', 'fake_age_no_minimum' LANGUAGE C STRICT;
CREATE FUNCTION fake_age(integer) RETURNS integer AS 'pg_faker', 'fake_age' LANGUAGE C STRICT;