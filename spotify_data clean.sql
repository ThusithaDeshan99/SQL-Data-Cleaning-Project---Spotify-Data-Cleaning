SELECT * 
FROM `spotify_data clean`;

DESCRIBE `spotify_data clean`;

CREATE TABLE spotify_cleaned (
    id INT AUTO_INCREMENT PRIMARY KEY,

    track_id VARCHAR(50),
    track_name VARCHAR(255),
    track_number INT,
    track_popularity INT,

    explicit TINYINT(1),     

    artist_name VARCHAR(255),
    artist_popularity INT,
    artist_followers BIGINT, 
    artist_genres TEXT,

    album_id VARCHAR(50),
    album_name VARCHAR(255),
    album_release_date DATE, 
    album_total_tracks INT,
    album_type VARCHAR(50),

    track_duration_min DECIMAL(5,2)
);

SELECT * 
FROM `spotify_cleaned`;

UPDATE `spotify_data clean`
SET album_release_date = STR_TO_DATE(album_release_date, '%m/%d/%Y')
WHERE album_release_date LIKE '%/%/%';

UPDATE `spotify_data clean`
SET album_release_date = NULL
WHERE album_release_date < '1950-01-01'
   OR album_release_date > CURDATE();

INSERT INTO spotify_cleaned (
    track_id, track_name, track_number, track_popularity, explicit,
    artist_name, artist_popularity, artist_followers, artist_genres,
    album_id, album_name, album_release_date, album_total_tracks, album_type,
    track_duration_min
)
SELECT
    track_id,
    track_name,
    track_number,
    track_popularity,

    CASE 
        WHEN explicit IN ('TRUE', 'true', '1') THEN 1
        ELSE 0
    END AS explicit,

    artist_name,
    artist_popularity,
    artist_followers,
    artist_genres,
    album_id,
    album_name,
    album_release_date,
    album_total_tracks,
    album_type,
    duration_min
FROM `spotify_data clean`;

SELECT DISTINCT explicit FROM `spotify_data clean`;

SELECT * 
FROM `spotify_cleaned`;



SELECT 
    SUM(track_id IS NULL) AS missing_track_id,
    SUM(track_name IS NULL) AS missing_track_name,
    SUM(artist_name IS NULL) AS missing_artist_name,
    SUM(artist_genres IS NULL) AS missing_genres
FROM `spotify_cleaned`;

DELETE t1 
FROM `spotify_cleaned` t1
JOIN `spotify_cleaned` t2
ON t1.track_id = t2.track_id
AND t1.artist_name = t2.artist_name
AND t1.album_id = t2.album_id
AND t1.id > t2.id;

UPDATE `spotify_cleaned`
SET artist_name = 'Unknown'
WHERE artist_name IS NULL OR artist_name = '';

SELECT * 
FROM `spotify_cleaned`;

UPDATE `spotify_cleaned`
SET artist_genres = 'Uncategorized'
WHERE artist_genres IS NULL OR artist_genres = '';

UPDATE `spotify_cleaned`
SET
    track_id = TRIM(track_id),
    track_name = TRIM(track_name),
    artist_name = TRIM(artist_name),
    artist_genres = TRIM(artist_genres),
    album_id = TRIM(album_id),
    album_name = TRIM(album_name),
    album_type = TRIM(album_type);
    
SELECT * 
FROM `spotify_cleaned`;

SELECT album_release_date
FROM `spotify_cleaned`
LIMIT 20;

UPDATE `spotify_cleaned`
SET track_popularity = 0
WHERE track_popularity < 0;

SELECT track_popularity
FROM `spotify_cleaned`;

UPDATE `spotify_cleaned`
SET artist_followers = 0
WHERE artist_followers < 0;

SELECT *
FROM `spotify_cleaned`;

UPDATE `spotify_cleaned`
SET track_duration_min = 0
WHERE track_duration_min < 0;

SELECT track_duration_min
FROM `spotify_cleaned`;

UPDATE `spotify_cleaned`
SET
    track_name = CONCAT(UCASE(LEFT(track_name,1)), LCASE(SUBSTRING(track_name,2))),
    artist_name = CONCAT(UCASE(LEFT(artist_name,1)), LCASE(SUBSTRING(artist_name,2))),
    album_name = CONCAT(UCASE(LEFT(album_name,1)), LCASE(SUBSTRING(album_name,2)));
    
SELECT *
FROM `spotify_cleaned`;