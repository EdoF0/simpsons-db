-- Table for Simpsons characters
CREATE TABLE character (
    -- Normalized name to facilitate name comparisons.
    -- To see what is the normalization process, go to README.md
    normalized_name varchar(64) PRIMARY KEY,
    -- Original name not normalized
    full_name varchar(64) NOT NULL,
    -- Creation time of the data row
    creation_time timestamp NOT NULL DEFAULT NOW()
);

-- Table for Simpsons episodes
CREATE TABLE episode (
    episode_number_absolute smallint PRIMARY KEY,
    season tinyint NOT NULL,
    episode_number_relative tinyint NOT NULL,
    title varchar(64) NOT NULL,
    rating tinyint,
    reviews_amount integer,
    airdate date,
    written_by varchar(64),
    directed_by varchar(64),
    production_code varchar(6) UNIQUE NOT NULL,
    fandom_url varchar(256) UNIQUE,
    image_url varchar(256) UNIQUE,
    imdb_url varchar(256) UNIQUE,
    creation_time timestamp NOT NULL DEFAULT NOW()
);

-- Table linking every episode to their main characters
CREATE TABLE main_character (
    episode smallint PRIMARY KEY,
    person varchar(64) PRIMARY KEY
);


-- scraper: https://github.com/EdoF0/simpsons-characters-scraper
CREATE TABLE scraping_fandom_character (
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
);

-- scraper: https://github.com/pcavana/Data-Management
CREATE TABLE scraping_fandom_episode (
    fandom_url varchar(256) PRIMARY KEY,
    title varchar(64) NOT NULL,
    image_url varchar(256),
    season tinyint,
    episode_number_absolute smallint,
    production_code varchar(6) UNIQUE NOT NULL,
    airdate date,
    main_characters varchar(64),
    written_by varchar(64),
    directed_by varchar(64),
    creation_time timestamp NOT NULL DEFAULT NOW()
);
CREATE INDEX scraping_fandom_episode_episode_number_absolute ON scraping_fandom_episode (episode_number_absolute);

-- scraper: https://github.com/jultsmbl/IMDd_Scraper
CREATE TABLE scraping_imdb_episode (
    imdb_url varchar(256) PRIMARY KEY,
    season tinyint,
    episode_number_relative tinyint,
    episode_number_absolute smallint,
    title varchar(64),
    airdate date,
    rating tinyint, -- TODO check between 1 and 100
    reviews_amount integer,
    creation_time timestamp NOT NULL DEFAULT NOW()
);
CREATE INDEX scraping_imdb_episode_episode_number_absolute ON scraping_imdb_episode (episode_number_absolute);

CREATE TABLE scraping_episode (
    episode_number_absolute smallint PRIMARY KEY,
    season_fandom tinyint,
    season_imdb tinyint,
    episode_number_relative_fandom tinyint,
    episode_number_relative_imdb tinyint,
    title_fandom varchar(64) NOT NULL,
    title_imdb varchar(64) NOT NULL,
    main_characters varchar(64),
    rating tinyint,
    reviews_amount integer,
    airdate_fandom date,
    airdate_imdb date,
    written_by varchar(64),
    directed_by varchar(64),
    production_code varchar(6) UNIQUE NOT NULL,
    fandom_url varchar(256) UNIQUE,
    image_url varchar(256) UNIQUE,
    imdb_url varchar(256) UNIQUE,
    creation_time timestamp NOT NULL DEFAULT NOW()
);
