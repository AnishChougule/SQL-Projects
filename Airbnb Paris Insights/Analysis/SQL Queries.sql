USE airbnb_paris;
SHOW TABLES;
DESC listings;

ALTER TABLE listings
MODIFY accommodates SMALLINT,
MODIFY bathrooms SMALLINT,
MODIFY bedrooms SMALLINT,
MODIFY beds SMALLINT,
MODIFY number_of_reviews MEDIUMINT,
MODIFY listing_id BIGINT,
MODIFY price DOUBLE;

#1
SELECT listing_id,host_id,host_name, name, number_of_reviews, review_scores_rating
FROM listings
ORDER BY  number_of_reviews DESC , review_scores_rating DESC
LIMIT 10;

#2
SELECT room_type, 
	COUNT(room_type) AS count,
	AVG(price) AS average_price, 
	AVG(review_scores_rating) AS average_rating
FROM listings
GROUP BY room_type;

#3
SELECT *
FROM listings
WHERE room_type = 'Entire home/apt'
ORDER BY  number_of_reviews DESC , review_scores_rating DESC
LIMIT 20;


#4
SELECT host_id,host_name, COUNT(listing_id) AS total_listings
FROM listings
GROUP BY host_id, host_name
ORDER BY total_listings DESC;


#5
SELECT room_type, COUNT(*),
COUNT(CASE WHEN instant_bookable = 't' THEN 1 END) AS instant_booking,
COUNT(CASE WHEN instant_bookable = 'f' THEN 1 END) AS non_instant_booking
FROM listings
GROUP BY room_type;


#6
SELECT instant_bookable,AVG(price) AS avg_price, AVG(review_scores_rating) AS average_rating
FROM listings
GROUP BY instant_bookable;


#7
SELECT room_type,
AVG(price) AS category_avg,
(SELECT AVG(price) FROM listings) AS total_avg
FROM listings
GROUP BY room_type;


#8
SELECT host_id, MAX(price) - MIN(price) AS price_variance
FROM listings
GROUP BY host_id
ORDER BY price_variance DESC
LIMIT 5;


#9
SELECT bedrooms, AVG(price) AS average_price
FROM listings
GROUP BY bedrooms
ORDER BY bedrooms
LIMIT 5;


#10
SELECT host_response_time, COUNT(*) AS count
FROM listings
GROUP BY host_response_time;


#11
SELECT 
    COUNT(*) AS total_listings,
    COUNT(CASE WHEN instant_bookable = 't' THEN 1 END) AS instant_booking_listings,
    COUNT(CASE WHEN instant_bookable = 't' THEN 1 END) / COUNT(*) * 100 AS instant_booking_percentage
FROM listings;


#12
SELECT *
FROM listings
WHERE instant_bookable = 't' AND review_scores_rating >= 4.5
ORDER BY number_of_reviews DESC
LIMIT 20;


#13
SELECT *
FROM listings
WHERE price < 150 AND review_scores_rating >= 4.5
ORDER BY number_of_reviews DESC
LIMIT 20;


#14
SELECT *
FROM listings
WHERE accommodates = 2 AND beds >= 2
ORDER BY number_of_reviews DESC;


#15
SELECT *
FROM listings
ORDER BY price DESC
LIMIT 10;


#16
SELECT *
FROM listings
WHERE price != 0
ORDER BY price ASC
LIMIT 10;


#17
SELECT COUNT(*) AS positive_reviews, listings.host_id, listings.host_name, AVG(listings.price)
FROM reviews INNER JOIN listings ON listings.listing_id = reviews.listing_id
WHERE LOWER(reviews.comments) REGEXP '(great|perfect|trs bien|highly recommend|bien situ|fantastic)'
GROUP BY listings.host_id , listings.host_name
ORDER BY positive_reviews DESC
LIMIT 20;


#18
SELECT COUNT(*) AS negative_reviews, listings.host_id, listings.host_name, AVG(listings.price)
FROM reviews INNER JOIN listings ON listings.listing_id = reviews.listing_id
WHERE LOWER(reviews.comments) REGEXP '(dirty|bad|problem)'
GROUP BY listings.host_id , listings.host_name
ORDER BY negative_reviews DESC
LIMIT 20;


#19
SELECT COUNT(*) AS positive_reviews, reviews.listing_id, AVG(listings.price)
FROM reviews INNER JOIN listings ON listings.listing_id = reviews.listing_id
WHERE LOWER(reviews.comments) REGEXP '(great|perfect|trs bien|highly recommend|bien situ|fantastic)'
	AND listings.price < 120
GROUP BY reviews.listing_id
ORDER BY positive_reviews DESC
LIMIT 20;


#20
SELECT reviews.listing_id, AVG(listings.price),
    SUM(CASE WHEN LOWER(comments) REGEXP '(dirty|bad|problem)' THEN 1 ELSE 0 END) AS negative_reviews
FROM reviews INNER JOIN listings ON listings.listing_id = reviews.listing_id
WHERE listings.price < 120
GROUP BY reviews.listing_id
ORDER BY negative_reviews DESC
LIMIT 20;


#21
SELECT *
FROM listings
WHERE LOWER(amenities) REGEXP '(hot water|kitchen|wifi)' 
	AND review_scores_rating >= 4.5 
    AND price < 150
ORDER BY number_of_reviews DESC;


#22
SELECT COUNT(*) AS positive_reviews, reviews.listing_id
FROM reviews INNER JOIN listings ON listings.listing_id = reviews.listing_id
WHERE LOWER(amenities) LIKE '%wifi%'
        AND LOWER(amenities) LIKE '%hot water%'
        AND LOWER(reviews.comments) REGEXP '(great|perfect|trs bien|highly recommend|bien situ|fantastic)'
GROUP BY reviews.listing_id
ORDER BY positive_reviews DESC;


#23
SELECT listing_id, COUNT(*) AS total_reviews,
    SUM(CASE WHEN LOWER(comments) REGEXP '(great|perfect|trs bien|highly recommend|bien situ|fantastic)' THEN 1 ELSE 0 END) AS positive_reviews
FROM reviews
GROUP BY listing_id
ORDER BY total_reviews DESC;


#24
WITH FilteredReviews AS (
    SELECT listing_id
    FROM reviews
    WHERE LOWER(comments) REGEXP '(great|perfect|trs bien|highly recommend|bien situ|fantastic|incredible)'
)
SELECT *
FROM listings
WHERE room_type = 'Entire home/apt'
    AND price <= 150
    AND beds >= 2
    AND instant_bookable = 't'
    AND listing_id IN (SELECT listing_id FROM FilteredReviews)
ORDER BY number_of_reviews DESC
LIMIT 20;

SELECT listing_id, name FROM listings;
SELECT listing_id, description FROM listings;
SELECT listing_id, amenities FROM listings;
SELECT listing_id, comments FROM reviews;


