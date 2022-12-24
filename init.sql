
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

CREATE TABLE scraping_fandom_characters (
    fandom_url varchar(256) PRIMARY KEY,
    known_as varchar(128) NOT NULL,
    full_name varchar(128),
    image_url varchar(256),
    age bigint,
    species varchar(64),
    gender varchar(64),
    condition varchar(64),
    fictional boolean,
    alias varchar(1280),
    hair_color varchar(128),
    color varchar(64),
    birth_country varchar(64),
    job varchar(384),
    first_appearance varchar(128),
    first_mentioned varchar(128),
    voice varchar(768),
    creation_time timestamp NOT NULL DEFAULT NOW()
)
