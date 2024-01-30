-- Query 1
/*How many users have joined Yelp each year since 2010?*/
SELECT EXTRACT(YEAR FROM date_time_user_join) AS joining_year, COUNT(user_id) AS "Number of users"
FROM users 
WHERE EXTRACT(YEAR FROM date_time_user_join) >= 2010
GROUP BY joining_year 
ORDER BY joining_year;

-- Query 2
/*How many users were elite in each of the 10 years from 2012 through 2021? 
Does it look like the number of elite users is increasing, decreasing, or staying about the same?*/
SELECT year,COUNT(user_id) AS "Number of eliteusers"
FROM usereliteyears 
WHERE year BETWEEN 2012 AND 2021
GROUP BY year;

-- Query 3
/*Which of our users has the most 5-star reviews of all time?
Give us the person’s name, when they joined Yelp, how many fans they have, how many funny, useful, and cool ratings they’ve gotten.
Please also gives us 3-5 examples of recent 5-star reviews they have written.*/
SELECT sq1.name, sq1.date_time_user_join, sq1.fans, sq1.users_funny_review, sq1.users_useful_review, sq1.users_cool_review, r2.review_date, r2.review_text
FROM
(SELECT u.user_id, u.name, u.date_time_user_join, u.fans, SUM(r.users_funny_review) AS users_funny_review, SUM(r.users_useful_review) AS users_useful_review, SUM(r.users_cool_review) AS users_cool_review, count(review_id) as FiveStarReviewsCount
FROM reviews r
JOIN users u ON u.user_id=r.user_id
WHERE r.users_rating = 5.0
GROUP BY u.user_id
ORDER BY FiveStarReviewsCount DESC LIMIT 1) AS sq1
JOIN reviews r2 ON sq1.user_id = r2.user_id
ORDER BY r2.review_date DESC LIMIT 5

-- Query 4
/*We’d like to talk with users who have lots of friends on Yelp to better understand how they use the social features of our site. 
Can you give us user id and name of the 10 users with the most friends?*/
SELECT userfriends.user_id, users.name, COUNT(userfriends.user_id) AS number_of_friends 
FROM userfriends, users 
WHERE userfriends.user_id=users.user_id
GROUP BY userfriends.user_id, users.name
ORDER BY number_of_friends DESC LIMIT 10;

-- With Join
SELECT uf.user_id, u.name, COUNT(uf.user_id) AS "Number of friends" 
FROM userfriends uf
JOIN users u ON u.user_id = uf.user_id
GROUP BY uf.user_id, u.name
ORDER BY "Number of friends" DESC LIMIT 10;

-- Query 5
/*Which US states have the most businesses in our database? 
Give us the top 10 states.*/
SELECT state, COUNT(state) AS "Number of business" 
FROM businesses
GROUP BY state
ORDER BY "Number of business" DESC LIMIT 10;

-- Query 6
/*What are our top ten business categories? 
In other words, which 10 categories have the most businesses assigned to them?*/
SELECT category_name , COUNT(category_name) AS "Number of business" 
FROM businesses,businesscategories
WHERE businesses.business_id = businesscategories.business_id
GROUP BY category_name
ORDER BY "Number of business" DESC LIMIT 10;

-- With Join
SELECT bc.category_name , COUNT(bc.category_name) AS "Number of business" 
FROM businesses b 
JOIN businesscategories bc ON bc.business_id = b.business_id
GROUP BY bc.category_name
ORDER BY "Number of business" DESC LIMIT 10;

-- Query 7
/*What is the average rating of the businesses in each of those top ten categories?*/
SELECT bc.category_name , COUNT(category_name) AS "Number of business", ROUND(AVG(b.average_reviews_stars),1) AS "Average rating by category"
FROM businesses b
JOIN businesscategories bc ON b.business_id = bc.business_id 
GROUP BY category_name
ORDER BY "Number of business" DESC LIMIT 10;

-- Query 8
/*We’re wondering what makes users tag a Restaurant review as “funny”.
Can you give us 5 examples of the funniest Restaurant reviews and 5 examples of the 10 least funny? 
We’d also like you to look at a larger set of funny and unfunny reviews and tell us if you see any patterns that separate the two. 
(We know the last part is qualitative, but tell us anything you see that may be useful.)*/
SELECT * FROM (SELECT reviews.users_funny_review, reviews.review_text 
FROM reviews 
JOIN businesscategories ON businesscategories.business_id = reviews.business_id
WHERE category_name = 'Restaurants'
GROUP BY reviews.users_funny_review,reviews.review_text
ORDER BY reviews.users_funny_review DESC LIMIT 5) top_five
UNION
SELECT * FROM (SELECT reviews.users_funny_review, reviews.review_text 
FROM reviews 
JOIN businesscategories ON businesscategories.business_id = reviews.business_id
WHERE category_name = 'Restaurants'
GROUP BY reviews.users_funny_review,reviews.review_text
ORDER BY reviews.users_funny_review ASC LIMIT 10) bottom_ten
ORDER BY users_funny_review DESC;

-- QUERY for 8B. We’d also like you to look at a larger set of funny and unfunny reviews and tell us if you see any patterns that separate the two. 
SELECT users_funny_review, COUNT(users_funny_review) FROM reviews
GROUP BY users_funny_review
ORDER BY users_funny_review desc;
-- Pattern Analysis: Using the above query we observed that the number of funny votes gradually increased for reviews(except the top 10 reviews in the result). For the top 10 reviews the number of funny votes suddenly increased by many folds.
-- Using the above query we observed that around 99.73% of total reviews received least funny votes (less than 10 votes) the number of reviews receiving the funny votes decreases
-- Pattern Analysis: Using the above query we observed that there are only 2 reviews that have received the most funny votes (more than 250) whereas 498698 reviews (99.73 % out of total reviews) have received the least funny votes (less than 10)


-- Query 9
/*We think the compliments that tips receive are mostly based on how long the tip text is. 
Can you compare the average length of the tip text for the 100 most-complimented tips with the average length of the 100 least-complimented tips 
and tell us if that seems to be true? (Hint: you will need to use computed properties to answer this question).*/

-- ANSWER: No, it's not true. Based on the query results, the average text length of 100 most complimented tips is 146.9, whereas for least 100 is 50. The overall difference is not significant.

SELECT average_length_of_100_most_complimented_tips, average_length_of_100_least_complimented_tips FROM
(SELECT ROUND(AVG(length_of_tip_text),2) AS average_length_of_100_most_complimented_tips FROM
(SELECT text, tip_received, LENGTH(text) AS length_of_tip_text
from tips
ORDER BY tip_received DESC LIMIT 100)AS sq1) AS SQ3,	
(SELECT ROUND(AVG(length_of_tip_text)) AS average_length_of_100_least_complimented_tips FROM
(SELECT text, tip_received, LENGTH(text) AS length_of_tip_text
FROM tips
ORDER BY tip_received LIMIT 100)AS sq2) AS SQ4;

-- Query 10
/*We are trying to figure out whether restaurant reviews are driven mostly by
how many hours the restaurant is open, or the days they are open. 
Can you please give us a spreadsheet with the data we need to answer that question? 
(Note: You don’t actually have to hand in a spreadsheet…just give me a table with 10 rows of sample data returned by your query.)*/
SELECT sq1.business_id,business_name,average_reviews_stars,number_of_reviews,restaurant_opening_hours,restaurant_working_days
FROM (SELECT business_id,business_name,average_reviews_stars,number_of_reviews FROM businesses) AS sq1,
(SELECT business_id, SUM(closing_time-opening_time)AS restaurant_opening_hours,COUNT(day_of_week)AS restaurant_working_days FROM businesshours
GROUP BY businesshours.business_id)as sq2,
(SELECT business_id,category_name FROM businesscategories WHERE category_name = 'Restaurants') AS sq3
WHERE 
sq1.business_id = sq2.business_id
AND sq1.business_id = sq3.business_id
LIMIT 10;


-- EXTRA CREDIT QUERIES
 
-- 1.Mention 5 US states where yelp business is need to improve and the total reviews they received.
SELECT state, COUNT(state) AS "Number of businesses", SUM(number_of_reviews) AS "Total reviews" FROM businesses
GROUP BY state
ORDER BY "Number of businesses" ASC LIMIT 5;

-- 2. Provide how many reviews are each year since year 2000
SELECT EXTRACT (YEAR FROM review_date) AS "Date of review", COUNT(user_id) AS "Number of reviews"
FROM reviews 
WHERE EXTRACT (YEAR FROM review_date)>=2000
GROUP BY "Date of review" 
ORDER BY "Date of review";

-- 3. Is a business review affected by the fact they are opened on weekends (saturday and sunday)
SELECT b.business_id,b.business_name,b.average_reviews_stars,b.number_of_reviews,COUNT(bh.day_of_week)AS "Working weekend days"
FROM businesses b
JOIN businesshours bh ON b.business_id = bh.business_id
WHERE day_of_week IN('Saturday','Sunday')
GROUP BY b.business_id
ORDER BY b.number_of_reviews DESC;

-- 4. List of users that are elite for 10 or more years
SELECT * FROM
(SELECT uey.user_id, u.name, COUNT(uey.year) AS elite_years 
FROM usereliteyears uey
JOIN users u
ON uey.user_id=u.user_id
GROUP BY uey.user_id, u.name
ORDER BY elite_years DESC) AS SQ1
WHERE elite_years >= 10

-- 5. Are there any doctors that provide walkins on Monday, provide the list please.

SELECT b.business_id,b.business_name
FROM businesscategories bc
JOIN businessattributes ba ON bc.business_id = ba.business_id
JOIN businesses b ON b.business_id = ba.business_id
JOIN businesshours bh ON bh.business_id = b.business_id
WHERE category_name = 'Doctors' AND attribute_name = 'byappointmentonly' AND attribute_value = 'False' AND bh.day_of_week='Monday';

-- 6. Can you list down top 20 users with max friend's
SELECT u.user_id,u.name,COUNT(uf.friend_id) AS no_of_friends
FROM userfriends uf
JOIN
users u ON u.user_id = uf.user_id
GROUP BY u.user_id
ORDER BY no_of_friends DESC
LIMIT 20;

-- 7. Is there a relation between number of friends and hot,cool and funny compliments received
-- answer no relation

SELECT u.user_id,COUNT(uf.friend_id)AS "Number of friends", user_receieved_hot_compliment + user_receieved_cool_compliment + user_receieved_funny_compliment AS "Hot, cool and funny compliments"
FROM users u 
JOIN userfriends uf
ON uf.user_id = u.user_id
GROUP BY u.user_id
ORDER BY "Number of friends" DESC;

-- 8. List the number of reviews by each business category
SELECT bc.category_name, sum(b.number_of_reviews)
FROM businesses b
JOIN businesscategories bc
ON b.business_id = bc.business_id
GROUP BY bc.category_name
ORDER BY bc.category_name

-- 9. We would like to contact customers who were disappointed with the experience they had at business and mentioned about waiters in their tips.
-- We would also like to see their contributions to yelp community.*/
SELECT t.user_id, u.name, u.reviews_user_left, u.user_useful_votes, u.user_funny_votes, u.user_cool_votes, t.text FROM tips t
JOIN users u
ON t.user_id = u.user_id
WHERE t.text LIKE '%disappoint%'
AND t.text LIKE '%waiter%'
ORDER BY u.reviews_user_left DESC
