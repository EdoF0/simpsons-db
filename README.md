# simpsons-db

Database to store data about Simpsons characters and episodes.

![simpsons](https://user-images.githubusercontent.com/92382378/204278976-e3f2294b-27af-4e99-8766-64f8f10381d9.jpg)

The objective of this project is to individuate, among all characters, the ones that makes the episode more appreciated and less appreciated, in other words, the characters that can make an episode good or bad.

## Path to good data

### Raw data

Raw data sources and tables:

- [Fandom characters scraping](https://github.com/EdoF0/simpsons-characters-scraper): `scraping_fandom_character`
- [Fandom episodes](https://github.com/pcavana/Data-Management): `scraping_fandom_episode`
- [IMDb episodes](https://github.com/jultsmbl/IMDd_Scraper): `scraping_imdb_episode`

Raw data checking and cleaning is supposed to happen inside the scraper.

Raw data import statements are inside the file `import.sql`.

### Episode merging

To merge the two episodes tables, we create a view. The view will be generated from a join based on the episode absolute number.  
The view should keep all the data from the two sources (Fandom and IMDb).

Why joining on episode absolute number?  
Some Fandom episodes do not have a season number, so we cannot make the couple season - relative episode number the join attribute.
All IMDb episodes do not have the production code, so we cannot use it as primary key.
We chose the absolute number as episode identifier because it's always available on Fandom and can be easily generated form season and relative episode number.
Moreover, the episode title and air date are less reliable and could require a non-exact match.  
For the same reasons, the episode absolute number is going to be the episodes primary key.

### Characters table (TODO notes)

primary key: normalized known as because it's not null for sure

gender -> 3 boolean columns male female other
condition -> 3 boolean columns alive deceased other
alias -> array
job -> array
voice -> array

### Episodes table (TODO notes)

primary key: episode absolute number

merge season -> keep IMDb only because always available, warn when the two differ
merge episode number relative -> keep IMDb only because not available in Fandom scraping data
title -> 
airdate -> 
keep main character field

### Main character table (TODO notes)

primary key: episode absolute number and character known as

alias -> character variant for that episode, if any

## Normalization

In the database some strings are normalized.  
This is what normalization means in this project:

- [Unicode Normalization Form](https://www.unicode.org/reports/tr15/tr15-53.html) NFKD
- To lowercase
- Trim initial and final space separator characters:
  - `''` (space)
  - `' '` (No-Break Space)
  - `' '` (Ogham Space Mark)
  - `' '` (En Quad)
  - `' '` (Em Quad)
  - `' '` (En Space)
  - `' '` (Em Space)
  - `' '` (Three-Per-Em Space)
  - `' '` (Four-Per-Em Space)
  - `' '` (Six-Per-Em Space)
  - `' '` (Figure Space)
  - `' '` (Punctuation Space)
  - `' '` (Thin Space)
  - `' '` (Hair Space)
  - `' '` (Narrow No-Break Space)
  - `' '` (Medium Mathematical Space)
  - `'　'` (Ideographic Space)
  - `'⠀'` (Braille Blank)
- Remove the following characters:
  - brackets: `'()[]{}<>'`
  - apostrophes: `'’'"'`
  - punctuation: `',.;:?!'`
  - slashes: `'/\'`
  - common math: `'+-*'`
  - currency: `'$£€'`
  - other: `'|_@&~#%'`

In PosgreSQL this can be done with the following code
```sql
regexp_replace(trim('               　⠀' FROM lower(normalize(string_here, NFKD))), '[()\[\]{}<>’''",.;:?!\/\\+\-*$£€|_@&~#%]', '', 'g')
```
