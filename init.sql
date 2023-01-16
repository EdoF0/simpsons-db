--
-- Raw data by source
--
-- In these tables raw data is imported
--

-- scraper: https://github.com/EdoF0/simpsons-characters-scraper
CREATE TABLE scraping_fandom_character (
    fandom_url varchar(256) PRIMARY KEY,
    known_as varchar(128) NOT NULL,
    full_name varchar(128),
    image_url varchar(256),
    age bigint,
    species varchar(64),
    gender varchar(64),
    status varchar(64),
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
);

-- scraper: https://github.com/pcavana/Data-Management
CREATE TABLE scraping_fandom_episode (
    fandom_url varchar(256) PRIMARY KEY,
    title varchar(128) NOT NULL,
    image_url varchar(256),
    season smallint,
    episode_number_absolute smallint,
    production_code varchar(6),
    airdate date,
    main_characters varchar(384),
    written_by varchar(256),
    directed_by varchar(256),
    creation_time timestamp NOT NULL DEFAULT NOW()
);
CREATE INDEX scraping_fandom_episode_episode_number_absolute ON scraping_fandom_episode (episode_number_absolute);

-- scraper: https://github.com/jultsmbl/IMDd_Scraper
CREATE TABLE scraping_imdb_episode (
    imdb_url varchar(256) PRIMARY KEY,
    season smallint,
    episode_number_relative smallint,
    episode_number_absolute smallint,
    title varchar(128),
    airdate date,
    rating smallint, -- TODO check between 1 and 100
    reviews_amount integer,
    creation_time timestamp NOT NULL DEFAULT NOW()
);
CREATE INDEX scraping_imdb_episode_episode_number_absolute ON scraping_imdb_episode (episode_number_absolute);

--
-- Raw data by entity
--
-- In these views raw data of different sources of the same entity are joined to be put side to side
--

CREATE VIEW raw_character AS SELECT
    known_as,
    full_name,
    image_url,
    age,
    species,
    gender,
    status,
    fictional,
    alias,
    hair_color,
    color,
    birth_country,
    job,
    first_appearance,
    first_mentioned,
    voice,
    fandom_url,
    creation_time
FROM scraping_fandom_character;

CREATE VIEW raw_episode AS SELECT
    im.episode_number_absolute,
    im.season AS imdb_season,
    fd.season AS fandom_season,
    im.episode_number_relative,
    fd.title AS fandom_title,
    im.title AS imdb_title,
    fd.image_url,
    fd.production_code,
    fd.airdate AS fandom_airdate,
    im.airdate AS imdb_airdate,
    fd.main_characters,
    fd.written_by,
    fd.directed_by,
    im.rating,
    im.reviews_amount,
    im.imdb_url,
    fd.fandom_url,
    im.creation_time AS imdb_creation_time,
    fd.creation_time AS fandom_creation_time
FROM scraping_fandom_episode as fd
INNER JOIN scraping_imdb_episode as im ON fd.episode_number_absolute=im.episode_number_absolute;

--
-- Clean data
--

-- Table for Simpsons characters (non canonical version of the same character should be merged with the original one)
CREATE TABLE character (
    normalized_name varchar(128) PRIMARY KEY, -- Normalized known_as property
    known_as varchar(128) UNIQUE NOT NULL, -- Original name not normalized
    fandom_url varchar(256) UNIQUE, -- Foreign key to raw data
    creation_time timestamp NOT NULL DEFAULT NOW(), -- Creation time of the data row
    -- Constraints
    CONSTRAINT fk_scraping_fandom FOREIGN KEY(fandom_url) REFERENCES scraping_fandom_character(fandom_url)
);

-- Table for all character aliases and in general the different ways that are called
CREATE TABLE alias (
    normalized_alias varchar(128) PRIMARY KEY, -- Normalized alias property
    alias varchar(128) UNIQUE NOT NULL, -- How the character is called
    "character" varchar(128) NOT NULL, -- The character (foreign key)
    creation_time timestamp NOT NULL DEFAULT NOW(), -- Creation time of the data row
    -- Constraints
    CONSTRAINT fk_character FOREIGN KEY("character") REFERENCES "character"(normalized_name)
);

-- Table for Simpsons episodes (not future episodes)
CREATE TABLE episode (
    episode_number_absolute smallint PRIMARY KEY,
    episode_number_relative smallint NOT NULL,
    season smallint NOT NULL,
    title varchar(128) NOT NULL,
    rating smallint,
    reviews_amount integer,
    fandom_url varchar(256) UNIQUE,
    imdb_url varchar(256) UNIQUE,
    creation_time timestamp NOT NULL DEFAULT NOW()
);

-- Table linking every episode to their main characters (through the alias table)
CREATE TABLE main_character (
    episode smallint,
    alias varchar(128),
    -- Constraints
    PRIMARY KEY (episode, alias),
    CONSTRAINT fk_episode FOREIGN KEY(episode) REFERENCES episode(episode_number_absolute),
    CONSTRAINT fk_alias FOREIGN KEY(alias) REFERENCES alias(normalized_alias)
);
