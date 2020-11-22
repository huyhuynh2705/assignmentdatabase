﻿
CREATE DATABASE PUBLICATION;

USE PUBLICATION;

CREATE TABLE SCIENTIST (
	Ssn			VARCHAR(15),
	Email		VARCHAR(100),
	Job			VARCHAR(255),
	Fname		VARCHAR(50),
	LName		VARCHAR(50),
	Address		TEXT,
	WorkPlace	VARCHAR(255),
	PRIMARY KEY (Ssn)
);

CREATE TABLE EDITORIAL_BOARD (
	Ssn			VARCHAR(15) ,
	Position	VARCHAR(255),
	PRIMARY KEY (Ssn),
	FOREIGN KEY (Ssn) REFERENCES SCIENTIST(Ssn)
);

CREATE TABLE AUTHOR (
	Ssn			VARCHAR(15) ,
	PRIMARY KEY (Ssn),
	FOREIGN KEY (Ssn) REFERENCES SCIENTIST(Ssn)
);

CREATE TABLE REVIEWER (
	Ssn					VARCHAR(15),
	WorkPlaceEmail		VARCHAR(100),
	Specialty			VARCHAR(255),
	Level 				VARCHAR(50),
	NumberPhone			VARCHAR(15),
	CollaborationDate 	DATE,
	PRIMARY KEY (Ssn),
	FOREIGN KEY (Ssn) REFERENCES SCIENTIST(Ssn)
);

CREATE TABLE ARTICLE (
	ID					VARCHAR(15),
	Title				TEXT,
	Summary				TEXT,
	ArticleFile			VARCHAR(255),
	Status			 	INT,
	SentDate			DATE,
	PRIMARY KEY (ID),
	CHECK (Status >=0 AND Status <=4)
);

CREATE TABLE RESEARCH (
	ID				VARCHAR(15),
	NumberOfPage	INT,
	PRIMARY KEY (ID),
	FOREIGN KEY (ID) REFERENCES ARTICLE(ID),
	CHECK (NumberOfPage > 10 AND NumberOfPage <=20)
);

CREATE TABLE OVERVIEW (
	ID				VARCHAR(15),
	NumberOfPage	INT,
	PRIMARY KEY (ID),
	FOREIGN KEY (ID) REFERENCES ARTICLE(ID),
	CHECK (NumberOfPage >= 3 AND NumberOfPage <= 10)
);

CREATE TABLE REVIEW_BOOK (
	ID				VARCHAR(15),
	NumberOfPage	INT,
	PRIMARY KEY (ID),
	FOREIGN KEY (ID) REFERENCES ARTICLE(ID), 
	CHECK (NumberOfPage >= 3 AND NumberOfPage <= 6)
);

CREATE TABLE BOOK (
	ISBN				VARCHAR(15),
	BookName			VARCHAR(255),
	AuthorName			VARCHAR(255),
	PublishingYear		VARCHAR(4),
	Publisher			VARCHAR(255),
	NumberOfPage	 	INT,
	PRIMARY KEY (ISBN),
	CHECK (NumberOfPage > 0)
);

CREATE TABLE PUBLISHED_ARTICLE (
	DOI				VARCHAR(15),
	Form			VARCHAR(50),
	PRIMARY KEY (DOI)
);

CREATE TABLE CRITERIA (
	ID				VARCHAR(15),
	PRIMARY KEY (ID)
);

CREATE TABLE RATING_LEVEL (
	ID			VARCHAR(15),
	Des			VARCHAR(255),
	PRIMARY KEY (Des,ID),
	FOREIGN KEY (ID) REFERENCES CRITERIA(ID)
);

ALTER TABLE PUBLISHED_ARTICLE ADD ArticleID VARCHAR (15) NOT NULL;
ALTER TABLE PUBLISHED_ARTICLE ADD FOREIGN KEY (ArticleID) REFERENCES ARTICLE(ID);

ALTER TABLE CRITERIA ADD EditorialBoardSsn VARCHAR (15) NOT NULL;
ALTER TABLE CRITERIA ADD FOREIGN KEY (EditorialBoardSsn) REFERENCES EDITORIAL_BOARD(Ssn);

ALTER TABLE ARTICLE ADD AuthorSSn VARCHAR (15) NOT NULL;
ALTER TABLE ARTICLE ADD FOREIGN KEY (AuthorSSn) REFERENCES AUTHOR(Ssn);

ALTER TABLE ARTICLE ADD EditorialBoardSsn VARCHAR (15) NOT NULL;
ALTER TABLE ARTICLE ADD	Result INT;
ALTER TABLE ARTICLE ADD Detail TEXT;
ALTER TABLE ARTICLE ADD AnnoucementDate DATE;
ALTER TABLE ARTICLE ADD FOREIGN KEY (EditorialBoardSsn) REFERENCES EDITORIAL_BOARD(Ssn);

CREATE TABLE WRITE (
	ID		VARCHAR(15),
	Ssn		VARCHAR(15),
	PRIMARY KEY (ID, Ssn),
	FOREIGN KEY (ID) REFERENCES ARTICLE(ID),
	FOREIGN KEY (Ssn) REFERENCES AUTHOR(Ssn) 
);

CREATE TABLE REVIEW_OF_BOOK (
	ID		VARCHAR(15),
	ISBN	VARCHAR(15),
	PRIMARY KEY (ID, ISBN),
	FOREIGN KEY (ID) REFERENCES ARTICLE(ID),
	FOREIGN KEY (ISBN) REFERENCES BOOK(ISBN) 
);

CREATE TABLE KEY_WORD(
	ArticleID	VARCHAR(15),
	KeywordID	VARCHAR(15),
	PRIMARY KEY (ArticleID, KeywordID),
	FOREIGN KEY (ArticleID) REFERENCES ARTICLE(ID)
);

CREATE TABLE FIELD(
	Ssn		VARCHAR(15),
	FieldID	VARCHAR(15),
	PRIMARY KEY (Ssn, FieldID),
	FOREIGN KEY (Ssn) REFERENCES SCIENTIST(Ssn)
);

CREATE TABLE ASSIGN(
	ArticleID			VARCHAR(15),
	ReviewerSsn			VARCHAR(15),
	EditorialBoardSsn	VARCHAR(15) NOT NULL,
	AssignDate			DATE,
	PRIMARY KEY (ArticleID,ReviewerSsn),
	FOREIGN KEY (ReviewerSsn) REFERENCES REVIEWER(Ssn),
	FOREIGN KEY (ArticleID) REFERENCES ARTICLE(ID),
	FOREIGN KEY (EditorialBoardSsn) REFERENCES EDITORIAL_BOARD(Ssn)
);

CREATE TABLE EVALUATE(
	ReviewerSsn				VARCHAR(15),
	ArticleID				VARCHAR(15),
	CriteriaID				VARCHAR(15),
	ReviewContent			TEXT,
	NoteForEB				TEXT,
	NoteForAU				TEXT,
	PRIMARY KEY (ReviewerSsn,ArticleID,CriteriaID),
	FOREIGN KEY (ReviewerSsn) REFERENCES REVIEWER(Ssn),
	FOREIGN KEY (ArticleID) REFERENCES ARTICLE(ID),
	FOREIGN KEY (CriteriaID) REFERENCES CRITERIA(ID)
); 

