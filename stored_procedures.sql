SET SQL_SAFE_UPDATES = 0

####User table######

#Create User
DELIMITER $$
 
CREATE PROCEDURE CreateUser(
	IN in_email VARCHAR(30),
    IN in_pass VARCHAR(30),
    IN f_name VARCHAR(30),
    IN l_name VARCHAR(30)    
)
BEGIN
	IF NOT EXISTS ( SELECT u.* FROM `USER` u WHERE u.email = in_email ) THEN
		INSERT INTO `USER` (email, first_name, last_name, pass, isAdmin) VALUES (in_email, f_name, l_name, in_pass, FALSE);
	ELSE CALL raise_error;
	END IF;
END$$

DELIMITER ;

#Delete User
DELIMITER $$
 
CREATE PROCEDURE DeleteUser(
	IN in_email VARCHAR(30),
    IN in_pass VARCHAR(30)  
)
BEGIN
	DELETE FROM `USER` u WHERE u.email = in_email AND u.pass = in_pass;
END$$

DELIMITER ;

#get all users's emails , first/last names
DELIMITER $$

CREATE PROCEDURE GetUsers()
BEGIN
    SELECT email, first_name, last_name FROM `USER` ORDER BY email;    
END$$

DELIMITER ;

#get all admins
DELIMITER $$
 
CREATE PROCEDURE GetAdmins()
BEGIN
    SELECT email, first_name, last_name FROM `USER` 
    WHERE isAdmin = TRUE
    ORDER BY email;    
END$$

DELIMITER ;

#check if user is admin
DELIMITER $$

CREATE PROCEDURE GetAdmin(
	IN in_email VARCHAR(30)
)
BEGIN
	IF NOT EXISTS (SELECT u.* FROM `USER` u WHERE u.email = in_email) THEN
		CALL raise_error;					
	END IF;
END$$

DELIMITER ;

#get user by email
DELIMITER $$
 
CREATE PROCEDURE GetUser(
	IN email VARCHAR(30)
)
BEGIN
    SELECT u.email, u.first_name, u.last_name 
    FROM `USER` u
    WHERE u.email = email ;  
END$$

DELIMITER ;

#check if password is correct given email
DELIMITER $$

CREATE PROCEDURE CheckPassword(
	IN email VARCHAR(30),
    IN pass VARCHAR(30)
)
BEGIN
	IF NOT EXISTS (SELECT u.* FROM `USER` u WHERE u.email LIKE BINARY email AND u.pass LIKE BINARY pass ) THEN
		CALL raise_error;					
	END IF;
END$$

DELIMITER ;

#make/remove user as admin
DELIMITER $$
 
CREATE PROCEDURE SetUserAdmin(
	IN in_email VARCHAR(30),
    IN val bool
)
BEGIN
	IF EXISTS (
		SELECT u.* FROM `USER` u WHERE u.email = in_email ) THEN
			UPDATE `USER` SET isAdmin = val WHERE email = in_email;
	END IF;
END$$

DELIMITER ;

###############################################
####Area table######

#create area
DELIMITER $$

CREATE PROCEDURE CreateArea(
	IN in_country VARCHAR(20),
    IN in_city VARCHAR(20)
)
BEGIN
	IF NOT EXISTS (SELECT a.* FROM `AREA`  a WHERE (a.country_name) LIKE BINARY  (in_country) AND (a.city_name) LIKE BINARY (in_city) ) THEN
		INSERT INTO `AREA` (country_name, city_name) VALUES (in_country, in_city);
	ELSE CALL raise_error;
    END IF;
END$$

DELIMITER ;


#delete area
DELIMITER $$
 
CREATE PROCEDURE DeleteArea(
	IN in_country VARCHAR(20),
    IN in_city VARCHAR(20)
)
BEGIN
	IF EXISTS (SELECT a.* FROM `AREA`  a WHERE (a.country_name) LIKE BINARY  (in_country) AND (a.city_name) LIKE BINARY (in_city) ) THEN
		DELETE FROM `AREA` a WHERE a.country_name = in_country AND a.city_name = in_city;
	ELSE CALL raise_error;
	END IF;
END$$

DELIMITER ;

#get all areas
DELIMITER $$
 
CREATE PROCEDURE GetAreas()
BEGIN
	SELECT * FROM `AREA`;
END$$

DELIMITER ;


#get all countries
DELIMITER $$
 
CREATE PROCEDURE GetCountries()
BEGIN
	SELECT c.country_name FROM `AREA` c;
END$$

DELIMITER ;

#get all cities
DELIMITER $$
 
CREATE PROCEDURE GetCities()
BEGIN
	SELECT c.city_name FROM `AREA` c;
END$$

DELIMITER ;

#get all cities with a country
DELIMITER $$
 
CREATE PROCEDURE GetCitiesWithinCountry(IN in_country VARCHAR(30))
BEGIN
	SELECT c.city_name FROM `AREA` c 
    WHERE c.country_name = in_country;
END$$

DELIMITER ;

#get AreaID from country_name & city_name
DELIMITER $$

CREATE PROCEDURE GetAreaID(
	IN country VARCHAR(30),
    IN city VARCHAR(30),
    OUT ID	INT
)
BEGIN
	IF EXISTS (
		SELECT a.area_id FROM `AREA` a WHERE a.country_name = country AND a.city_name = city  ) THEN
			(SELECT a.area_id INTO ID FROM `AREA` a WHERE a.country_name = country AND a.city_name = city);
	END IF;
END$$

DELIMITER ;

###############################################
####Location table######

#create location
#requires area(country, city) from table Area
#requires name, budget from table location
#requires coordinates from table coordinate
DELIMITER $$
#DROP PROCEDURE CREATElocation;
CREATE PROCEDURE CreateLocation(
	IN in_country VARCHAR(30),
    IN in_city	VARCHAR(30),
    IN in_name	VARCHAR(30),
    IN in_budget DOUBLE,
    IN lat	DOUBLE,
    IN lon	DOUBLE
)
BEGIN
	IF EXISTS ( SELECT * FROM `AREA` a WHERE a.country_name = in_country AND a.city_name = in_city) THEN #if area exists		
		IF NOT EXISTS ( SELECT * FROM `LOCATION` l WHERE l.area_id = @id AND l.location_name = in_name) THEN #if location not exists
			SELECT @id:=area_id FROM `AREA` a WHERE a.country_name = in_country AND a.city_name = in_city;
			INSERT INTO `LOCATION` (location_name, budget, area_id) VALUES (in_name, in_budget,  @id);
			SELECT LAST_INSERT_ID();
			INSERT INTO `COORDINATE` (latitude, longitude, loc_id)  VALUES (lat, lon, LAST_INSERT_ID() );
            
		ELSE CALL raise_error;
		END IF;        
    END IF;
END$$

DELIMITER ;

/*CALL CreateLocation(
	'egypt','alex', 'azaza', 10.00, 12.3, 31.2
);*/

#Get Location
DELIMITER $$

CREATE PROCEDURE getLocation(
	IN in_country VARCHAR(30),
    IN in_city	VARCHAR(30),
    IN in_name	VARCHAR(30),
    IN lat	DOUBLE,
    IN lon	DOUBLE
)
BEGIN
	SELECT l.loc_id, l.location_name, area.country_name, area.city_name, l.budget
    FROM `LOCATION` l
	INNER JOIN `AREA` area ON l.area_id = area.area_id
    INNER JOIN `COORDINATE` c ON l.loc_id = c.loc_id
    WHERE area.country_name = in_country 
    AND area.city_name = in_city
    AND c.latitude = lat
    AND c.longitude = lon;
 
END$$

DELIMITER ;


#DELETE LOCATION
DELIMITER $$

CREATE PROCEDURE DeleteLocation(
	IN in_country VARCHAR(30),
    IN in_city	VARCHAR(30),
    IN in_name	VARCHAR(30),
    IN lat	DOUBLE,
    IN lon	DOUBLE
)
BEGIN
	DELETE l FROM `LOCATION` l 
    INNER JOIN `AREA` area ON l.area_id = area.area_id
    INNER JOIN `COORDINATE` c ON l.loc_id = c.loc_id
    WHERE area.country_name = in_country 
    AND area.city_name = in_city
    AND c.latitude = lat
    AND c.longitude = lon;
END$$

DELIMITER ;


#get all locations
DELIMITER $$

CREATE PROCEDURE GetLocations()
BEGIN
	SELECT a.location_name, a.budget, area.country_name, area.city_name 
    FROM `LOCATION` a 
    INNER JOIN `AREA` area ON a.area_id = area.area_id;
END$$

DELIMITER ;

#get all locations within city
DELIMITER $$

CREATE PROCEDURE GetLocationsWithinCity( IN city VARCHAR(20))
BEGIN
	SELECT a.location_name, a.budget, area.country_name, area.city_name 
    FROM `LOCATION` a 
    INNER JOIN `AREA` area ON a.area_id = area.area_id AND area.city_name = city;
END$$

DELIMITER ;

#get all locations within country
DELIMITER $$

CREATE PROCEDURE GetLocationsWithinCountry( IN country VARCHAR(20))
BEGIN
	SELECT a.location_name, a.budget, area.country_name, area.city_name 
    FROM `LOCATION` a 
    INNER JOIN `AREA` area ON a.area_id = area.area_id AND area.country_name = country;
END$$

DELIMITER ;

#get all locations with less than or equal to budget
DELIMITER $$

CREATE PROCEDURE GetLocationsWithBudget( IN budg DOUBLE)
BEGIN
	SELECT a.location_name, a.budget FROM `LOCATION` a 
    WHERE a.budget <= budg;
END$$

DELIMITER ;

#Get location

#Get locations with budget inside city & country
DELIMITER $$

CREATE PROCEDURE GetLocationsWithBudgetInArea(IN in_country varchar(30), IN in_city varchar(30), IN budg DOUBLE)
BEGIN
IF EXISTS(
	SELECT * FROM `COORDINATE` coord
    INNER JOIN `AREA` ar on ar.country_name = in_country AND ar.city_name = in_city
    INNER JOIN `LOCATION` loc on loc.loc_id = coord.loc_id
    WHERE ar.area_id = loc.area_id 
    AND loc.budget <= budg ) THEN
		SELECT loc.location_name, coord.latitude, coord.longitude FROM `COORDINATE` coord
    INNER JOIN `AREA` ar on ar.country_name = in_country AND ar.city_name = in_city
    INNER JOIN `LOCATION` loc on loc.loc_id = coord.loc_id
    WHERE ar.area_id = loc.area_id 
    AND loc.budget <= budg ;
    ELSE CALL raise_error;
    END IF;

END$$

DELIMITER ;
#update location budget
#update location name


###############################################
####Route table######
####leave for now

###############################################
####Coordinate table######

#Get coordinate of location
DELIMITER $$

CREATE PROCEDURE GetLocationCoordinates( 
	IN country VARCHAR(30),
    IN city VARCHAR(30),
    IN loc_name VARCHAR(30)
)
BEGIN
	SELECT c.latitude, c.longitude FROM `COORDINATE` c 
    INNER JOIN `AREA` area 
    ON	area.country_name = country AND area.city_name = city
    INNER JOIN `LOCATION` l
    ON	l.location_name = loc_name
    WHERE c.loc_id = l.loc_id
    ;    
END$$

DELIMITER ;

###############################################
####FAV_LOCATION table######

#insert new fav. location for a user
DELIMITER $$
#DROP PROCEDURE addUserFavLocations;
CREATE PROCEDURE addUserFavLocations( 
	IN in_email VARCHAR(30),
    IN in_loc_id INT
)
BEGIN
	IF NOT EXISTS ( SELECT * FROM `FAV_LOCATION` l WHERE l.loc_id = in_loc_id AND l.email = in_email) THEN 
		INSERT INTO `FAV_LOCATION` (email, loc_id) VALUES (in_email, in_loc_id);    
	ELSE CALL raise_error;
    END IF;
END$$

DELIMITER ;

#delete a user's fav. location
DELIMITER $$
CREATE PROCEDURE deleteUserFavLocations( 
	IN in_email VARCHAR(30),
    IN in_loc_id INT
)
BEGIN
	DELETE FROM `FAV_LOCATION` f WHERE  f.email = in_email AND f.loc_id = in_loc_id;    
END$$

DELIMITER ;

#get user's fav. locations
DELIMITER $$

CREATE PROCEDURE GetUserFavLocations( 
	IN in_email VARCHAR(30)    
)
BEGIN
	SELECT a.location_name, a.budget, area.country_name, area.city_name 
    FROM `LOCATION` a 
    INNER JOIN `AREA` area ON a.area_id = area.area_id
    INNER JOIN `FAV_LOCATION` f ON f.loc_id = a.loc_id AND f.email = in_email
    ;
END$$

DELIMITER ;
