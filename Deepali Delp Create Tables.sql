/* Delp database */

/* table 1*/
CREATE TABLE businesses
(
    business_id VARCHAR(22) PRIMARY KEY,
    business_name VARCHAR(100),
    street_address VARCHAR(150),
    city VARCHAR(100),
    state VARCHAR(3),
    postal_code VARCHAR(9),
    latitude DOUBLE PRECISION,
    longitude DOUBLE PRECISION,
    average_reviews_stars NUMERIC(2,1),
    number_of_reviews SMALLINT,
    is_business_open BOOLEAN
);

/* table 2*/
CREATE TABLE businesscategories 
(
    business_id VARCHAR(22) REFERENCES businesses(business_id),
	category_name VARCHAR(50)
);

/* table 3*/
CREATE TABLE businessattributes 
(
    business_id VARCHAR(22) REFERENCES businesses(business_id),
	attribute_name VARCHAR(50),
	attribute_value VARCHAR(20)
);

/* table 4*/
CREATE TABLE businesshours 
(
	business_id VARCHAR(22) REFERENCES businesses(business_id),
	day_of_week VARCHAR(22),
	opening_time TIME,
	closing_time TIME
);

/* table 5*/
CREATE TABLE users
(
    user_id VARCHAR(22) PRIMARY KEY,
    name VARCHAR(100),
    reviews_user_left SMALLINT,
    date_time_user_join TIMESTAMP,
    user_useful_votes INTEGER,
    user_funny_votes INTEGER,
    user_cool_votes INTEGER,
    fans SMALLINT,
    user_average_rating_reviews NUMERIC(3,2),
	user_receieved_hot_compliment SMALLINT,
    user_receieved_more_compliment SMALLINT,
    user_receieved_profile_compliment SMALLINT,
    user_receieved_cute_compliment SMALLINT,
    user_receieved_list_compliment SMALLINT,
    user_receieved_note_compliment INTEGER,
    user_receieved_plain_compliment INTEGER,
    user_receieved_cool_compliment INTEGER,
    user_receieved_funny_compliment INTEGER,
    user_receieved_writer_compliment SMALLINT,
    user_receieved_photo_compliment INTEGER
);

/* table 6*/
CREATE TABLE userfriends
(
    user_id VARCHAR(22),
    friend_id VARCHAR(22)
);

/* table 7*/
CREATE TABLE usereliteyears
(
    user_id VARCHAR(22)REFERENCES users(user_id),
    year INTEGER
);

/* table 8*/
CREATE TABLE reviews
(
    review_id VARCHAR(22) PRIMARY KEY,
    user_id VARCHAR(22) REFERENCES users(user_id),
    business_id VARCHAR(22) REFERENCES businesses(business_id),
    users_rating NUMERIC(2,1),
    users_useful_review SMALLINT,
    users_funny_review SMALLINT,
    users_cool_review SMALLINT,
    review_text VARCHAR(5000),
    review_date DATE
);

/* table 9*/
CREATE TABLE tips
(
    user_id VARCHAR(22) REFERENCES users(user_id),
    business_id VARCHAR(22) REFERENCES businesses(business_id),
    text VARCHAR(500),
    date_time_tip_left TIMESTAMP,
    tip_received SMALLINT
);