-- DOWN --

-- Drop Procedures

drop procedure if exists p_upsert_team

-- Drop Triggers

drop trigger if exists t_update_price

-- Drop Views

drop view if exists dome_events
drop view if exists student_athletes

-- Drop constraints

if exists (select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    where CONSTRAINT_NAME = 'fk_tickets_ticket_game_id')
        alter table tickets drop constraint fk_tickets_ticket_game_id

if exists (select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    where CONSTRAINT_NAME = 'fk_teams_team_manager')
        alter table teams drop constraint fk_teams_team_manager

if exists (select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    where CONSTRAINT_NAME = 'fk_teams_team_sport')
        alter table teams drop constraint fk_teams_team_sport

if exists (select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    where CONSTRAINT_NAME = 'fk_staff_staff_staff_id')
        alter table staff drop constraint fk_staff_staff_staff_id

if exists (select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    where CONSTRAINT_NAME = 'fk_staff_staff_role')
        alter table staff drop constraint fk_staff_staff_role

if exists (select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    where CONSTRAINT_NAME = 'fk_staff_staff_game_id')
        alter table staff drop constraint fk_staff_staff_game_id

if exists (select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    where CONSTRAINT_NAME = 'fk_staff_staff_sport_id')
        alter table staff drop constraint fk_staff_staff_sport_id

if exists (select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    where CONSTRAINT_NAME = 'fk_stadiums_stadium_state')
        alter table stadiums drop constraint fk_stadiums_stadium_state

if exists (select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    where CONSTRAINT_NAME = 'fk_players_player_school_year')
        alter table players drop constraint fk_players_player_school_year

if exists (select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    where CONSTRAINT_NAME = 'fk_players_player_game_id')
        alter table players drop constraint fk_players_player_game_id

if exists (select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    where CONSTRAINT_NAME = 'fk_players_player_sport_id')
        alter table players drop constraint fk_players_player_sport_id

if exists (select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    where CONSTRAINT_NAME = 'fk_players_player_id')
        alter table players drop constraint fk_players_player_id

if exists (select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    where CONSTRAINT_NAME = 'fk_persons_person_role')
        alter table persons drop constraint fk_persons_person_role

if exists (select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    where CONSTRAINT_NAME = 'fk_merchandise_merch_game_type')
        alter table merchandise drop constraint fk_merchandise_merch_game_type

if exists (select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    where CONSTRAINT_NAME = 'fk_merchandise_merch_stadium_id')
        alter table merchandise drop constraint fk_merchandise_merch_stadium_id

if exists (select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    where CONSTRAINT_NAME = 'fk_games_game_away_team')
        alter table games drop constraint fk_games_game_away_team

if exists (select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    where CONSTRAINT_NAME = 'fk_games_game_home_team')
        alter table games drop constraint fk_games_game_home_team

if exists (select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    where CONSTRAINT_NAME = 'fk_games_game_location')
        alter table games drop constraint fk_games_game_location

if exists (select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    where CONSTRAINT_NAME = 'fk_food_food_stadium_id')
        alter table food drop constraint fk_food_food_stadium_id

-- Drop tables

drop table if exists state_lookup
drop table if exists school_year_lookup

drop table if exists tickets
drop table if exists teams
drop table if exists staff
drop table if exists stadiums
drop table if exists sports
drop table if exists roles
drop table if exists players
drop table if exists persons
drop table if exists merchandise
drop table if exists games
drop table if exists food

-- Drop Databse
drop database if exists sports_center

use master

-- UP METADATA --

-- Database
create database sports_center
GO
use sports_center

--Primary tables 

create table food(
    food_id int not null,
    food_name varchar(50) not null,
    food_quantity int not null,
    food_price money not null,
    food_stand_num int not null,
    food_stadium_id varchar(10) not null,
    constraint pk_food_stadium_food_id primary key (food_id, food_stand_num, food_stadium_id),
    constraint u_food_stadium_food_name unique (food_name, food_stand_num, food_stadium_id),
    constraint ck_valid_food_quantity check (food_quantity > 0),
    constraint ck_valid_food_price check (food_price > 0)
)

create table games (
    game_id int identity not null,
    game_name varchar(100) not null,
    game_date date not null,
    game_time time not null,
    game_location varchar(10) not null,
    game_type varchar(5) not null,
	game_sport varchar(30) not null,
    game_home_team char(3) not null,
    game_away_team char(3) not null,
    constraint pk_games_game_id primary key (game_id),
    constraint ck_valid_game_date check (game_date > GETDATE())
)

create table merchandise (
    merch_id int identity not null,
    merch_stadium_id varchar(10) not null,
    merch_name varchar(50) not null,
    merch_type varchar(30) not null,
    merch_game_type varchar(30) not null,
    merch_quantity int not null,
    merch_price money not null,
    constraint pk_merchandise_merch_id primary key (merch_id),
    constraint u_merchandise_merch_name unique (merch_name),
    constraint ck_valid_merch_quantity check (merch_quantity > 0),
    constraint ck_valid_merch_price check (merch_price > 0)
)

create table persons (
    person_id int identity not null,
    person_first_name varchar(50) not null,
    person_last_name varchar(50) not null,
    person_email varchar(50) not null,
    person_phone_num varchar(30) not null,
    person_role int null,
    constraint pk_persons_person_id primary key (person_id),
    constraint u_persons_person_email unique (person_email),
    constraint ck_valid_email check (person_email like '%@%.%'),
    constraint ck_valid_phone_num check (DATALENGTH(person_phone_num) >= 10)
)

create table players (
    player_id int not null,
    player_sport_id int not null,
    player_game_id int null,
    player_school_year char(3) not null
)

create table roles (
    role_id int identity not null,
    role_name varchar(50) not null,
    role_salary money null,
    role_salary_type varchar(20) null,
    constraint pk_roles_role_id primary key (role_id),
    constraint ck_valid_salary check (role_salary > 0)
)

create table sports (
    sport_id int identity not null,
    sport_name varchar(30) not null,
    sport_num_players int null,
    sport_type varchar(10) null,
    constraint pk_sports_sport_id primary key (sport_id),
    constraint u_sports_sport_name unique (sport_name),
    constraint ck_valid_players check (sport_num_players > 0)
)

create table stadiums (
    stadium_id varchar(10) not null,
    stadium_name varchar(50) not null,
    stadium_address_line_one varchar(50) not null,
    stadium_address_line_two varchar(50) null,
    stadium_city varchar(30) not null,
    stadium_state char(2) not null,
    stadium_zipcode varchar(10) not null,
    stadium_capacity int null,
    stadium_home_team char(3) not null,
    stadium_num_food_stand int null,
    constraint pk_stadiums_stadium_id primary key (stadium_id),
    constraint ck_valid_zipcode check (DATALENGTH(stadium_zipcode) >= 5),
    constraint ck_valid_stands check (stadium_num_food_stand > 0) 
)

create table staff (
    staff_id int not null,
    staff_role int not null,
    staff_game_id int null,
    staff_sport_id int null,
    staff_experience int null,
    constraint ck_valid_years_of_experience check (staff_experience >= 0)
)

create table teams (
    team_short_name char(3) not null,
    team_name varchar(50) not null,
    team_sport int not null,
    team_num_players int not null,
    team_num_support_staff int null,
    team_manager int null,
    constraint pk_teams_team_short_name primary key (team_short_name),
    constraint ck_valid_num_team_players check (team_num_players > 0),
    constraint ck_valid_support_staff check (team_num_support_staff > 0)
)

create table tickets (
    ticket_serial_num varchar(10) not null,
    ticket_game_id int not null,
    ticket_type varchar(50) null,
    ticket_seat_num varchar(10) not null,
    ticket_price money not null,
    constraint pk_ticket_serial_num primary key (ticket_serial_num),
    constraint ck_valid_price check (ticket_price > 0)
)

-- Lookup tables

create table school_year_lookup (
    school_year_code char(3) not null,
    school_year_name varchar(10) not null,
    constraint pk_school_year_lookup_school_year_code primary key (school_year_code),
    constraint ck_year_code_length check (DATALENGTH(school_year_code) = 3)
)

create table state_lookup (
    state_name varchar(20) not null,
    state_code char(2) not null,
    constraint pk_state_lookup_state_code primary key (state_code),
    constraint ck_state_code_length check (DATALENGTH(state_code) = 2)
)

-- Foreign key constraints

alter table food
    add constraint fk_food_food_stadium_id foreign key (food_stadium_id)
        references stadiums(stadium_id)

alter table games
    add constraint fk_games_game_location foreign key (game_location)
        references stadiums(stadium_id)

alter table games
    add constraint fk_games_game_sport foreign key (game_sport)
        references sports(sport_name)

alter table games
    add constraint fk_games_game_home_team foreign key (game_home_team)
        references teams(team_short_name)

alter table games
    add constraint fk_games_game_away_team foreign key (game_away_team)
        references teams(team_short_name)

alter table merchandise
    add constraint fk_merchandise_merch_stadium_id foreign key (merch_stadium_id)
        references stadiums(stadium_id)

alter table merchandise
    add constraint fk_merchandise_merch_game_type foreign key (merch_game_type)
        references sports(sport_name)

alter table persons
    add constraint fk_persons_person_role foreign key (person_role)
        references roles(role_id)

alter table players
    add constraint fk_players_player_id foreign key (player_id)
        references persons(person_id)

alter table players
    add constraint fk_players_player_sport_id foreign key (player_sport_id)
        references sports(sport_id)

alter table players
    add constraint fk_players_player_game_id foreign key (player_game_id)
        references games(game_id)

alter table players
    add constraint fk_players_player_school_year foreign key (player_school_year)
        references school_year_lookup(school_year_code)

alter table stadiums
    add constraint fk_stadiums_stadium_state foreign key (stadium_state)
        references state_lookup(state_code)

alter table staff
    add constraint fk_staff_staff_id foreign key (staff_id)
        references persons(person_id)

alter table staff
    add constraint fk_staff_role foreign key (staff_role)
        references roles(role_id)

alter table staff
    add constraint fk_staff_staff_game_id foreign key (staff_game_id)
        references games(game_id)

alter table staff
    add constraint fk_staff_staff_sport_id foreign key (staff_sport_id)
        references sports(sport_id)

alter table teams
    add constraint fk_teams_team_sport foreign key (team_sport)
        references sports(sport_id)

alter table teams
    add constraint fk_teams_team_manager foreign key (team_manager)
        references persons(person_id)

alter table tickets
    add constraint fk_tickets_ticket_game_id foreign key (ticket_game_id)
        references games(game_id)

-- UP DATA --

-- Insert data into 'school_year_lookup'

insert into school_year_lookup
	values
	('FSH', 'Freshman'), ('SPH', 'Sophomore'), ('JNR', 'Junior'), ('SNR', 'Senior'), ('GRD', 'Graudate')

-- Insert data into 'state_lookup'

insert into state_lookup
	values
	('Alabama', 'AL'), ('Alaska', 'AK'), ('Arizona', 'AZ'), ('Arkansas', 'AR'), ('California', 'CA'),
	('Colorado', 'CO'), ('Connecticut', 'CT'), ('Delaware', 'DE'), ('District of Columbia', 'DC'),
	('Florida', 'FL'), ('Georgia', 'GA'), ('Hawaii', 'HI'), ('Idaho', 'ID'), ('Illinois', 'IL'),
	('Indiana', 'IN'), ('Iowa', 'IA'), ('Kansas', 'KS'), ('Kentucky', 'KY'), ('Louisiana', 'LA'),
	('Maine', 'ME'), ('Maryland', 'MD'), ('Massachusetts', 'MA'), ('Michigan', 'MI'), ('Minnesota', 'MN'),
	('Mississippi', 'MS'), ('Missouri', 'MO'), ('Montana', 'MT'), ('Nebraska', 'NE'), ('Nevada', 'NV'),
	('New Hampshire', 'NH'), ('New Jersey', 'NJ'), ('New Mexico', 'NM'), ('New York', 'NY'),
	('North Carolina', 'NC'), ('North Dakota', 'ND'), ('Ohio', 'OH'), ('Oklahoma', 'OK'), ('Oregon', 'OR'),
	('Pennsylvania', 'PA'), ('Rhode Island', 'RI'), ('South Carolina', 'SC'), ('South Dakota', 'SD'),
	('Tennessee', 'TN'), ('Texas', 'TX'), ('Utah', 'UT'), ('Vermont', 'VT'), ('Virginia', 'VA'),
	('Washington', 'WA'), ('West Virginia', 'WV'), ('Wisconsin', 'WI'), ('Wyoming', 'WY')

-- Insert data into 'roles'

insert into roles
	values
	('Student', NULL, NULL), ('Faculty', 30, 'Hourly'), ('Adjunct Faculty', 45000, 'Yearly'),
	('Staff', 20, 'Hourly'), ('Director', 45, 'Hourly')

-- Insert data into 'sports'

insert into sports
	values
	('Basketball', 5, 'Indoor'), ('Baseball', 11, 'Outdoor'), ('Football', NULL, 'Outdoor'), ('Volleyball', 6, 'Indoor'),
	('Soccer', 11, 'Outdoor'), ('Table Tennis', NULL, 'Indoor'), ('Rugby', NULL, 'Outdoor')

-- Insert data into 'stadiums'

insert into stadiums
	values
	('SYR01', 'JMA Dome', '900 Irving Ave', NULL, 'Syracuse', 'NY', '13210', 49000, 'SUO', 5),
	('SYR02', 'SU Soccer Stadium', '1455 E Colvin St', NULL, 'Syracuse', 'NY', '13210', 1500, 'OBB', 4),
	('UCM01', 'Audrey J. Walton Stadium', '500 S Washington Ave', NULL, 'Warrensburg', 'MO', '64093', 12000, 'MUL', 5),
	('UCM02', 'Ellis Field', 'Anderson St', NULL, 'Warrensburg', 'MO', '64093', 400, 'JEN', 2),
	('NJIT01', 'Mal Simon Stadium', '100 Lock Street', NULL, 'Newark', 'NJ', '07102', 1000, 'HIL', 3),
	('CSU01', 'University Stadium', '5151 State University Dr.', NULL, 'Los Angeles', 'CA', '90032', 5000, 'LGE', 4),
	('UTA01', 'Mavericks Stadium', '1307 W Mitchell St', NULL, 'Arlington', 'TX', '76013', 12500, 'MAV', 4),
	('UTA02', 'Campus Recreation Fields Complex', '1100 Maverick', NULL, 'Arlington', 'TX', '76013', 1000, 'UTA', 2),
	('PACE01', 'Peter X. Finnerty Field', '861 Bedford Rd', NULL, 'Pleasantville', 'NY', '10570', 1100, 'PAC', 2)

-- Insert data into 'persons'

insert into persons 
    values 
    ('Sam', 'Sung', 'sam@sung.co', '123-456-7890', 1), ('Spread', 'Sheet', 'ss88@mail.com', '987-654-3210', 1),
    ('Bat', 'Man', 'batman@mail.co', '111-111-1111', 1), ('Apple', 'Sauce', 'apple@sauce.org', '222-222-2222', 1),
    ('Holed', 'Up', 'hol@up.co', '333-333-3333', 2),('Strawberry', 'Jam', 'berry@mail.co', '444-444-4444', 2),
    ('Stock', 'Price', 'stock@price.org', '555-555-5555', 3), ('Data', 'Base', 'data@base.co', '666-666-6666', 4),
    ('Note', 'Pad', 'notepad@mail.com', '777-777-7777', 4), ('Go', 'Kart', 'gokart@mail.co', '888-888-8888', 1),
    ('Jet', 'Fuel', 'jet@fuel.co', '999-999-9999', 3), ('Don', 'Vito', 'dvito87@mail.co', '121-212-1212', 3),
    ('Volume', 'Bar', 'volbar@mail.com', '232-323-2323', 1), ('Tee', 'Shirt', 'tshirt@mail.co', '343-434-3434', 2),
    ('Table', 'Fan', 'table@fan.co', '454-454-4545', 2), ('Mac', 'Book', 'mac@book.com', '565-656-5656', 5),
    ('Win', 'Dows', 'win@dow.com', '676-767-6767', 4), ('Tele', 'Phone', 'tele@phone.co', '787-878-7878', 2),
    ('Wrist', 'Watch', 'watch@mail.co', '898-989-8989', 1), ('Per', 'Fume', 'perfume99@mail.co', '909-090-9090', 3),
    ('Copy', 'Cat', 'cc33@mail.com', '131-313-1313', 5), ('Horse', 'Power', 'horse@power.co', '141-414-1414', 4),
    ('Machine', 'Learning', 'ml88@mail.org', '151-515-1515', 1), ('Smiley', 'Face', 'smile@face.co', '161-616-1616', 3),
    ('Add', 'Ons', 'ad@ons.co', '171-717-1717', 2), ('Space', 'Bar', 'space@bar.com', '181-818-1818', 1),
    ('Candy', 'Cane', 'candy@cane.co', '191-919-1919', 2), ('Mario', 'Kart', 'mario@kart.org', '101-010-1010', 1),
    ('Wall', 'Paper', 'wall@paper.org', '212-121-2121', 3), ('Power', 'Bank', 'power@bank.com', '232-232-2323', 5),
    ('Poker', 'Face', 'poker@face.co', '242-424-2424', 4), ('Gold', 'Chain', 'gold@chain.org', '252-525-2525', 1),
    ('Whit', 'Man', 'whit@man.org', '262-626-2626', 3), ('Center', 'Stage', 'cstage23@mail.co', '272-727-2727', 2),
    ('Milky', 'Way', 'milky@way.com', '282-828-2828', 1), ('Hair', 'Clip', 'hair@clip.co', '292-929-2929', 2),
    ('Zip', 'Tie', 'zip@tie.org', '202-020-2020', 1), ('Per', 'Cent', 'per@cent.co', '202-222-2020', 2),
    ('Indi', 'Pendence', 'indi@pen.co', '313-131-3131', 1), ('Glove', 'Box', 'glove@box.org', '323-232-3232', 1),
    ('Ortho', 'Dox', 'orth@mail.org', '343-434-3434', 3), ('Grand', 'Slam', 'grand@slam.com', '353-535-3535', 2),
    ('Sig', 'Nature', 'sign29@mail.co', '363-636-3636', 4), ('Comp', 'Uter', 'comp@uter.org', '373-737-3737', 1),
    ('Yor', 'Kerr', 'yorkerr@mail.org', '383-838-3838', 3), ('Official', 'Partner', 'offpart@ner.co', '393-939-3939', 1),
    ('Bounce', 'Track', 'bounce@track.com', '303-030-3030', 1), ('Sam', 'Pearl', 'sam@pearl.co', '414-141-4141', 1),
    ('Hat', 'Trick', 'hattrick@mail.org', '424-242-4242', 1), ('Lens', 'Cam', 'lens@cam.co', '434-343-4343', 2)

-- Insert data into 'food'

insert into food
    values
    (1, 'Bottled Water', 500, 1.5, 1, 'SYR01'), (1, 'Bottled Water', 300, 1.5, 3, 'SYR02'),
    (1, 'Bottled Water', 600, 1, 2, 'UCM01'), (1, 'Bottled Water', 150, 1, 1, 'UCM02'),
    (2, 'Dr. Pepper', 50, 2.25, 3, 'SYR01'), (2, 'Dr. Pepper', 25, 2, 4, 'UCM01'),
    (3, 'French Fries', 25, 3, 1, 'SYR01'), (3, 'French Fries', 20, 3, 3, 'SYR02'),
    (3, 'French Fries', 50, 2.5, 2, 'UCM02'), (3, 'French Fries', 40, 3.75, 1, 'NJIT01'),
    (3, 'French Fries', 60, 4, 2, 'CSU01'), (3, 'French Fries', 50, 2.5, 1, 'UTA02'),
    (3, 'French Fries', 70, 3.5, 2, 'PACE01'),
    (4, 'Cheeseburger', 30, 5.5, 1, 'SYR01'), (4, 'Cheeseburger', 50, 5.5, 3, 'SYR02'),
    (4, 'Cheeseburger', 70, 3.5, 2, 'UCM02'), (4, 'Cheeseburger', 100, 7, 1, 'NJIT01'),
    (4, 'Cheeseburger', 70, 6, 1, 'UTA01'), (4, 'Cheeseburger', 50, 5.75, 2, 'UTA02'),
    (4, 'Cheeseburger', 75, 6.75, 2, 'PACE01'), (4, 'Cheeseburger', 40, 7, 1, 'CSU01'),
    (5, 'Veggie Sandwich', 50, 7, 1, 'SYR01'), (5, 'Veggie Sandwich', 75, 5, 2, 'UCM01'),
    (5, 'Veggie Sandwich', 49, 5.5, 3, 'CSU01'), (5, 'Veggie Sandwich', 70, 5.75, 1, 'NJIT01'),
    (5, 'Veggie Sandwich', 45, 6, 2, 'UTA02'), (5, 'Veggie Sandwich', 35, 6.5, 1, 'CSU01'),
    (6, 'Nachos w/ Dip', 30, 12.95, 1, 'SYR01'), (6, 'Nachos w/ Dip', 60, 12.75, 3, 'SYR02'),
    (6, 'Nachos w/ Dip', 50, 9.95, 1, 'UCM01'), (6, 'Nachos w/ Dip', 50, 9.95, 2, 'UCM02'),
    (6, 'Nachos w/ Dip', 70, 14.75, 3, 'NJIT01'), (6, 'Nachos w/ Dip', 75, 14.95, 2, 'PACE01'),
    (6, 'Nachos w/ Dip', 65, 10.5, 2, 'UTA01'), (6, 'Nachos w/ Dip', 50, 10.5, 1, 'UTA02'),
    (6, 'Nachos w/ Dip', 80, 13.95, 1, 'CSU01'),
    (7, 'Popcorn', 300, 7.5, 1, 'SYR01'), (7, 'Popcorn', 260, 7.5, 2, 'SYR02'),
    (7, 'Popcorn', 400, 6.5, 2, 'UCM01'), (7, 'Popcorn', 450, 6.5, 1, 'UCM02'),
    (7, 'Popcorn', 600, 8, 2, 'NJIT01'), (7, 'Popcorn', 500, 8.5, 3, 'CSU01'),
    (7, 'Popcorn', 500, 5.5, 2, 'UTA01'), (7, 'Popcorn', 400, 5.75, 1, 'UTA02'),
    (7, 'Popcorn', 600, 7.75, 1, 'PACE01'), (7, 'Popcorn', 750, 8.5, 1, 'CSU01'),
    (8, 'Cheese Quesadilla', 100, 9, 1, 'SYR01'), (8, 'Cheese Quesadilla', 150, 9.5, 3, 'SYR02'),
    (8, 'Cheese Quesadilla', 200, 8, 2, 'UCM01'), (8, 'Cheese Quesadilla', 200, 9.5, 2, 'NJIT01'),
    (8, 'Cheese Quesadilla', 250, 9.75, 1, 'PACE01'), (8, 'Cheese Quesadilla', 175, 8.25, 2, 'UTA02')

-- Insert data into 'teams'

insert into teams
	values
	('SUO', 'Syracuse University Orange', 3, 60, 15, 6), ('OBB', 'Syracuse Orange', 1, 20, 5, 14),
	('MUL', 'Central Missouri Mules', 3, 55, 13, NULL), ('JEN', 'Jennies UCM', 5, 25, 8, NULL),
	('HIL', 'NJIT Highlanders', 3, 60, 15, NULL), ('LGE', 'LA Golden Eagles', 3, 70, 20, NULL),
	('MAV', 'UTA Mavericks', 1, 15, 3, NULL), ('UTA', 'University of Texas at Arlington', 2, 40, 10, NULL),
	('PAC', 'Pace University Setters', 3, 55, 15, NULL)

-- Insert data into 'games'

insert into games 
    values
    ('Syracuse vs Central Missouri', '05-01-2023', '14:30', 'SYR01', 'Home', 'Basketball', 'OBB', 'MUL'),
    ('Central Missouri vs Syracuse', '05-01-2023', '10:30', 'UCM01', 'Away', 'Baseball', 'MUL', 'OBB'),
    ('Syracuse vs Pace', '05-03-2023', '9:00', 'SYR01', 'Home', 'Football', 'SUO', 'PAC'),
    ('Syracuse vs NJIT Highlanders', '05-02-2023', '13:30', 'SYR01', 'Home', 'Football', 'SUO', 'HIL'),
    ('NJIT Highlanders vs Syracuse', '05-01-2023', '17:30', 'NJIT01', 'Away', 'Basketball', 'HIL', 'OBB'),
    ('Cal State vs Syracuse', '05-05-2023', '17:30', 'CSU01', 'Away', 'Basketball', 'LGE', 'OBB'),
    ('Syracuse vs Central Missouri', '05-05-2023', '13:00', 'SYR01', 'Home', 'Baseball', 'OBB', 'JEN'),
    ('Syracuse vs Pace', '05-04-2023', '18:00', 'SYR01', 'Home', 'Volleyball', 'OBB', 'PAC'),
    ('Syracuse vs NJIT Highlanders', '05-06-2023', '19:00', 'SYR02', 'Home', 'Soccer', 'SUO', 'HIL'),
    ('Central Missouri vs Syracuse', '05-07-2023', '18:00', 'UCM01', 'Away', 'Soccer', 'MUL', 'SUO'),
    ('Syracuse vs Mavericks', '05-07-2023', '13:00', 'SYR02', 'Home', 'Soccer', 'OBB', 'MAV'),
    ('Pace vs Syracuse', '05-07-2023', '14:30', 'PACE01', 'Away', 'Football', 'PAC', 'SUO'),
    ('Syracuse vs Cal State', '05-06-2023', '20:00', 'SYR01', 'Home', 'Table Tennis', 'OBB', 'LGE'),
    ('Central Missouri vs Syracuse', '05-08-2023', '20:00', 'UCM01', 'Away', 'Table Tennis', 'JEN', 'OBB'),
    ('Syracuse vs Cal State', '05-08-2023', '12:00', 'SYR02', 'Home', 'Rugby', 'SUO', 'LGE'),
    ('NJIT Highlanders vs Syracuse', '05-05-2023', '11:30', 'NJIT01', 'Away', 'Basketball', 'HIL', 'OBB'),
    ('Mavericks vs Syracuse', '05-08-2023', '12:30', 'UTA01', 'Away', 'Basketball', 'UTA', 'OBB'),
    ('Mavericks vs Syracuse', '05-08-2023', '16:00', 'UTA01', 'Away', 'Rugby', 'UTA', 'SUO')

-- Insert data into 'merchandise'

insert into merchandise
    values 
    ('SYR01', 'Syracuse Football Home Jersey', 'Clothing', 'Football', 500, 34.95),
    ('SYR01', 'Syracuse Baseball Home Jersey', 'Clothing', 'Baseball', 400, 31.95),
    ('SYR02', 'Syracuse Keychain', 'Accessories', 'Soccer', 1000, 12.00),
    ('UCM02', 'Jennies Rugby Womens Home Jersey', 'Clothing', 'Football', 500, 23.99),
    ('NJIT01', 'Highlanders Bagpack', 'Bags', 'Basketball', 250, 20.99),
    ('PACE01', '32 fl. oz. cup', 'DrinkWare', 'Soccer', 200, 15.25),
    ('UTA01', 'Rugby Away Jersey', 'Clothing', 'Rugby', 300, 24.95),
    ('UTA02', 'Mavericks Lanyard', 'Accessories', 'Football', 750, 8.00),
    ('CSU01', 'CSU Soccer Hat', 'Headwear', 'Soccer', 200, 14.00),
    ('UCM01', 'Jennies Basketball Toy Basketball Replica', 'Toys', 'Basketball', 350, 5.99),
    ('SYR01', '24 fl. oz. tumbler', 'Accessories', 'Basketball', 250, 15.00),
    ('SYR02', 'Mini replica soccer ball', 'Toys', 'Soccer', 500, 6.99),
    ('UCM02', 'Jennies Football Away Jersey', 'Clothing', 'Football', 700, 39.99),
    ('UTA02', 'Mavericks Headband', 'Accessories', 'Basketball', 400, 11.00),
    ('CSU01', 'Cal State Bandana', 'Headwear', 'Rugby', 200, 5.95),
    ('UCM01', 'Mules Rugby Dummy Rugby Ball', 'Toys', 'Rugby', 150, 4.99),
    ('SYR01', 'Syracuse Phone Cover iPhone 12', 'Accessories', 'Football', 200, 13.99),
    ('SYR01', 'Syracuse Bagpack', 'Bags', 'Table Tennis', 175, 18.99),
    ('PACE01', 'Setters Football Home Jersey', 'Clothing', 'Football', 450, 39.99),
    ('UTA01', 'Mavericks Soccer Lanyard', 'Accessories', 'Soccer', 200, 10.00),
    ('CSU01', 'Cal State Baseball Glove', 'Accessories', 'Baseball', 200, 12.99),
    ('SYR01', 'Syracuse Basketball Logo Keychain', 'Accessories', 'Basketball', 100, 9.99),
    ('NJIT01', 'Table Tennis Cap', 'Headwear', 'Table Tennis', 200, 12.95),
    ('PACE01', 'Mens Volleyball Keychain', 'Accessories', 'Volleyball', 150, 10.99),
    ('UCM01', 'Mules Football Home Jersey', 'Clothing', 'Football', 600, 29.99)

-- Insert data into 'players'

insert into players
	values
	(1, 1, 1, 'FSH'), (2, 1, 1, 'SPH'), (3, 1, 1, 'FSH'), (4, 1, 1, 'JNR'), (13, 1, NULL, 'SNR'), (26, 1, 1, 'GRD'), (28, 1, NULL, 'GRD'),
	(32, 1, NULL, 'SNR'), (37, 4, 8, 'SPH'), (39, 4, 8, 'SPH'), (40, 4, NULL, 'JNR'), (44, 4, 8, 'FSH'), (46, 4, 8, 'SNR'), (48, 4, 8, 'FSH'),
	(1, 3, 4, 'FSH'), (10, 3, 4, 'SPH'), (19, 3, 4, 'JNR'), (49, 3, 4, 'SNR'), (41, 5, 9, 'GRD'), (32, 5, NULL, 'SNR'), (35, 5, 9, 'JNR'),
	(2, 6, 13, 'SPH'), (4, 6, 13, 'JNR'), (37, 6, 13, 'SPH'), (48, 6, NULL, 'FSH'), (39, 3, 4, 'SPH'), (23, 5, 9, 'SNR'), (46, 5, 9, 'SNR')

-- Insert data into 'staff'

insert into staff
	values
	(6, 2, 3, 3, 2), (14, 2, 1, 1, 3), (5, 2, 5, 1, 1), (25, 2, 12, 3, 4), (36, 2, NULL, NULL, 0),
	(42, 2, 12, NULL, 1), (11, 3, NULL, 3, 3), (12, 3, 1, 1, 2), (20, 3, NULL, 3, 2), (29, 3, NULL, NULL, 1),
	(41, 3, 3, 3, 2), (19, 4, 3, 3, 5), (17, 4, 12, 3, 6), (22, 4, 5, 1, 4), (31, 4, 1, 1, 3)

-- Insert data into 'tickets'

insert into tickets
	values
	('SYR0101101', 1, '3rd Level Endzone', 'C322', 99),	('SYR0101102', 1, '3rd Level Endzone', 'D412', 99),
	('SYR0101103', 1, '3rd Level Endzone', 'C299', 99),	('SYR0101104', 1, '3rd Level Endzone', 'E126', 95),
	('SYR0103525', 3, 'Premium C', 'C1100', 79), ('SYR0103530', 3, 'Premium C', 'C1102', 79),
	('SYR0103535', 3, 'Premium B', 'B1525', 149), ('SYR0103540', 3, 'Premium B', 'B1526', 149),
	('SYR0103545', 3, 'Premium A', 'A150', 249), ('SYR0103550', 3, 'Premium A', 'A155', 249),
	('UCM0105001', 10, 'Upper Stands', '1001', 75), ('UCM0105002', 10, 'Upper Stands', '1002', 75),
	('UCM0105003', 10, 'Mid Stands', '1003', 100), ('UCM0105004', 10, 'Mid Stands', '1004', 100),
	('UCM0105005', 10, 'Lower Stands', '1005', 125), ('UCM0105006', 10, 'Lower Stands', '1006', 125),
	('UCM0105007', 10, 'Bleachers', '1007', 175), ('UCM0105008', 10, 'Bleachers', '1008', 175),
	('UCM0105009', 10, 'Bleachers', '1009', 200), ('UCM0105010', 10, 'Gallery', '1010', 250),
	('SYR0106700', 13, 'East Zone Lower', 'E220', 99), ('SYR0106750', 13, 'West Zone Upper', 'W440', 49),
	('SYR0207101', 15, '1st Level Corner', '1C01', 249), ('SYR0207102', 15, '2nd Level Corner', '2C01', 199),
	('SYR0207103', 15, '3rd Level Corner', '3C01', 174), ('SYR0207104', 15, '4th Level Corner', '4C01', 109),
	('UTA0101200', 1, 'North Stand Lower', 'A123', 299), ('UTA0101201', 1, 'South Stand Lower', 'A234', 299),
	('UTA0101202', 1, 'North Stand Upper', 'A345', 199), ('UTA0101203', 1, 'South Stand Upper', 'A456', 199)

-- VIEW DATA --

-- A look at all the table contents

select * from food
select * from games
select * from merchandise
select * from persons
select * from players
select * from roles
select * from sports
select * from stadiums
select * from staff
select * from teams
select * from tickets

-- Some queries that utilize our tables and different advanced SQL functions --

-- 1. As a user, I would like to know which stands in a particular stadium sell which food item.

select stadium_name 'Stadium', food_name 'Food Item', food_stand_num 'Stand Number'
    from food f inner join stadiums s on f.food_stadium_id = s.stadium_id
    where food_quantity > 0 and stadium_name like '%Dome%'
    group by stadium_name, food_stand_num, food_name

-- 2. As a user, I would like to know which teams and players are playing in an upcoming game at the Dome.

select game_name 'Game Name', game_sport 'Sport', game_date 'Date', game_time 'Time',
        (select team_name from teams where team_short_name=g.game_home_team) 'Home Team',
        (select team_name from teams where team_short_name=g.game_away_team) 'Away Team',
        stadium_name 'Game Location',
        person_first_name + ' ' + person_last_name as 'Player'
    from games g, stadiums s, players p, persons per
    where stadium_name like '%Dome%' and
        p.player_game_id = g.game_id and
        p.player_id = per.person_id and 
        g.game_date = (select top(1) game_date from games)

-- 3. List of all merchandise available at a particular stadium.

select merch_name 'Merchandise Name', merch_type 'Type',
        stadium_name 'Stadium Name', merch_price 'Price per Item ($)'
    from merchandise m, stadiums s 
    where s.stadium_name like '%Dome%' and 
            merch_stadium_id = stadium_id

-- 4. List of all upcoming events at the Dome.

select game_name 'Game', game_date 'Date', game_time 'Time',
         game_sport 'Sport Event', stadium_name 'Stadium'
    from games g, stadiums s
    where game_location = stadium_id and
        stadium_name like '%Dome%'
    order by game_date, game_time

-- Views based on some common queries --

-- View of all upcoming events at the Dome
GO
create view dome_events as (
    select game_name 'Game', game_date 'Date', game_time 'Time',
         game_sport 'Sport Event', stadium_name 'Stadium'
    from games g, stadiums s
    where game_location = stadium_id and
        stadium_name like '%Dome%'
)
GO
select * from dome_events order by [Date], [Time]
GO

-- View of all the students that participate in a sport
create view student_athletes as (
    select [Player Name], person_email 'Email', sch.school_year_name 'Year', sport_name 'Sport Played'
        from (
            select distinct (person_first_name + ' ' + person_last_name) as 'Player Name',
                person_email, player_sport_id, player_school_year
                from persons p right join players pl
                    on p.person_id = pl.player_id
        ) person_player, sports s, school_year_lookup sch
        where person_player.player_school_year = sch.school_year_code
                and player_sport_id = s.sport_id
)
GO
select * from student_athletes
GO

-- PROCEDURES

-- Procedure to update a team's name. If the team exists, then the name is updated, but
-- if there is no such team, it is added to the teams table.

create procedure p_upsert_team (
    @team_abv char(3),
    @team_name varchar(50)
) as begin 
    if exists (select * from teams where team_short_name = @team_abv)
    begin 
        update teams set team_name = @team_name
        where team_short_name = @team_abv
    end
    else begin 
        insert into teams 
        values (@team_abv, @team_name, 1, 1, NULL, NULL)
    end
end
GO
select * from teams 

exec p_upsert_team 'OBB', 'Oranges Syracuse'
exec p_upsert_team 'STT', 'Syracuse Tennis'

select * from teams
GO
 
-- TRIGGERS

-- Trigger to update the price based on the ticket type

select * from tickets where ticket_serial_num= 'SYR0103535'
GO
create trigger t_update_price
on tickets
after update, insert as
begin 
    declare @ticket_type varchar(50) 
    if exists (select i.ticket_price from inserted i)
    update tickets set ticket_price = 59
    where ticket_type in (select ticket_type from inserted i)
end
GO
select * from tickets where ticket_serial_num='SYR0103535'
update tickets set ticket_type = 'Premium C' where ticket_serial_num='SYR0103535'
select * from tickets where ticket_serial_num='SYR0103535'
GO