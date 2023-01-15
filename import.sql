-- scraping_fandom_character import statement
COPY scraping_fandom_character (
    fandom_url,
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
    voice
)
FROM
    '<STORAGE_DIR>/characters-14.01.2023-postgres.csv'
    DELIMITER ';' CSV HEADER ENCODING 'UTF8' QUOTE '\"' ESCAPE '\\';

-- scraping_fandom_episode import statement
COPY scraping_fandom_episode (
    fandom_url,
    title,
    image_url,
    season,
    episode_number_absolute,
    production_code,
    airdate,
    main_characters,
    written_by,
    directed_by
)
FROM
    '<STORAGE_DIR>/episodes-11.01.2023-postgres.csv'
    DELIMITER ';' CSV HEADER ENCODING 'UTF8' QUOTE '\"' ESCAPE '\\';

-- scraping_imdb_episode import statement
COPY scraping_imdb_episode (
    imdb_url,
    season,
    episode_number_relative,
    episode_number_absolute,
    title,
    airdate,
    rating,
    reviews_amount
)
FROM
    '<STORAGE_DIR>/scraping_imdb_episode.csv'
    DELIMITER ',' CSV HEADER ENCODING 'UTF8' QUOTE '\"';
