
####DROP DATABASE fasahny;
CREATE DATABASE fasahny;

use fasahny;
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'joe123';

CREATE TABLE `USER` (
	email VARCHAR(50) PRIMARY KEY NOT NULL,
    first_name VARCHAR(30) NOT NULL,
	last_name VARCHAR(30) NOT NULL,
    pass	 VARCHAR(30) NOT NULL,
    isAdmin BOOL DEFAULT(FALSE)
);

CREATE TABLE `AREA`(
	area_id INT auto_increment PRIMARY KEY,
    country_name VARCHAR(30) NOT NULL,
	city_name VARCHAR(30) NOT NULL
);

CREATE TABLE `LOCATION`(
	loc_id INT auto_increment PRIMARY KEY,
    location_name VARCHAR(30) DEFAULT ('undefined'),
    budget DOUBLE DEFAULT(0.00),
    area_id INT NOT NULL,
    FOREIGN KEY (area_id) REFERENCES AREA(area_id) ON DELETE CASCADE
);

CREATE TABLE `ROUTE`(
	route_id INT NOT NULL,
    loc_id INT ,
    FOREIGN KEY (loc_id) REFERENCES LOCATION(loc_id) ON DELETE SET NULL
);

CREATE TABLE `COORDINATE`(
	latitude DOUBLE  NOT NULL, 
    longitude DOUBLE NOT NULL, 
    loc_id INT NOT NULL,
    FOREIGN KEY (loc_id) REFERENCES LOCATION(loc_id) ON DELETE CASCADE
);

CREATE TABLE `FAV_ROUTE`(
	email VARCHAR(50),
    route_id INT,
    FOREIGN KEY (email) REFERENCES `USER`(email) ON DELETE CASCADE
);

CREATE TABLE `FAV_LOCATION`(
	email VARCHAR(50),
    loc_id INT,
    FOREIGN KEY (email) REFERENCES `USER`(email) ON DELETE CASCADE,
    FOREIGN KEY (loc_id) REFERENCES `LOCATION`(loc_id) ON DELETE CASCADE
);

