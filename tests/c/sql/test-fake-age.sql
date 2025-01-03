-- Custom assertion function
CREATE FUNCTION assert_valid_age(result integer, min_age integer) RETURNS boolean AS $$
BEGIN
    RETURN result >= min_age AND result <= 100; -- max age is hard-coded 
END
$$ LANGUAGE plpgsql;


-- Create the custom functions
CREATE FUNCTION fake_age() RETURNS integer AS 'pg_faker', 'fake_age_no_minimum' LANGUAGE C STRICT;
CREATE FUNCTION fake_age(integer) RETURNS integer AS 'pg_faker', 'fake_age' LANGUAGE C STRICT;

-- Run the tests
SELECT assert_valid_age(fake_age(), 0);
SELECT assert_valid_age(fake_age(18), 18);