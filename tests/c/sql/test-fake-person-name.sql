-- Custom assertion function
CREATE FUNCTION assert_person_name(result text) RETURNS boolean AS $$
BEGIN
    RETURN character_length(result) > 0;
END
$$ LANGUAGE plpgsql;


-- Create the custom function
CREATE FUNCTION fake_person_name() RETURNS text AS 'pg_faker', 'fake_person_name' LANGUAGE C STRICT;

-- Run the test
SELECT assert_person_name(fake_person_name());
