CREATE DATABASE IF NOT EXISTS njit
;

USE njit;

DROP TABLE IF EXISTS student
;
DROP TABLE IF EXISTS staff
;
DROP TABLE IF EXISTS building
;
DROP TABLE IF EXISTS room
;
DROP TABLE IF EXISTS department
;
DROP TABLE IF EXISTS faculty
;
DROP TABLE IF EXISTS course
;
DROP TABLE IF EXISTS teachingAssistant
;
DROP TABLE IF EXISTS section
;
DROP TABLE IF EXISTS sr
;
DROP TABLE IF EXISTS assign
;
DROP TABLE IF EXISTS register
;
DROP TABLE IF EXISTS belongTo
;
DROP TABLE IF EXISTS chair
;


CREATE TABLE student (
	sid int NOT NULL,
	sssn char (9) NOT NULL UNIQUE,
	sName varchar (60) NOT NULL,
        sAdd varchar (40) NOT NULL,
	sHigh varchar (30) NOT NULL,
	sYear int NOT NULL,
	major int,
	PRIMARY KEY (sssn)
)ENGINE=INNODB
;

CREATE TABLE staff (
	tssn char (9) NOT NULL,
	tName varchar (60) NOT NULL,
	tAdd varchar (40) NOT NULL,
	tSalary int,
	PRIMARY KEY (tssn)
) ENGINE=INNODB
;

CREATE TABLE building (
	bid int NOT NULL,
	bName varchar (30) NOT NULL,
	location varchar (30) NOT NULL,
	PRIMARY KEY (bid)
) ENGINE=INNODB
;

CREATE TABLE room (
	bid int NOT NULL,
	rNo int NOT NULL,
	capac int NOT NULL,
	av varchar (60),
	PRIMARY KEY (bid, rNo)
) ENGINE = INNODB
;

CREATE TABLE department (
	did int NOT NULL,
	dName varchar (30) NOT NULL,
	budget int NOT NULL,
	officeB int NOT NULL,
	officeR int NOT NULL,
	PRIMARY KEY (did)
) ENGINE=INNODB
;

CREATE TABLE faculty (
	tssn char (9) NOT NULL,
	profRank varchar (30) NOT NULL,
	courseLoad int NOT NULL,
	PRIMARY KEY (tssn)
) ENGINE=INNODB
;

CREATE TABLE course (
	did int NOT NULL,
	cn int NOT NULL,
	cName varchar (60) NOT NULL,
	credit int NOT NULL,
	taHr int NOT NULL,
	PRIMARY KEY (did, cn)
) ENGINE=INNODB
;

CREATE TABLE section (
	did int NOT NULL,
	cn int NOT NULL,
	sNo int NOT NULL,
	maxEnroll int NOT NULL,
	instructor char (9) NOT NULL,
	PRIMARY KEY (did, cn, sNo)
) ENGINE=INNODB
;

CREATE TABLE teachingAssistant (
	ssn char (9) NOT NULL,
	workHr int NOT NULL,
	PRIMARY KEY(ssn)
) ENGINE=INNODB
;

CREATE TABLE assign (
	ssn char (9) NOT NULL,
	did int NOT NULL,
	cn int NOT NULL,
	sNo int NOT NULL,
	PRIMARY KEY (ssn, did, cn, sNo)
) ENGINE=INNODB
;

CREATE TABLE chair (
	ssn char (9) NOT NULL,
	did int NOT NULL,
	PRIMARY KEY (ssn, did)
) ENGINE=INNODB
;

CREATE TABLE belongTo (
	ssn char (9) NOT NULL,
	did int NOT NULL,
	PRIMARY KEY (ssn, did)
) ENGINE=INNODB
;

CREATE TABLE sr (
	did int NOT NULL,
	cn int NOT NULL,
	sNo int NOT NULL,
	bid int NOT NULL,
	rNo int NOT NULL,
	weekDay char (2) NOT NULL,
	startAt TIME (0) NOT NULL,
	endAt TIME (0) NOT NULL,
	PRIMARY KEY(did, cn, sNo, weekDay, startAt)
) ENGINE=INNODB
;

CREATE TABLE register (
	sssn char (9) NOT NULL,
	did int NOT NULL,
	cn int NOT NULL,
	sNo int NOT NULL,
	PRIMARY KEY (sssn, did, cn)
) ENGINE=INNODB
;

ALTER TABLE student
ADD FOREIGN KEY (major) REFERENCES department (did);

ALTER TABLE room
ADD FOREIGN KEY (bid) REFERENCES building (bid);

ALTER TABLE department
ADD FOREIGN KEY (officeB, officeR) REFERENCES room (bid, rNo);

ALTER TABLE faculty
ADD FOREIGN KEY (tssn) REFERENCES staff (tssn);

ALTER TABLE course
ADD FOREIGN KEY (did) REFERENCES department (did);

ALTER TABLE section
ADD FOREIGN KEY (did, cn) REFERENCES course (did, cn),
ADD FOREIGN KEY (instructor) REFERENCES faculty (tssn);

ALTER TABLE teachingAssistant
ADD FOREIGN KEY (ssn) REFERENCES student (sssn),
ADD FOREIGN KEY (ssn) REFERENCES staff (tssn);

ALTER TABLE assign
ADD FOREIGN KEY (ssn) REFERENCES teachingAssistant (ssn),
ADD FOREIGN KEY (did, cn, sNo) REFERENCES section (did, cn, sNo);

ALTER TABLE chair
ADD FOREIGN KEY (ssn) REFERENCES faculty (tssn),
ADD FOREIGN KEY (did) REFERENCES department (did);

ALTER TABLE belongTo
ADD FOREIGN KEY (ssn) REFERENCES faculty (tssn),
ADD FOREIGN KEY (did) REFERENCES department (did);

ALTER TABLE sr
ADD FOREIGN KEY (did, cn, sNo) REFERENCES section (did, cn, sNo),
ADD FOREIGN KEY (bid, rNo) REFERENCES room (bid, rNo);

ALTER TABLE register
ADD FOREIGN KEY (sssn) REFERENCES student (sssn),
ADD FOREIGN KEY (did, cn, sNo) REFERENCES section (did, cn, sNo);

INSERT INTO building (bid, bName, location)
VALUES (100, 'Technology Building', 'Newark'),
(101, 'Clinton Hall', 'Newark'),
(200, 'Wootan Hall', 'Newark'),
(201, 'Underwood Hall', 'Newark'),
(300, 'Academic Building', 'Newark'),
(301, 'Finance Center', 'Jersey City')
;

INSERT INTO room (bid, rNo, capac, av)
VALUES (100, 100, 5, "computers"),
(100, 101, 5, "computers"),
(200, 100, 6, "computers"),
(200, 101, 5, "computers"),
(200, 201, 6, "computers"),
(300, 201, 8, "computers, television"),
(100, 102, 25, "computers desk projector"),
(100, 200, 25, "computers desk projector"),
(100, 201, 20, "computers desk projector"),
(101, 100, 45, "podium, projector"),
(101, 101, 45, "podium, projector"),
(101, 200, 50, "chalkboard only"),
(101, 201, 50, "chalkboard only"),
(200, 102, 15, "chemistry lab"),
(200, 103, 15, "chemistry lab"),
(200, 202, 15, "physics lab"),
(200, 203, 15, "particle physics lab"),
(200, 300, 15, "computer engineering workshop"),
(200, 301, 25, "computers desk smartboard"),
(201, 100, 25, "computer podium"),
(201, 101, 30, "computer podium"),
(201, 102, 25, "computer podium"),
(201, 103, 80, "projector, microphone"),
(201, 201, 20, "chalkboard only"),
(201, 202, 50, "chalkboard only"),
(300, 100, 40, "chalkboard only"),
(300, 101, 30, "computer podium projector"),
(300, 102, 30, "computer podium projector"),
(300, 103, 45, "film projectors screen speakers"),
(300, 200, 30, "musical instruments"),
(300, 202, 15, "biology lab"),
(300, 203, 15, "entomology lab"),
(300, 204, 15, "plant lab"),
(300, 301, 30, "chalkboard only"),
(300, 302, 30, "chalkboard only"),
(300, 303, 25, "smartboard"),
(301, 101, 40, "computers television"),
(301, 102, 35, "servers computers"),
(301, 103, 30, "computers television"),
(301, 201, 40, "computer podium projector")
;

INSERT INTO department (did, dName, budget, officeB, officeR)
VALUES (10, 'Computer Science', 20000000, 100, 100),
(11, 'Computer Engineering', 30000000, 200, 101),
(12, 'Mathematics', 15000000, 100, 101),
(13, 'Physics', 18000000, 200, 100),
(14, 'Chemistry', 32000000, 200, 201),
(15, 'Biology', 19000000, 300, 201)
;

INSERT INTO student (sid, sssn, sName, sAdd, sHigh, sYear, major)
VALUES (101, '383295466', 'Clara Lynch', '546 Atoka St', 'Spring Hill HS', 1, 10),
(102, '186844643', 'Harry Potter', '13 Gryffindor St', 'Seattle HS', 2, 11),
(103, '123356789', 'Hermione Granger', '15 Lincoln Ave', 'Highland Park HS', 3, 12),
(104, '938475865', 'Neville Longbottom', '93 Graham Ave', 'Brooklyn HS', 4, 13),
(105, '154239809', 'Draco Malfoy', '1420 Putnam Ave', 'Bushwick HS', 3, 14),
(106, '916437824', 'Pamila Patel', '82 Raritan Ave', 'New Brunswick HS', 2, 15),
(107, '651541541', 'Zhenliang Yu', '130 Albany Ave', 'Somerset HS', 1, 10),
(108, '354651314', 'Han Solo', '160 5th Ave', 'Manhattan HS', 3, 11),
(109, '987654321', 'Padma Patel', '145 Ravenclaw St', 'London HS', 1, 10),
(110, '876543219', 'Ronald Weasley', '852 Taupiere St', 'St Albaans HS', 4, 11),
(111, '765432198', 'LeRoy Jenkins', '392 Old Meme Rd', 'Underwood HS', 3, 12),
(112, '654321987', 'Lil Naz', '486 Old Town Rd', 'Home HS', 2, 13),
(113, '543219786', 'David Louapre', '79 Etonnant Ln', 'ENS HS', 1, 14),
(114, '543219876', 'Ben Gibbard', '93 Album Ave', 'Brookhaven HS', 4, 15),
(115, '432198765', 'Christopher Lee', '18 Mordor Square', 'Rohan HS', 3, 10),
(116, '200000002', 'Sun Tzu', '2002 Art Ave', 'Official HS', 4, 13),
(117, '300000003', 'Gerhart Keller', '483 Hallsville St', 'Longview HS', 4, 12),
(118, '400000004', 'Jean-Marie Gaulthier', '302 Madison Ave', 'Bordeaux HS', 3, 11),
(119, '500000005', 'LaDanian Tomlinson', '8 Hudson Yards', 'Downtown HS', 3, 10),
(120, '600000006', 'LeBron James', '91 Laker St', 'Los Angeles HS', 2, 10),
(121, '700000007', 'Moon Jae-in', '43 Cleveland St', 'Incheon HS', 1, 15),
(131, '800000008', 'Ban Ki-moon', '999 Union St', 'Seoul HS', 1, 14),
(132, '900000009', 'Karen Patel', '57 Hunderd Ave', 'Circle HS', 1, 13),
(133, '100000012', 'Terrell Owens', '8209 Putnam Ave', 'Bushwick HS', 1, 12),
(134, '100003400', 'Gary Busey', '74 Spongebob St', 'Pineapple HS', 1, 11),
(135, '435890202', 'Cam Newton', '28 Carolina St', 'Charlotte HS', 1, 10),
(136, '321987654', 'Ian McKellan', '42 Scots Circle', 'Edinburg HS', 2, 11),
(137, '219876543', 'Mohammed Morsi', '20 Nile Rd', 'Alexandria HS', 1, 12),
(138, '198765432', 'Abdel al-Sissi', '125 Fameux Ave', 'Fortin HS', 4, 12),
(139, '197346824', 'Ginny Weasley', '5820 Terrier Terrasse', 'Minneapolis HS', 3, 15),
(140, '828282828', 'Julius Caesar', '12 Congress Causeway', 'Crawley HS', 2, 14),
(141, '569814678', 'Luke Skywalker', '89 Emerald Blvd', 'Jedi HS', 2, 12),
(142, '181289128', 'Angela Merkel', '3 Chancellor St', 'Bundeslycee HS', 1, 13),
(143, '106570257', 'Emmanuel Macron', '1001 Boulevard de la Republique', 'ENS HS', 4, 14),
(144, '436105601', 'Victor Orban', '156 Hungary Circle', 'Hebreo HS', 3, 14),
(145, '189967774', 'Vladimir Putin', '473 Highway 34', 'Siberia HS', 2, 15),
(146, '912765612', 'Alexandre Lukashenko', '333 Total Way', 'Minsk HS', 1, 14),
(147, '456537368', 'Silvio Berlusconi', '199 Bungabunga Blvd', 'Rome HS', 2, 13),
(148, '100986222', 'Manuel Valls', '4886 Catalunya St', 'Barcelona HS', 3, 12),
(149, '789542567', 'Michel Onfray', '842 Caens St', 'Caens HS', 4, 11),
(150, '183782922', 'Shinzo Abe', '4 Nippon St', 'Tokyo HS', 3, 11),
(151, '332555464', 'Nahendra Modi', '55 Mumbai St', 'India HS', 2, 10),
(152, '177355556', 'Akash Akul', '13 Bangalore Blvd', 'Tamil HS', 1, 11),
(153, '555555555', 'Xianwen Lu', '64 Newark St', 'Newark HS', 5, 10),
(154, '111111111', 'Elena Alexandrova', '84 Chelyabinsk Lane', 'St Petersburg HS', 6, 11),
(155, '222222222', 'Georges Perec', '188 LePen Lane', 'Lilles HS', 5, 12),
(156, '333333333', 'Laurent Gbagbo', '842 Abidjan Alley', 'Abidjan JS', 6, 13),
(157, '444444444', 'Allasane Ouatara', '1000 St Louis St', 'Dakar HS', 6, 14),
(158, '666666666', 'Le Nguyen Hoang', '9494 Snickers St', 'Paris HS', 5, 15),
(159, '777777777', 'Leopold Senghor', '11 Holy Square', 'Togo HS', 6, 10),
(160, '888888888', 'Ming Wu', '900 Bridge St', 'Dallas HS', 5, 11),
(161, '999999999', 'Xiao Li', '188 34th St', 'Houston HS', 6, 12),
(162, '989898989', 'Benjamin Natanyahu', '55 Gaza Alley', 'Golan Heights HS', 5, 13),
(163, '767676767', 'Bashar al-Assad', '220 Assyria Ave', 'Syria HS', 6, 14),
(164, '454545454', 'Mouhammar Khadafi', '482 Tiberia St', 'Libya HS', 5, 15),
(165, '323232323', 'Fox McCleod', '204 Hyrule St', 'Concordia HS', 6, 10),
(166, '212121211', 'Aung San Suu Kyi', '490 Burma Blvd', 'Myanmar HS', 5, 11),
(167, '919191151', 'Boris Johnson', '1545 Brexit Blvd', 'England HS', 6, 12),
(168, '828246644', 'Nigel Farage', '45289 A1 Highway', 'UKIP HS', 5, 13),
(169, '100000000', 'Giovanni Tanner', '2066 Torino Ln', 'Milan HS', 6, 14),
(170, '100000001', 'Xue Xu', '93 Pekin Place', 'Beijing HS', 5, 15)
;

INSERT INTO staff (tssn, tName, tAdd, tSalary)
VALUES ('777777777', 'Leopold Senghor', '11 Holy Square', 28000),
('888888888', 'Ming Wu', '900 Bridge St', 27000),
('999999999', 'Xiao Li', '188 34th St', 28500),
('989898989', 'Benjamin Natanyahu', '55 Gaza Alley', 27500),
('767676767', 'Bashar al-Assad', '220 Assyria Ave', 28500),
('454545454', 'Mouhammar Khadafi', '482 Tiberia St', 29000),
('323232323', 'Fox McCleod', '204 Hyrule St', 27000),
('212121211', 'Aung San Suu Kyi', '490 Burma Blvd', 26500),
('919191151', 'Boris Johnson', '1545 Brexit Blvd', 27500),
('828246644', 'Nigel Farage', '45289 A1 Highway', 28500),
('100000000', 'Giovanni Tanner', '2066 Torino Ln', 29000),
('100000001', 'Xue Xu', '93 Pekin Place', 30000),
('478230202', 'Aisha Pruydhaman', '114 Topito Rd', 640000),
('864787864', 'Joey Blakeley', '488 Poppins Place', 65000),
('436776212', 'Hunter Smith', '399 Poplar Lane', 47000),
('123456789', 'Minerva McGonagall', '499 Hogwarts Rd', 150000),
('234567891', 'Severus Snape', '13 Slinky Circle', 140000),
('345678912', 'Albus Dumbledore', '54 Castle Way', 230000),
('456789123', 'Pomona Sprout', '389 Greenhouse Circle', 98000), 
('567891234', 'Sybyll Trelawney', '46 Tower Rd', 105000),
('678912345', 'Quirinus Quirrel', '12 Janus Rd', 98500),
('789123456', 'Rubeus Hagrid', '204 Hut St', 78000),
('891234567', 'Wilhelmmina Grubbly-Plank', '268 Planky Rd', 56000),
('912345678', 'Septima Vector', '10 Pythagoras Place', 78000),
('123789456', 'Rolanda Hooch', '8 High St', 80500),
('654987321', 'Horace Slughorn', '79 Privet Drive', 99000),
('456123789', 'Firenze', '49 Forbidden Drive', 49000),
('789456123', 'Gilderoy Lockhart', '600 Hold St', 78000),
('654123987', 'Filius Flitwick', '499 Subtle Square', 149000),
('321987654', 'Dolores Umbridge', '20 Irridis Drive', 99999),
('321654987', 'Aurora Sinistra', '89 Loveland Highway', 88050)
;

INSERT INTO faculty (tssn, profRank, courseLoad)
VALUES ('123456789', 'Full Professor', 9),
('234567891', 'Full Professor', 9),
('345678912', 'Headmaster', 0),
('456789123', 'Full Professor', 9), 
('567891234', 'Associate Professor', 6),
('678912345', 'Visiting Professor', 9),
('789123456', 'Lecturer', 6),
('891234567', 'Adjunct Faculty', 3),
('912345678', 'Associate Professor', 3),
('123789456', 'Lecturer', 6),
('654987321', 'Professor Emeritus', 3),
('456123789', 'Lecturer', 6),
('789456123', 'Visiting Professor', 3),
('654123987', 'Full Professor', 9),
('321987654', 'Assistant Professor', 3),
('321654987', 'Professor Emeritus', 3)
;

INSERT INTO course (did, cn, cName, credit, taHr)
VALUES (10, 100, 'Introduction to Computer Science', 3, 4),
(10, 101, 'Data Structures and Algorithms', 3, 6),
(10, 102, 'C++ Programming', 3, 6),
(10, 103, 'Internet and Higher-Level Protocols', 3, 6),
(10, 201, 'Mobile App Programming', 3, 6),
(10, 202, 'Data Analytics with R', 3, 6),
(10, 203, 'Data Analytics with Python', 3, 6),
(10, 204, 'Operating Systems', 3, 6),
(10, 205, 'Database Management and Design', 3, 6),
(10, 206, 'Cloud Computing', 3, 6),
(10, 301, 'Advanced Java Programming', 3, 8),
(10, 302, 'Advanced Database Management and Design', 3, 8),
(10, 303, 'Machine Learning', 3, 8),
(10, 304, 'Cloud Security', 3, 6),
(10, 401, 'Deep Learning', 3, 8),
(10, 402, 'Image Processing', 3, 8),
(11, 101, 'Computer Organization and Design', 3, 6),
(11, 102, 'The Hardware Software Interface', 3, 6),
(11, 201, 'Computer Architecture', 3, 8),
(11, 202, 'Multi-core Processor Design', 3, 8),
(11, 301, 'Cache Design', 3, 12),
(11, 302, 'Material Science for Comp Eng Majors', 3, 12),
(11, 303, 'Material Science Lab', 1, 4),
(12, 101, 'College Algebra', 3, 4),
(12, 102, 'Precalculus', 3, 6),
(12, 103, 'Calculus I', 3, 6),
(12, 104, 'Calculus II', 3, 6),
(12, 105, 'Calculus III', 3, 6),
(12, 106, 'Applied Statistics', 3, 6),
(12, 201, 'Probability Theory', 3, 6),
(12, 202, 'Mathematical Statistics', 3, 6),
(12, 203, 'Ordinary Differential Equations', 3, 6),
(12, 204, 'Real Analysis', 3, 6),
(12, 205, 'Modern Algebra', 3, 6),
(12, 301, 'Partial Differential Equations', 3, 9),
(12, 302, 'Vector Calculus', 3, 9),
(12, 303, 'Combinatorics', 3, 9),
(12, 304, 'Graph Theory', 3, 9),
(12, 401, 'Fourier Analysis', 3, 12),
(12, 402, 'Measure Theory and Lebesgue Analysis', 3, 12),
(12, 403, 'Multivariate Statistical Methods', 3, 9),
(12, 404, 'Nonparametric Statistics', 3, 9),
(12, 405, 'Design and Analysis of Experiments', 3, 9),
(13, 100, 'Introduction to Astronomy', 3, 4),
(13, 101, 'Intro Astronomy Lab', 1, 4),
(13, 102, 'Introduction to Mechanics', 3, 6),
(13, 103, 'Mechanics Lab', 1, 4),
(13, 104, 'Introduction to Electricity and Magnetism', 3, 6),
(13, 105, 'Electricity and Magnetism Lab', 1, 4),
(13, 201, 'Introduction to Modern Physics', 3, 6),
(13, 202, 'Classical Mechanics', 3, 9),
(13, 203, 'Electricity and Magnetism', 3, 9),
(13, 204, 'Introduction to Astrophysics', 3, 6),
(13, 301, 'Relativity', 3, 9),
(13, 302, 'Advanced Astrophyics', 3, 6),
(13, 401, 'Plasma Physics', 3, 12),
(13, 402, 'Quantum Mechanics', 3, 12),
(13, 403, 'Statistical Physics', 3, 12),
(14, 101, 'General Chemistry', 3, 6),
(14, 102, 'General Chemistry Lab', 1, 4),
(14, 103, 'Chemistry I', 3, 6),
(14, 104, 'Chemistry I Lab', 1, 4),
(14, 105, 'Chemistry II', 3, 6),
(14, 106, 'Chemistry II Lab', 1, 4),
(14, 201, 'Organic Chemistry', 3, 6),
(14, 202, 'Organic Chemistry Lab', 1, 4),
(14, 203, 'Inorganic Chemistry', 3, 6),
(14, 204, 'Inorganic Chemistry Lab', 1, 4), 
(14, 301, 'Biochemistry', 3, 9),
(14, 302, 'Biochemistry Lab', 1, 6),
(14, 303, 'Polymer Chemistry', 3, 9),
(14, 304, 'Polymer Chemistry Lab', 1, 6),
(14, 305, 'Spectroscopy', 3, 9),
(14, 306, 'Spectroscopy Lab', 1, 6),
(15, 101, 'Introduction to Biology', 3, 4),
(15, 102, 'Intro to Biology Lab', 1, 4),
(15, 103, 'Ecology', 3, 6),
(15, 201, 'Cell Biology', 3, 6),
(15, 202, 'Introduction to Evolution', 3, 6),
(15, 203, 'Introduction to Genetics', 3, 6),
(15, 204, 'Vertebrate Phsyiology', 3, 6),
(15, 205, 'Molecular Phsyiology', 3, 9),
(15, 301, 'Evolutionary Theory', 3, 9),
(15, 302, 'Advanced Genetics', 3, 12),
(15, 303, 'Marine Biology', 3, 9),
(15, 304, 'Entomology', 3, 12),
(15, 401, 'Population Dynamics', 3, 12)
;

INSERT INTO teachingAssistant(ssn, workHr)
VALUES ('777777777', 12),
('888888888', 12),
('999999999', 12),
('989898989', 12),
('767676767', 12),
('454545454', 12),
('323232323', 20),
('212121211', 20),
('919191151', 20),
('828246644', 20),
('100000000', 20),
('100000001', 20)
;

INSERT INTO belongTo(ssn, did)
VALUES ('123789456', 10),
('123789456', 11),
('234567891', 10),
('321654987', 14),
('321654987', 15),
('321987654', 14),
('345678912', 10),
('345678912', 11),
('345678912', 12),
('345678912', 13),
('345678912', 14),
('345678912', 15),
('456123789', 13),
('456789123', 15),
('567891234', 12),
('567891234', 13),
('654123987', 14),
('654987321', 11),
('678912345', 10),
('789123456', 13),
('789456123', 10),
('891234567', 10),
('912345678', 12)
;

INSERT INTO chair (ssn, did)
VALUES ('234567891', 10),
('654987321', 11),
('912345678', 12),
('345678912', 13),
('654123987', 14),
('456789123', 15)
;

INSERT INTO section (did, cn, sNo, maxEnroll, instructor)
VALUES (10, 100, 101, 5, '789456123'),
(10, 100, 102, 5, '891234567'),
(10, 103, 101, 3, '678912345'),
(10, 204, 101, 3, '678912345'),
(10, 202, 101, 3, '234567891'),
(10, 302, 101, 3, '234567891'),
(10, 304, 101, 3, '678912345'),
(10, 401, 101, 3, '234567891'),
(11, 101, 101, 5, '123789456'),
(11, 201, 101, 3, '123789456'),
(11, 202, 101, 3, '654987321'),
(12, 101, 101, 5, '567891234'),
(12, 103, 101, 3, '567891234'),
(12, 106, 101, 5, '912345678'),
(13, 100, 101, 5, '789123456'),
(13, 100, 102, 5, '789123456'),
(13, 101, 101, 5, '456123789'),
(13, 101, 102, 5, '456123789'),
(13, 102, 101, 5, '789123456'),
(13, 103, 101, 5, '456123789'),
(14, 101, 101, 5, '654123987'),
(14, 102, 101, 3, '321987654'),
(14, 102, 102, 3, '321987654'),
(14, 103, 101, 5, '654123987'),
(14, 104, 101, 3, '321654987'),
(14, 104, 102, 3, '321654987'),
(14, 201, 101, 3, '654123987'),
(14, 202, 101, 3, '321987654'),
(15, 101, 101, 5, '456789123'),
(15, 102, 101, 5, '321654987'),
(15, 103, 101, 3, '456789123'),
(15, 202, 101, 3, '456789123')
;

INSERT INTO assign (ssn, did, cn, sNo)
VALUES ('323232323', 10, 100, 101),
('323232323', 10, 100, 102),
('777777777', 10, 103, 101),
('323232323', 10, 204, 101),
('323232323', 10, 202, 101),
('777777777', 10, 304, 101),
('888888888', 11, 101, 101),
('212121211', 11, 201, 101),
('212121211', 11, 202, 101),
('999999999', 12, 101, 101),
('919191151', 12, 103, 101),
('919191151', 12, 106, 101),
('828246644', 13, 100, 101),
('828246644', 13, 100, 102),
('989898989', 13, 101, 101),
('989898989', 13, 101, 102),
('828246644', 13, 102, 101),
('989898989', 13, 103, 101),
('100000000', 14, 101, 101),
('767676767', 14, 102, 101),
('767676767', 14, 102, 102),
('100000000', 14, 103, 101),
('100000000', 14, 104, 101),
('100000000', 14, 104, 102),
('767676767', 14, 202, 101),
('100000001', 15, 101, 101),
('100000001', 15, 102, 101),
('100000001', 15, 103, 101),
('454545454', 15, 202, 101)
;

INSERT INTO sr (did, cn, sNo, bid, rNo, weekDay, startAt, endAt)
VALUES (10, 100, 101, 100, 102, 'Tu', '09:30:00', '10:50:00'),
(10, 100, 101, 100, 102, 'Th', '09:30:00', '10:50:00'),
(10, 100, 102, 100, 102, 'Mo', '12:30:00', '13:50:00'),
(10, 100, 102, 100, 102, 'We', '12:30:00', '13:50:00'),
(10, 103, 101, 100, 102, 'Tu', '12:30:00', '13:50:00'),
(10, 103, 101, 100, 102, 'Th', '12:30:00', '13:50:00'),
(10, 204, 101, 100, 200, 'Tu', '09:30:00', '10:50:00'),
(10, 204, 101, 100, 200, 'Th', '09:30:00', '10:50:00'),
(10, 202, 101, 100, 201, 'Mo', '12:30:00', '13:50:00'),
(10, 202, 101, 100, 201, 'We', '12:30:00', '13:50:00'),
(10, 302, 101, 100, 200, 'Tu', '14:00:00', '15:20:00'),
(10, 302, 101, 100, 200, 'Th', '14:00:00', '15:20:00'),
(10, 304, 101, 100, 201, 'Mo', '14:00:00', '15:20:00'),
(10, 304, 101, 100, 201, 'We', '14:00:00', '15:20:00'),
(10, 401, 101, 100, 102, 'Mo', '14:00:00', '15:20:00'),
(10, 401, 101, 100, 102, 'We', '14:00:00', '15:20:00'),
(11, 101, 101, 200, 301, 'Tu', '09:30:00', '10:50:00'),
(11, 101, 101, 200, 301, 'Th', '09:30:00', '10:50:00'),
(11, 201, 101, 200, 301, 'Mo', '12:30:00', '13:50:00'),
(11, 201, 101, 200, 301, 'We', '12:30:00', '13:50:00'),
(11, 202, 101, 200, 301, 'Tu', '14:00:00', '15:20:00'),
(11, 202, 101, 200, 301, 'Th', '14:00:00', '15:20:00'),
(12, 101, 101, 101, 101, 'Tu', '09:30:00', '10:50:00'),
(12, 101, 101, 101, 101, 'Th', '09:30:00', '10:50:00'),
(12, 103, 101, 101, 101, 'Mo', '09:30:00', '10:50:00'),
(12, 103, 101, 101, 101, 'We', '09:30:00', '10:50:00'),
(12, 106, 101, 101, 100, 'Tu', '08:00:00', '09:20:00'),
(12, 106, 101, 101, 100, 'Th', '08:00:00', '09:20:00'),
(13, 100, 101, 201, 103, 'Tu', '09:30:00', '10:50:00'),
(13, 100, 101, 201, 103, 'Th', '09:30:00', '10:50:00'),
(13, 100, 102, 201, 103, 'Mo', '14:00:00', '15:20:00'),
(13, 100, 102, 201, 103, 'We', '14:00:00', '15:20:00'),
(13, 101, 101, 201, 103, 'Tu', '20:00:00', '10:50:00'),
(13, 101, 102, 201, 103, 'We', '20:00:00', '10:50:00'),
(13, 102, 101, 201, 202, 'Mo', '08:00:00', '09:20:00'),
(13, 102, 101, 201, 202, 'We', '08:00:00', '09:20:00'),
(13, 103, 101, 200, 202, 'Mo', '15:30:00', '18:20:00'),
(14, 101, 101, 201, 100, 'Mo', '08:00:00', '09:20:00'),
(14, 101, 101, 201, 100, 'We', '08:00:00', '09:20:00'),
(14, 102, 101, 200, 103, 'Mo', '15:30:00', '18:20:00'),
(14, 102, 102, 200, 103, 'Tu', '15:30:00', '18:20:00'),
(14, 103, 101, 201, 100, 'Tu', '08:00:00', '09:20:00'),
(14, 103, 101, 201, 100, 'Th', '08:00:00', '09:20:00'),
(14, 104, 101, 200, 103, 'Mo', '15:30:00', '18:20:00'),
(14, 104, 102, 200, 103, 'Tu', '15:30:00', '18:20:00'),
(14, 201, 101, 201, 101, 'Tu', '15:30:00', '14:50:00'),
(14, 201, 101, 201, 101, 'Th', '15:30:00', '14:50:00'),
(14, 202, 101, 200, 102, 'Tu', '14:00:00', '15:20:00'),
(14, 202, 101, 200, 102, 'Th', '14:00:00', '15:20:00'),
(15, 101, 101, 300, 101, 'Tu', '14:00:00', '15:20:00'),
(15, 101, 101, 300, 101, 'Th', '14:00:00', '15:20:00'),
(15, 102, 101, 300, 202, 'We', '15:30:00', '18:20:00'),
(15, 103, 101, 300, 102, 'Tu', '12:30:00', '13:50:00'),
(15, 103, 101, 300, 102, 'Th', '12:30:00', '13:50:00'),
(15, 202, 101, 300, 103, 'Mo', '09:30:00', '10:50:00'),
(15, 202, 101, 300, 103, 'We', '09:30:00', '10:50:00')
;