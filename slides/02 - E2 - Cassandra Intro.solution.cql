--------------
-- ESERCIZIO 1
--------------

CREATE KEYSPACE killrvideo WITH REPLICATION = { 'class': 'SimpleStrategy', 'replication_factor' : 1 };

USE killrvideo;

CREATE TABLE videos( 
  video_id TIMEUUID, 
  added_date TIMESTAMP,
  description TEXT, 
  title TEXT, 
  user_id uuid,
  PRIMARY KEY (video_id) 
);

COPY videos
FROM '/root/labwork/exercise-2/videos.csv' 
WITH HEADER=true;

SELECT * 
FROM videos; 

SELECT COUNT(*) 
FROM videos; 

SELECT * 
FROM videos
LIMIT 10;


--------------
-- ESERCIZIO 2
--------------

CREATE TABLE videos_by_title_year(  
  title TEXT, 
  added_year int,
  added_date TIMESTAMP,
  description TEXT,
  user_id uuid,
  video_id TIMEUUID,
  PRIMARY KEY ((title, added_year)) 
);

COPY videos_by_title_year
FROM '/root/labwork/exercise-3/videos_by_title_year.csv' 
WITH HEADER=true;


SELECT * 
FROM videos_by_title_year 
WHERE title = 'Sleepy Grumpy Cat'
AND added_year = 2015; 

SELECT * 
FROM videos_by_title_year 
WHERE added_year = 2015; 


--------------
-- ESERCIZIO 3
--------------

CREATE TABLE videos_by_tag_year(  
  tag TEXT, 
  added_year int,
  added_date TIMESTAMP,
  title TEXT, 
  description TEXT,
  user_id uuid,
  video_id TIMEUUID,
  PRIMARY KEY ((tag), added_year, video_id) 
) WITH CLUSTERING ORDER BY (added_year DESC);

COPY videos_by_tag_year
FROM '/root/labwork/exercise-4/videos_by_tag_year.csv' 
WITH HEADER=true;

SELECT * FROM videos_by_tag_year
WHERE tag= 'trailer' AND added_year = 2015; 

SELECT * FROM videos_by_tag_year
WHERE tag= 'cql' AND added_year < 2015; 

SELECT * FROM videos_by_tag_year
WHERE added_year < 2015
ALLOW FILTERING;

SELECT * FROM videos_by_tag_year
WHERE tag= 'cql'; 


--------------
-- ESERCIZIO 4
--------------

TRUNCATE videos;

ALTER TABLE videos ADD tags SET<TEXT>;

COPY videos FROM '/root/labwork/exercise-5/videos.csv' WITH HEADER=true;

CREATE TYPE video_encoding ( 
  bit_rates SET<TEXT>, 
  encoding text, 
  height int, 
  width int
); 

ALTER TABLE videos ADD encoding FROZEN<video_encoding>;

COPY videos (video_id, encoding)
FROM '/root/labwork/exercise-5/videos_encoding.csv' 
WITH HEADER=true;

SELECT * FROM videos LIMIT 10;


--------------
-- ESERCIZIO 5
--------------

CREATE TABLE videos_count_by_tag(  
  tag TEXT, 
  added_year int,
  video_count COUNTER,
  PRIMARY KEY ((tag), added_year) 
);

SOURCE '/root/labwork/exercise-6/videos_count_by_tag.cql';

SELECT * FROM videos_count_by_tag LIMIT 5;

UPDATE videos_count_by_tag 
SET video_count = video_count + 10
WHERE tag = 'You Are Awesome' AND added_year = 2015;

SELECT * FROM videos_count_by_tag
WHERE tag = 'You Are Awesome';


--------------
-- ESERCIZIO 6
--------------

CREATE TABLE videos_by_actor ( 
  actor text, 
  added_date timestamp,
  video_id timeuuid,  
  character_name text,
  description text,
  encoding frozen<video_encoding>,
  tags set<text>, 
  title text, 
  user_id uuid,
  PRIMARY KEY ((actor), added_date, 
    video_id, character_name) 
) WITH CLUSTERING ORDER BY (
  added_date DESC,
  video_id ASC,
  character_name ASC
);

COPY videos_by_actor 
FROM '/root/labwork/exercise-7/videos_by_actor.csv' 
WITH HEADER=true;

SELECT * 
FROM videos_by_actor 
WHERE actor = 'Tom Hanks';

SELECT actor, added_date
FROM videos_by_actor 
WHERE actor = 'Tom Hanks';


CREATE TABLE videos_by_genre ( 
  genre text, 
  added_date timestamp,
  video_id timeuuid, 
  description text,
  encoding frozen<video_encoding>,
  tags set<text>, 
  title text, 
  user_id uuid,
  PRIMARY KEY ((genre), added_date, 
    video_id) 
) WITH CLUSTERING ORDER BY (
  added_date DESC,
  video_id ASC
);

COPY videos_by_genre 
FROM '/root/labwork/exercise-7/videos_by_genre.csv' 
WITH HEADER=true;

SELECT * 
FROM videos_by_genre 
WHERE genre = 'Time travel';