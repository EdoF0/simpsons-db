-- Extension containg the similarity() function
CREATE EXTENSION IF NOT EXISTS pg_trgm;

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
SELECT
    known_as,
    fandom_url,
    LENGTH(concat(full_name, image_url, gender, status, alias, hair_color, birth_country, job, first_appearance, first_mentioned, voice)) AS data_score
FROM raw_character
ORDER BY data_score DESC;
