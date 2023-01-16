-- Extension containg the similarity() function
CREATE EXTENSION IF NOT EXISTS pg_trgm;

-- String normalization function
CREATE FUNCTION norm(t text) RETURNS text AS $$
    SELECT
        regexp_replace(trim('               　⠀' FROM lower(normalize(t, NFKD))), '[()\[\]{}<>’''",.;:?!\/\\+\-*$£€|_@&~#%]', '', 'g');
$$ LANGUAGE SQL;

--
-- character cleaning
--

-- Find duplicate known_as
WITH occ AS (
    SELECT
        known_as,
        COUNT(DISTINCT fandom_url) as occurencies
    FROM raw_character
    GROUP BY known_as
    HAVING COUNT(DISTINCT fandom_url) > 1
)
SELECT
    fandom_url,
    occ.known_as,
    occ.occurencies
FROM
    occ LEFT JOIN raw_character AS ch
    ON occ.known_as = ch.known_as
ORDER BY occ.known_as;

-- raw data ready for merging
-- can use the table as ranking because data_score is a proxy for popularity
CREATE VIEW ready_raw_character AS SELECT
    known_as,
    fandom_url,
    LENGTH(concat(full_name, image_url, gender, status, alias, hair_color, birth_country, job, first_appearance, first_mentioned, voice)) AS data_score
FROM raw_character
ORDER BY data_score DESC;

-- future merged characters temporary table
-- note: groups can have 0 or 1 representant
CREATE TABLE unmerged_character AS SELECT
    (
        SELECT
            subc.known_as
        FROM ready_raw_character AS subc
        WHERE similarity(c.known_as, subc.known_as) > 0.6
        ORDER BY subc.data_score DESC
        LIMIT 1
    ) AS "group",
    (
        SELECT
            subc.fandom_url
        FROM ready_raw_character AS subc
        WHERE similarity(c.known_as, subc.known_as) > 0.6
        ORDER BY subc.data_score DESC
        LIMIT 1
    ) = c.fandom_url AS representative,
    c.known_as,
    c.fandom_url,
    c.data_score
FROM ready_raw_character AS c
ORDER BY "group" ASC, representative DESC;

-- view not represented characters and correct group
CREATE VIEW not_represented AS SELECT
    nr.representatives_count,
    nr.members_count,
    nr."group" AS group_old,
    uc."group" AS group_new
FROM
    (
        SELECT
            "group",
            count(CASE WHEN representative THEN 1 END) AS representatives_count,
            count(fandom_url) AS members_count
        FROM unmerged_character
        GROUP BY "group"
        HAVING count(CASE WHEN representative THEN 1 END) = 0
    ) AS nr
    INNER JOIN unmerged_character AS uc ON nr."group" = uc.known_as;

-- character insert data final statement
INSERT INTO "character" (
    normalized_name,
    known_as,
    fandom_url
)
SELECT
    norm(known_as),
    known_as,
    fandom_url
FROM unmerged_character
WHERE representative = TRUE;

--
-- episode cleaning
--

DELETE FROM scraping_fandom_episode WHERE airdate > NOW();
DELETE FROM scraping_imdb_episode WHERE airdate > NOW();

-- episode insert data final statement
INSERT INTO episode (
    episode_number_absolute,
    episode_number_relative,
    season,
    title,
    rating,
    reviews_amount,
    fandom_url,
    imdb_url
)
SELECT
    episode_number_absolute,
    episode_number_relative,
    imdb_season,
    fandom_title,
    rating,
    reviews_amount,
    fandom_url,
    imdb_url
FROM raw_episode;
