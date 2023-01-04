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

### Episode merging

To merge the two episodes tables, we create a view. The view will be generated from a join based on the episode absolute number.  
The view should keep all the data from the two sources (Fandom and IMDB).

Why joining on episode absolute number?  
Some Fandom episodes do not have a season number, so we cannot make the couple season - relative episode number the join attribute.
All IMDB episodes do not have the production code, so we cannot use it as primary key.
We chose the absolute number as episode identifier because it's always available on Fandom and can be easily generated form season and relative episode number.
Moreover, the episode title and air date are less reliable and could require a non-exact match.  
For the same reasons, the episode absolute number is going to be the episodes primary key.

## Normalization

In the database some strings are normalized.  
This is what normalization means in this project:

- All string to lowercase
- Trim initial and final space separator characters
