-- custom assertions
CREATE FUNCTION assert_valid_age(result integer, min_age integer) RETURNS boolean AS $$
BEGIN
    RETURN result >= min_age AND result <= 100; -- max age is hard-coded 
END
$$ LANGUAGE plpgsql;

CREATE FUNCTION assert_person_name(result text) RETURNS boolean AS $$
BEGIN
    RETURN character_length(result) > 0;
END
$$ LANGUAGE plpgsql;

-- Create extension
CREATE extension pg_faker;

-- Run tests
SELECT assert_person_name(fake_person_name());
SELECT assert_valid_age(fake_age(), 0);
SELECT assert_valid_age(fake_age(18), 18);
