-- Character popularity ranking (best)
SELECT
    character.normalized_name,
    character.known_as,
    character.fandom_url,
    COUNT(episode.episode_number_absolute) AS number_of_episodes,
    AVG(episode.rating) AS average_episode_rating,
    COUNT(episode.episode_number_absolute)/2 + AVG(episode.rating) AS popularity_score
FROM
    "character"
    INNER JOIN "alias" ON character.normalized_name = "alias"."character"
    INNER JOIN main_character ON "alias".normalized_alias = main_character."alias"
    INNER JOIN episode ON main_character.episode = episode.episode_number_absolute
GROUP BY character.normalized_name
HAVING COUNT(episode.episode_number_absolute) > 1
ORDER BY COUNT(episode.episode_number_absolute)/2 + AVG(episode.rating) DESC
LIMIT 10;

-- Character popularity ranking (worst)
SELECT
    character.normalized_name,
    character.known_as,
    character.fandom_url,
    COUNT(episode.episode_number_absolute) AS number_of_episodes,
    AVG(episode.rating) AS average_episode_rating,
	    COUNT(episode.episode_number_absolute)/2 + AVG(episode.rating) AS popularity_score
FROM
    "character"
    INNER JOIN "alias" ON character.normalized_name = "alias"."character"
    INNER JOIN main_character ON "alias".normalized_alias = main_character."alias"
    INNER JOIN episode ON main_character.episode = episode.episode_number_absolute
GROUP BY character.normalized_name
HAVING COUNT(episode.episode_number_absolute) > 10
ORDER BY COUNT(episode.episode_number_absolute)/2 + AVG(episode.rating) ASC
LIMIT 5;
