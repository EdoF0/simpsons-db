
-- Table for Simpsons characters

CREATE TABLE characters (
    -- Normalized name to facilitate name comparisons.
    -- To see what is the normalization process, go to README.md
    normalized_name varchar(64) PRIMARY KEY,
    -- Original name not normalized
    full_name varchar(64) NOT NULL,
    -- Creation time of the data row
    creation_time timestamp NOT NULL DEFAULT NOW()
);
