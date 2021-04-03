-- repeatable DDL script
-- drop all procedures
DROP PROCEDURE IF EXISTS InsertCreator;
GO
DROP PROCEDURE IF EXISTS InsertVideo;
GO
DROP PROCEDURE IF EXISTS NewHashtag;
GO
-- drop all views
DROP VIEW IF EXISTS VideosbyCreators;
GO
DROP VIEW IF EXISTS AverageVideoTime;
GO
DROP VIEW IF EXISTS Recommendations;
GO
DROP VIEW IF EXISTS AllUsers;
GO
DROP VIEW IF EXISTS RankCreatorsByFollowers;
GO
DROP VIEW IF EXISTS Tags;
GO
-- drop functions
DROP FUNCTION IF EXISTS TotalMinutesByCreator;
GO
DROP FUNCTION IF EXISTS Verify;
GO
-- drop all tables in reverse order of their dependencies
DROP TABLE IF EXISTS dbo.PlatformAlgorithm;
GO
DROP TABLE IF EXISTS dbo.UserVideo;
GO
DROP TABLE IF EXISTS dbo.VideoHashtag;
GO
DROP TABLE IF EXISTS dbo.UserCreator;
GO

DROP TABLE IF EXISTS dbo.[Platform];
GO
DROP TABLE IF EXISTS dbo.[Algorithm];
GO
DROP TABLE IF EXISTS dbo.Hashtag;
GO
DROP TABLE IF EXISTS dbo.Video;
GO
DROP TABLE IF EXISTS dbo.[User];
GO
DROP TABLE IF EXISTS dbo.Creator;
GO
-- create all tables in order of their dependencies
CREATE TABLE dbo.Creator
(
CreatorID int IDENTITY NOT NULL ,
CreatorName varchar(50),
CreatorSince datetime,
Followers int,
VerifiedStatus varchar(30)
CONSTRAINT Creator_PK PRIMARY KEY (CreatorID),
CONSTRAINT Creator_U1 UNIQUE (CreatorName)
);
GO
CREATE TABLE dbo.[User]
(
UserID int IDENTITY NOT NULL ,
UserName varchar(50) NOT NULL
CONSTRAINT User_PK PRIMARY KEY (UserID)
);
go
CREATE TABLE dbo.Video
(
VideoID int IDENTITY NOT NULL,
VideoName varchar(50) NOT NULL,
VideoLength_seconds int,
CreatorID int,
PublicationDate datetime
CONSTRAINT Video_PK PRIMARY KEY (VideoID),
CONSTRAINT Video_FK1 FOREIGN KEY (CreatorID) REFERENCES dbo.Creator
);
go

CREATE TABLE dbo.Hashtag
(
HashtagID int IDENTITY NOT NULL,
VideoID int,
TagName varchar(50) NOT NULL
CONSTRAINT Hashtag_PK PRIMARY KEY (HashtagID),
CONSTRAINT Hashtag_FK1 FOREIGN KEY (VideoID) REFERENCES dbo.Video
);
go
CREATE TABLE dbo.[Algorithm]
(
AlgorithmID int IDENTITY NOT NULL ,
HashtagID int NOT NULL,
RecommendedVideos varchar(75)
CONSTRAINT Algorithm_PK PRIMARY KEY (AlgorithmID),
CONSTRAINT Algorithm_FK1 FOREIGN KEY (HashtagID) REFERENCES dbo.Hashtag
(HashtagID),
CONSTRAINT Algorithm_U1 UNIQUE (RecommendedVideos)
);
go
CREATE TABLE dbo.[Platform]
(
PlatformID int IDENTITY NOT NULL,
PlatformName varchar(30) NOT NULL,
RecommendedVideos varchar(75)
CONSTRAINT Platform_PK PRIMARY KEY (PlatformID),
CONSTRAINT Platform_FK1 FOREIGN KEY (RecommendedVideos) REFERENCES dbo.
[Algorithm] (RecommendedVideos),
);
go
CREATE TABLE dbo.UserCreator
(
UserCreatorID int IDENTITY NOT NULL,
UserID int,
CreatorName varchar(50) NOT NULL
CONSTRAINT UserCreator_PK PRIMARY KEY (UserCreatorID),
CONSTRAINT UserCreator_FK1 FOREIGN KEY (UserID) REFERENCES dbo.[User]
(UserID),
CONSTRAINT UserCreator_FK2 FOREIGN KEY (CreatorName) REFERENCES dbo.Creator
(CreatorName)
);
go

CREATE TABLE VideoHashtag
(
VideoHashtagID int IDENTITY NOT NULL,
HashtagID int,
VideoID int
CONSTRAINT VideoHashtag_PK PRIMARY KEY (VideoHashtagID),
CONSTRAINT VideoHashtag_FK1 FOREIGN KEY (HashtagID) REFERENCES dbo.Hashtag,
CONSTRAINT VideoHashtag_FK2 FOREIGN KEY (VideoID) REFERENCES dbo.Video
);
go
CREATE TABLE UserVideo
(
UserVideoId int IDENTITY NOT NULL,
UserID int,
VideoID int
CONSTRAINT UserVideo_PK PRIMARY KEY (UserVideoID),
CONSTRAINT UserVideo_FK1 FOREIGN KEY (UserID) REFERENCES dbo.[User],
CONSTRAINT UserVideo_FK2 FOREIGN KEY (VideoID) REFERENCES dbo.Video
);
go
CREATE TABLE PlatformAlgorithm
(
PlatformAlgorithmID int IDENTITY NOT NULL,
AlgorithmID int,
HashtagID int
CONSTRAINT PlatformAlgorithm_PK PRIMARY KEY (PlatformAlgorithmID),
CONSTRAINT PlatformAlgorithm_FK1 FOREIGN KEY (AlgorithmID) REFERENCES dbo.
[Algorithm],
CONSTRAINT PlatformAlgorithm_FK2 FOREIGN KEY (HashtagID) REFERENCES
dbo.Hashtag
);
go
-- enter in data into your tables
INSERT INTO Creator (CreatorName, CreatorSince, Followers, VerifiedStatus)
VALUES('vidmaster', '7/5/2016', '1200', 'Verified'), ('animalanimations',
'3/14/2017', '850', 'Unverified'), ('newsbites', '2/22/2018', '1000',
'Verified'),
('foodqueen', '4/30/2017', '700', 'Unverified'), ('singmusic', '11/21/2019',
'850', 'Unverified'), ('studydata', '5/18/2018', '650', 'Unverified'),
('gamegod', '10/16/2017', '1400', 'Verified'), ('allmythoughts', '4/3/2020',
'750', 'Unverified'),('artful', '9/15/2016', '550', 'Unverified'),
('cityguides', '6/7/2019', '900' ,'Unverified')

INSERT INTO [User] (UserName)
VALUES ('gamergeek'), ('notabot22'), ('doglover09'), ('yourfoodiefriend'),('asimpleusername')

INSERT INTO Video (VideoName, VideoLength_seconds, CreatorID, PublicationDate)
VALUES ('My Favorite Video Camera', '531', (SELECT CreatorID FROM Creator WHERE
CreatorName = 'vidmaster'), '8/2/2017'),
('Editing tools you should use', '461', (SELECT CreatorID FROM Creator WHERE
CreatorName = 'vidmaster'), '12/15/2016'),
('Which video platform is the best?', '543', (SELECT CreatorID FROM Creator
WHERE CreatorName = 'vidmaster'), '1/18/2019'),
('Puppies running for 3 minutes', '181', (SELECT CreatorID FROM Creator WHERE
CreatorName = 'animalanimations'), '3/16/2018'),
('If cats could talk to us', '345', (SELECT CreatorID FROM Creator WHERE
CreatorName = 'animalanimations'), '10/6/2017'),
('Puppies running for 3 minutes', '181', (SELECT CreatorID FROM Creator WHERE
CreatorName = 'animalanimations'), '3/24/2019'),
('Trending topics today', '501', (SELECT CreatorID FROM Creator WHERE
CreatorName = 'newsbites'), '3/18/2018'),
('Recapping the week', '424', (SELECT CreatorID FROM Creator WHERE
CreatorName = 'newsbites'), '5/4/2019'),
('Journalist shoutouts', '373', (SELECT CreatorID FROM Creator WHERE
CreatorName = 'newsbites'), '11/20/2019'),
('My favorite desserts', '677', (SELECT CreatorID FROM Creator WHERE
CreatorName = 'foodqueen'), '10/3/2017'),
('How to make a cake with 5 ingredients', '546', (SELECT CreatorID FROM
Creator WHERE CreatorName = 'foodqueen'), '1/16/2018'),
('Checking out the newest coffee shop in the city!', '677', (SELECT CreatorID
FROM Creator WHERE CreatorName = 'foodqueen'), '6/12/2017'),
('Cover of "Living on a prayer"', '352', (SELECT CreatorID FROM Creator WHERE
CreatorName = 'singmusic'), '2/13/2020'),
('Cover of "Havana"', '274', (SELECT CreatorID FROM Creator WHERE CreatorName
= 'singmusic'), '12/13/2019'),
('My new at-home studio', '602', (SELECT CreatorID FROM Creator WHERE
CreatorName = 'singmusic'), '1/5/2020'),
('Skills to learn as a data analyst', '402', (SELECT CreatorID FROM Creator
WHERE CreatorName = 'studydata'), '2/3/2019'),
('Best free online resources', '258', (SELECT CreatorID FROM Creator WHERE
CreatorName = 'studydata'), '11/13/2018'),
('Which programming language should you learn?', '319', (SELECT CreatorID
FROM Creator WHERE CreatorName = 'studydata'), '11/29/2018'),
('What I love about the PS5', '591', (SELECT CreatorID FROM Creator WHERE
CreatorName = 'gamegod'), '1/4/2020'),
('What I do with old consoles', '428', (SELECT CreatorID FROM Creator WHERE
CreatorName = 'gamegod'), '3/20/2019'),
('Playing Among Us for 8 hours straight', '729', (SELECT CreatorID FROM
Creator WHERE CreatorName = 'gamegod'), '3/3/2020'),
('How Yoga Changed My Life', '491', (SELECT CreatorID FROM Creator WHERE
CreatorName = 'allmythoughts'), '5/3/2020'),
('Self Care Sunday', '350', (SELECT CreatorID FROM Creator WHERE CreatorName
= 'allmythoughts'), '6/14/2020'),
('Life hacks that helped me tremendously', '554', (SELECT CreatorID FROM
Creator WHERE CreatorName = 'allmythoughts'), '6/30/2020'),
('Painting a landscape with watercolors', '498', (SELECT CreatorID FROM
Creator WHERE CreatorName = 'artful'), '5/12/2017'),
('New art gallery in the city', '391', (SELECT CreatorID FROM Creator WHERE
CreatorName = 'artful'), '7/7/2018'),
('Donating art supplies', '290', (SELECT CreatorID FROM Creator WHERE
CreatorName = 'artful'), '2/22/2019'),
('Hidden gems of NYC', '426', (SELECT CreatorID FROM Creator WHERE
CreatorName = 'cityguides'), '10/12/2019'),
('Hidden gems of Charleston', '356', (SELECT CreatorID FROM Creator WHERE
CreatorName = 'cityguides'), '1/14/2020'),
('Best new rooftop lounge in Miami', '259', (SELECT CreatorID FROM Creator
WHERE CreatorName = 'cityguides'), '8/25/2019')

INSERT INTO Hashtag (VideoID, TagName)
VALUES ((SELECT TOP 1 VideoID FROM Video WHERE VideoName = 'My favorite
desserts'),'food'),
((SELECT TOP 1 VideoID FROM Video WHERE VideoName = 'My favorite
desserts'),'sweets'),
((SELECT TOP 1 VideoID FROM Video WHERE VideoName = 'My favorite
desserts'),'confections'),
((SELECT TOP 1 VideoID FROM Video WHERE VideoName = 'Cover of "Living on
a prayer"'),'music'),
((SELECT TOP 1 VideoID FROM Video WHERE VideoName = 'Cover of "Living on
a prayer"'),'throwback'),
((SELECT TOP 1 VideoID FROM Video WHERE VideoName = 'Cover of "Living on
a prayer"'),'classic'),
((SELECT TOP 1 VideoID FROM Video WHERE VideoName = 'Painting a landscape
with watercolors'),'art'),
((SELECT TOP 1 VideoID FROM Video WHERE VideoName = 'Painting a landscape
with watercolors'),'watercolors'),
((SELECT TOP 1 VideoID FROM Video WHERE VideoName = 'Painting a landscape
with watercolors'),'expression'),
((SELECT TOP 1 VideoID FROM Video WHERE VideoName = 'Puppies running for
3 minutes'),'cute'),
((SELECT TOP 1 VideoID FROM Video WHERE VideoName = 'Puppies running for
3 minutes'),'puppies'),
((SELECT TOP 1 VideoID FROM Video WHERE VideoName = 'Puppies running for
3 minutes'),'pets'),
((SELECT TOP 1 VideoID FROM Video WHERE VideoName = 'Trending topics
today'),'trending'),
((SELECT TOP 1 VideoID FROM Video WHERE VideoName = 'Trending topics
today'),'news'),
((SELECT TOP 1 VideoID FROM Video WHERE VideoName = 'Trending topics
today'),'information'),
((SELECT TOP 1 VideoID FROM Video WHERE VideoName = 'Skills to learn as a
data analyst'),'data'),
((SELECT TOP 1 VideoID FROM Video WHERE VideoName = 'Skills to learn as a
data analyst'),'information'),
((SELECT TOP 1 VideoID FROM Video WHERE VideoName = 'Skills to learn as a
data analyst'),'upskill'),
((SELECT TOP 1 VideoID FROM Video WHERE VideoName = 'What I love about
the PS5'),'gaming'),
((SELECT TOP 1 VideoID FROM Video WHERE VideoName = 'What I love about
the PS5'),'playstation'),
((SELECT TOP 1 VideoID FROM Video WHERE VideoName = 'What I love about
the PS5'),'gaming'),
((SELECT TOP 1 VideoID FROM Video WHERE VideoName = 'Hidden gems of
NYC'),'explore'),
((SELECT TOP 1 VideoID FROM Video WHERE VideoName = 'Hidden gems of
NYC'),'secrets'),
((SELECT TOP 1 VideoID FROM Video WHERE VideoName = 'Hidden gems of
NYC'),'guides'),
((SELECT TOP 1 VideoID FROM Video WHERE VideoName = 'Self Care
Sunday'),'pamper'),
((SELECT TOP 1 VideoID FROM Video WHERE VideoName = 'Self Care
Sunday'),'health'),
((SELECT TOP 1 VideoID FROM Video WHERE VideoName = 'Self Care
Sunday'),'wellness'),
((SELECT TOP 1 VideoID FROM Video WHERE VideoName = 'My Favorite Video
Camera'),'equipment'),
((SELECT TOP 1 VideoID FROM Video WHERE VideoName = 'My Favorite Video
Camera'),'cameras'),
((SELECT TOP 1 VideoID FROM Video WHERE VideoName = 'My Favorite Video
Camera'),'recommendations')
GO

-- this is a subquery that should go
-- in the value for hashtagID (SELECT TOP 1 HashtagID FROM Hashtag WHERE TagName
= 'technology')
INSERT INTO [Algorithm] (HashtagID, RecommendedVideos)
VALUES (1, (SELECT TOP 1 HashtagID FROM Hashtag WHERE VideoID = 1))
GO
--this view returns videos that are recommended on the platform where the videos
from this model are located
--dictated by the algorithm. the algorithm in this model works by detecting the
hashtags being used
--on each video, which have been defined in the hashtag table
CREATE VIEW dbo.Recommendations
AS
SELECT Alg.RecommendedVideos
FROM dbo.[Algorithm] as Alg
JOIN dbo.[Platform] as PF ON PF.RecommendedVideos = Alg.RecommendedVideos
;
GO
INSERT INTO [Platform] (PlatformName, RecommendedVideos)
VALUES ('MinuteMovies', (SELECT * FROM Recommendations))
GO
INSERT INTO UserCreator (UserID, CreatorName)
VALUES ((SELECT UserID FROM [User] WHERE UserName = 'gamergeek'), (SELECT CreatorName FROM Creator WHERE CreatorName = 'gamegod')),
((SELECT UserID FROM [User] WHERE UserName = 'gamergeek'), (SELECT
CreatorName FROM Creator WHERE CreatorName = 'newsbites')),
((SELECT UserID FROM [User] WHERE UserName = 'gamergeek'), (SELECT
CreatorName FROM Creator WHERE CreatorName = 'vidmaster')),
((SELECT UserID FROM [User] WHERE UserName = 'notabot22'), (SELECT
CreatorName FROM Creator WHERE CreatorName = 'allmythoughts')),
((SELECT UserID FROM [User] WHERE UserName = 'notabot22'), (SELECT
CreatorName FROM Creator WHERE CreatorName = 'vidmaster')),
((SELECT UserID FROM [User] WHERE UserName = 'notabot22'), (SELECT
CreatorName FROM Creator WHERE CreatorName = 'cityguides')),
((SELECT UserID FROM [User] WHERE UserName = 'notabot22'), (SELECT
CreatorName FROM Creator WHERE CreatorName = 'newsbites')),
((SELECT UserID FROM [User] WHERE UserName = 'doglover09'), (SELECT
CreatorName FROM Creator WHERE CreatorName = 'animalanimations')),
((SELECT UserID FROM [User] WHERE UserName = 'doglover09'), (SELECT
CreatorName FROM Creator WHERE CreatorName = 'artful')),
((SELECT UserID FROM [User] WHERE UserName = 'doglover09'), (SELECT
CreatorName FROM Creator WHERE CreatorName = 'singmusic')),
((SELECT UserID FROM [User] WHERE UserName = 'yourfoodiefriend'), (SELECT
CreatorName FROM Creator WHERE CreatorName = 'cityguides')),
((SELECT UserID FROM [User] WHERE UserName = 'yourfoodiefriend'), (SELECT
CreatorName FROM Creator WHERE CreatorName = 'foodqueen')),
((SELECT UserID FROM [User] WHERE UserName = 'asimpleusername'), (SELECT
CreatorName FROM Creator WHERE CreatorName = 'foodqueen')),
((SELECT UserID FROM [User] WHERE UserName = 'asimpleusername'), (SELECT
CreatorName FROM Creator WHERE CreatorName = 'newsbites')),
((SELECT UserID FROM [User] WHERE UserName = 'asimpleusername'), (SELECT
CreatorName FROM Creator WHERE CreatorName = 'studydata')),
((SELECT UserID FROM [User] WHERE UserName = 'asimpleusername'), (SELECT
CreatorName FROM Creator WHERE CreatorName = 'allmythoughts'))
GO

INSERT INTO UserVideo (UserId, VideoID)
VALUES ((SELECT Top 1 UserID FROM [User] WHERE UserName = 'gamergeek'), (SELECT
Top 1 VideoID FROM Video WHERE VideoName = 'What I do with old consoles')),
((SELECT Top 1 UserID FROM [User] WHERE UserName = 'gamergeek'), (SELECT Top
1 VideoID FROM Video WHERE VideoName = 'Playing Among Us for 8 hours
straight')),
((SELECT Top 1 UserID FROM [User] WHERE UserName = 'gamergeek'), (SELECT Top
1 VideoID FROM Video WHERE VideoName = 'What I love about the PS5')),
((SELECT Top 1 UserID FROM [User] WHERE UserName = 'notabot22'), (SELECT Top
1 VideoID FROM Video WHERE VideoName = 'Editing tools you should use')),
((SELECT Top 1 UserID FROM [User] WHERE UserName = 'notabot22'), (SELECT Top
1 VideoID FROM Video WHERE VideoName = 'Hidden gems of Charleston')),
((SELECT Top 1 UserID FROM [User] WHERE UserName = 'notabot22'), (SELECT Top
1 VideoID FROM Video WHERE VideoName = 'How Yoga Changed My Life')),
((SELECT Top 1 UserID FROM [User] WHERE UserName = 'doglover09'), (SELECT Top
1 VideoID FROM Video WHERE VideoName = 'Puppies running for 3 minutes')),
((SELECT Top 1 UserID FROM [User] WHERE UserName = 'doglover09'), (SELECT Top
1 VideoID FROM Video WHERE VideoName = 'Cover of "Havana"')),
((SELECT Top 1 UserID FROM [User] WHERE UserName = 'doglover09'), (SELECT Top
1 VideoID FROM Video WHERE VideoName = 'Donating art supplies')),
((SELECT Top 1 UserID FROM [User] WHERE UserName = 'yourfoodiefriend'),
(SELECT Top 1 VideoID FROM Video WHERE VideoName = 'Checking out the newest
coffee shop in the city!')),
((SELECT Top 1 UserID FROM [User] WHERE UserName = 'yourfoodiefriend'),
(SELECT Top 1 VideoID FROM Video WHERE VideoName = 'My favorite
desserts')),
((SELECT Top 1 UserID FROM [User] WHERE UserName = 'yourfoodiefriend'),
(SELECT Top 1 VideoID FROM Video WHERE VideoName = 'How to make a cake with
5 ingredients'))
GO

-- a procedure to enter a new creator into the creator table
CREATE PROCEDURE dbo.InsertCreator
@CreatorName varchar(50)
AS
INSERT dbo.Creator (CreatorName) VALUES (@CreatorName);
RETURN SCOPE_IDENTITY();
GO
-- a procedure to enter a new video into the video table
CREATE PROCEDURE dbo.InsertVideo
@VideoName varchar(50)
AS
INSERT dbo.Video (VideoName) VALUES (@VideoName);
RETURN SCOPE_IDENTITY();
GO
-- a procedure to enter a new hashtag into the hashtag table
CREATE PROCEDURE dbo.NewHashtag
@TagName varchar(50)
AS
INSERT dbo.Hashtag (Tagname) VALUES (@TagName);
RETURN SCOPE_IDENTITY();
GO
--this function will calculate the total number of minutes and seconds of content
--by each creator, which will be retrieved from each video
CREATE FUNCTION dbo.TotalMinutesByCreator (@CreatorID int)
RETURNS int AS
BEGIN
DECLARE @returnvalue int
SELECT @returnvalue = SUM(VideoLength_seconds)
FROM dbo.Video
JOIN dbo.Creator ON Creator.CreatorID = Video.CreatorID
WHERE Video.CreatorID = @CreatorID
RETURN @returnvalue
END
GO

--this is a function that will identify creators as 'verified' or 'unverified'
--based on the number of followers they have
CREATE FUNCTION dbo.Verify (@ID int)
RETURNS varchar(30)
AS
BEGIN
DECLARE @verifiedstatus varchar(30)
SELECT @verifiedstatus = VerifiedStatus FROM Creator
WHERE CreatorID = @ID
RETURN @verifiedstatus
END
GO
--this view lists in the form of a table
--all the creators from highest follower count to lowest follower count
CREATE VIEW dbo.RankCreatorsbyFollowers
AS
SELECT Followers From dbo.Creator
--ORDER BY Followers DESC
GO
-- pulling results from various tables and views
SELECT * FROM dbo.Creator;
GO
SELECT * FROM dbo.[User];
GO
SELECT * FROM dbo.Video;
GO
SELECT * FROM dbo.Hashtag;
GO
CREATE VIEW dbo.AllUsers
AS
SELECT Creator.CreatorName
FROM dbo.UserCreator
JOIN dbo.Creator on Creator.CreatorName = UserCreator.CreatorName
GO
--this view will show every single video in this database that each creator
created
CREATE VIEW dbo.VideosbyCreators
AS
SELECT Video.VideoID, Video.VideoName, Creator.CreatorID, Creator.CreatorName
FROM dbo.Creator
FULL OUTER JOIN dbo.Video ON Video.CreatorID = Creator.CreatorID
;
GO
CREATE VIEW dbo.Tags
AS
SELECT Video.VideoID, Video.VideoName FROM dbo.Video
LEFT JOIN dbo.Hashtag on Video.VideoID = Hashtag.VideoID
;
GO
--this is a view for a select statement that takes the average in minutes and
seconds
--of the videos from a single creator (describing a creator's video length by
--the video's average)
CREATE VIEW dbo.AverageVideoTime
AS
SELECT avg(VideoLength_seconds/60) as AverageVideoLength, Video.CreatorID
from dbo.Video
GROUP BY CreatorID
GO
