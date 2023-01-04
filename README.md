# simpsons-db

Database to store data about Simpsons characters and episodes.

![simpsons](https://user-images.githubusercontent.com/92382378/204278976-e3f2294b-27af-4e99-8766-64f8f10381d9.jpg)

## Path to good data

### Raw data

Raw data sources and tables:

- [Fandom characters scraping](https://github.com/EdoF0/simpsons-characters-scraper): `scraping_fandom_character`
- [Fandom episodes](https://github.com/pcavana/Data-Management): `scraping_fandom_episode`
- [IMDB episodes](https://github.com/jultsmbl/Simpsons_Scraper): `scraping_imdb_episode`

The data import for every table is actually a manual csv import through pgAdmin GUI.

Raw data checking and cleaning is supposed to happen inside the scraper.

## Normalization

In the database some strings are normalized.  
This is what normalization means in this project:

- All string to lowercase
- Trim initial and final space separator characters
