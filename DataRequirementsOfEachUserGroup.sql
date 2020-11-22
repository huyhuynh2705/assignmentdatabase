
--(i). Ban biên tập
--(i.1). Cập nhật phân công phản biện cho một bài báo.
CREATE PROCEDURE updateAssign (@articleId INT, @reviewerSsn INT, @editorialBoardSsn INT, @assignDate DATE)
AS
BEGIN
	IF EXISTS(select * from ASSIGN where ArticleID=@articleId)
	   update ASSIGN set ReviewerSsn=@reviewerSsn, EditorialBoardSsn=@editorialBoardSsn, AssignDate=@assignDate 
	   where ArticleID=@articleId
END
select * from ASSIGN
EXEC updateAssign 2,4,1,'2020-11-20'  
--------------------------------------------------------------------------------------------
--(i.2). Cập nhật trạng thái xử lý cho một bài báo: 
-- phản biện = 0, phản hồi phản biện = 1, hoàn tất phản biện = 2, xuất bản = 3, đã đăng = 4.
CREATE PROCEDURE updateStatusArticle (@status INT, @id INT)
AS
BEGIN
	UPDATE ARTICLE SET Status = @status WHERE ID=@id;
END
select * from ARTICLE
EXEC updateStatusArticle 1,3  

---------------------------------------------------------------------------------------------
--(i.3). Cập nhật kết quả sau phản biện cho một bài báo.
--rejection = 0, minor revision = 1, major revision = 2, acceptance = 3.
CREATE PROCEDURE UpdateResult @ID VARCHAR(15), @Result INT
AS 
UPDATE ARTICLE SET Result = @Result WHERE ID = @ID;

EXEC UpdateResult 0, 1;
EXEC UpdateResult 0, 2;
----------------------------------------------------------------------------------------------
--(i.4). Cập nhật kết quả sau hoàn tất phản biện cho một bài báo.
EXEC UpdateResult 0, 0;
EXEC UpdateResult 0, 3;
----------------------------------------------------------------------------------------------
--i.5.0 Xem danh sách các bài báo theo mỗi loại (nghiên cứu, phản biện sách, tổng quan) hoặc toàn bộ theo mỗi trạng thái xử lý
CREATE PROCEDURE ViewArticleByStatus (@typeArticle VARCHAR(255), @status INT)
AS
BEGIN
	IF @typeArticle = 'RESEARCH' 
		SELECT * FROM RESEARCH WHERE ID IN (SELECT ID FROM ARTICLE WHERE Status = @status)
	IF @typeArticle = 'OVERVIEW'
		SELECT * FROM OVERVIEW WHERE ID IN (SELECT ID FROM ARTICLE WHERE Status = @status)
	IF @typeArticle = 'REVIEW_BOOK'
		SELECT * FROM REVIEW_BOOK WHERE ID IN (SELECT ID FROM ARTICLE WHERE Status = @status)
	IF @typeArticle = 'ARTICLE'
		SELECT * FROM ARTICLE WHERE ID IN (SELECT ID FROM ARTICLE WHERE Status = @status) 
END
EXEC ViewArticleByStatus 'REVIEW_BOOK', 0

----------------------------------------------------------------------------------------------
--(i.5). Xem danh sách các bài báo theo mỗi loại (nghiên cứu, phản biện sách, tổng quan) chưa được xử lý phản biện.
-- FIX
EXEC ViewArticleByStatus 'REVIEW_BOOK', 0
----------------------------------------------------------------------------------------------
--(i.6). Xem danh sách các bài báo theo mỗi loại (nghiên cứu, phản biện sách, tổng quan) được xuất bản.
-- FIX
EXEC ViewArticleByStatus 'REVIEW_BOOK', 3
----------------------------------------------------------------------------------------------
--(i.7.0) Xem danh sách các bài báo theo mỗi loại (nghiên cứu, phản biện sách, tổng quan) hoặc toàn bộ theo mỗi 
-- trạng thái xử lý trong n năm gần nhất.
CREATE PROCEDURE ViewArticleByTypeByYear (@typeArticle VARCHAR(255), @status INT, @n INT)
AS
BEGIN
	IF @typeArticle = 'RESEARCH' 
		SELECT * FROM RESEARCH WHERE ID IN (SELECT ID FROM ARTICLE WHERE Status = @status AND SentDate > DATEADD(year,-@n,GETDATE()))
	IF @typeArticle = 'OVERVIEW'
		SELECT * FROM OVERVIEW WHERE ID IN (SELECT ID FROM ARTICLE WHERE Status = @status AND SentDate > DATEADD(year,-@n,GETDATE()))
	IF @typeArticle = 'REVIEW_BOOK'
		SELECT * FROM REVIEW_BOOK WHERE ID IN (SELECT ID FROM ARTICLE WHERE Status = @status AND SentDate > DATEADD(year,-@n,GETDATE()))
	IF @typeArticle = 'ARTICLE'
		SELECT * FROM ARTICLE WHERE ID IN (SELECT ID FROM ARTICLE WHERE Status = @status AND SentDate > DATEADD(year,-@n,GETDATE()))
END
EXEC ViewArticleByTypeByYear 'REVIEW_BOOK', 3, 3
------------------------------------------------------------------------------------------------------------------
--(i.7). Xem danh sách các bài báo đã đăng theo mỗi loại (nghiên cứu, phản biện sách, tổng quan) trong 3 năm gần nhất.
EXEC ViewArticleByTypeByYear 'REVIEW_BOOK', 3, 3
-----------------------------------------------------------------------------------------------
-- i.8.0 Xem danh sách các bài báo theo mỗi loại (nghiên cứu, phản biện sách, tổng quan) hoặc toàn bộ theo mỗi trạng thái xử lý của một tác giả 
CREATE PROCEDURE ViewArticleByTypeByAuthor (@typeArticle VARCHAR(255), @status INT, @authorSsn INT)
AS
BEGIN
	IF @typeArticle = 'RESEARCH' 
		SELECT * FROM RESEARCH WHERE ID IN (SELECT ID FROM ARTICLE WHERE Status = @status AND AuthorSSn = @authorSsn)
	IF @typeArticle = 'OVERVIEW'
		SELECT * FROM OVERVIEW WHERE ID IN (SELECT ID FROM ARTICLE WHERE Status = @status AND AuthorSSn = @authorSsn)
	IF @typeArticle = 'REVIEW_BOOK'
		SELECT * FROM REVIEW_BOOK WHERE ID IN (SELECT ID FROM ARTICLE WHERE Status = @status AND AuthorSSn = @authorSsn)
	IF @typeArticle = 'ARTICLE'
		SELECT * FROM ARTICLE WHERE ID IN (SELECT ID FROM ARTICLE WHERE Status = @status AND AuthorSSn = @authorSsn)
END
EXEC ViewArticleByTypeByYear 'ARTICLE', 3, 0
-----------------------------------------------------------------------------------------------
--(i.8). Xem danh sách các bài báo được xuất bản của một tác giả.
EXEC ViewArticleByTypeByYear 'ARTICLE', 3, 0
-----------------------------------------------------------------------------------------------
--(i.9). Xem danh sách các bài báo đã đăng của một tác giả.
EXEC ViewArticleByTypeByYear 'ARTICLE', 4, 0
------------------------------------------------------------------------------------------------
--i.10.0 Xem tổng số bài báo theo mỗi loại hoặc toàn bộ theo trạng thái xử lý
CREATE PROCEDURE CountArticleByType(@typeArticle VARCHAR(255), @status INT)
AS
BEGIN
	IF @typeArticle = 'RESEARCH' 
		SELECT COUNT(*) as countResearch FROM RESEARCH WHERE ID IN (SELECT ID FROM ARTICLE WHERE Status = @status)
	IF @typeArticle = 'OVERVIEW'
		SELECT COUNT(*) as countOverview FROM OVERVIEW WHERE ID IN (SELECT ID FROM ARTICLE WHERE Status = @status)
	IF @typeArticle = 'REVIEW_BOOK'
		SELECT COUNT(*) as countReviewBook FROM REVIEW_BOOK WHERE ID IN (SELECT ID FROM ARTICLE WHERE Status = @status) 
	IF @typeArticle = 'ARTICLE'
		SELECT COUNT(*) as countArticle FROM ARTICLE WHERE ID IN (SELECT ID FROM ARTICLE WHERE Status = @status)
END
EXEC CountArticleByType 'ARTICLE', 0
-----------------------------------------------------------------------------------------------
--(i.10). Xem tổng số bài báo đang được phản biện.
EXEC CountArticleByType 'ARTICLE', 0
-----------------------------------------------------------------------------------------------
--(i.11). Xem tổng số bài báo đang được phản hồi phản biện.
EXEC CountArticleByType 'ARTICLE', 1
-----------------------------------------------------------------------------------------------
--(i.12). Xem tổng số bài báo đang được xuất bản.
EXEC CountArticleByType 'ARTICLE', 3

-------------------------------------------------------------------------------------------------------------------------------------------------

--(ii). Phản biện
--(ii.1). Cập nhật thông tin cá nhân.
CREATE PROCEDURE UpdateInformation (@Ssn VARCHAR(15), @Email VARCHAR(100), @Job VARCHAR(255), @Fname VARCHAR(50), @LName VARCHAR(50), @Address TEXT, @WorkPlace VARCHAR(255))
AS
BEGIN
	IF EXISTS(SELECT * FROM SCIENTIST WHERE Ssn = @Ssn)
	   UPDATE SCIENTIST set Email = @Email, Job = @Job, Fname = @Fname, LName = @LName, Address = @Address, WorkPlace = @WorkPlace
	   WHERE Ssn = @Ssn
END
SELECT * FROM SCIENTIST
EXEC UpdateInformation @Ssn = 111111111, @Email = 'abc@gmmail.com', @Job='Teacher', @Fname='Tom', @LName = 'Cruise', @Address = '221B Baker .St', @WorkPlace = 'London' ;
--------------------------------------------------------------------------------------------

--(ii.2). Cập nhật phản biện cho một bài báo.
CREATE PROCEDURE UpdateCriteriaContent (@ID VARCHAR(15), @ReviewContent TEXT)
AS
BEGIN
	IF EXISTS(SELECT * FROM EVALUATE WHERE ArticleID = @ID)
		UPDATE EVALUATE SET ReviewContent = @ReviewContent WHERE ArticleID = @ID;
END
SELECT * FROM EVALUATE
EXEC UpdateCriteriaContent 1,'abcabcabcabc';
---------------------------------------------------------------------------------------------

--(ii.3). Xem danh sách các bài báo theo mỗi loại (nghiên cứu, phản biện sách, tổng quan) mà mình đang phản biện.
CREATE PROCEDURE ViewArticleReviewing (@TypeArticle VARCHAR(255), @ReviewerSsn VARCHAR (15))
AS
BEGIN
	IF @typeArticle = 'RESEARCH' 
		SELECT * FROM ASSIGN JOIN ARTICLE ON ArticleID = ID WHERE ReviewerSsn = @ReviewerSsn AND Status IN (0,1) AND ID IN (SELECT ID FROM RESEARCH)
	IF @typeArticle = 'OVERVIEW'
		SELECT * FROM ASSIGN JOIN ARTICLE ON ArticleID = ID WHERE ReviewerSsn = @ReviewerSsn AND Status IN (0,1) AND ID IN (SELECT ID FROM OVERVIEW)
	IF @typeArticle = 'REVIEW_BOOK'
		SELECT * FROM ASSIGN JOIN ARTICLE ON ArticleID = ID WHERE ReviewerSsn = @ReviewerSsn AND Status IN (0,1) AND ID IN (SELECT ID FROM REVIEW_BOOK)
	IF @typeArticle = 'ARTICLE'
		SELECT * FROM ASSIGN JOIN ARTICLE ON ArticleID = ID WHERE ReviewerSsn = @ReviewerSsn AND Status IN (0,1) AND ID IN (SELECT ID FROM ARTICLE)
END
EXEC ViewArticleReviewing 'RESEARCH', 111111111;
---------------------------------------------------------------------------------------------

--(ii.4). Xem danh sách các bài báo theo mỗi loại (nghiên cứu, phản biện sách, tổng quan) mà mình đã phản biện trong 3 năm gần đây nhất.
CREATE PROCEDURE ViewArticleReviewedIn3Y (@TypeArticle VARCHAR(255), @ReviewerSsn VARCHAR (15))
AS
BEGIN
	IF @typeArticle = 'RESEARCH' 
		SELECT * FROM ASSIGN JOIN ARTICLE ON ArticleID = ID WHERE ReviewerSsn = @ReviewerSsn AND Status = 2 AND AssignDate > DATEADD(year,-3,GETDATE()) AND ID IN (SELECT ID FROM RESEARCH)
	IF @typeArticle = 'OVERVIEW'
		SELECT * FROM ASSIGN JOIN ARTICLE ON ArticleID = ID WHERE ReviewerSsn = @ReviewerSsn AND Status = 2 AND AssignDate > DATEADD(year,-3,GETDATE()) AND ID IN (SELECT ID FROM OVERVIEW)
	IF @typeArticle = 'REVIEW_BOOK'
		SELECT * FROM ASSIGN JOIN ARTICLE ON ArticleID = ID WHERE ReviewerSsn = @ReviewerSsn AND Status = 2 AND AssignDate > DATEADD(year,-3,GETDATE()) AND ID IN (SELECT ID FROM REVIEW_BOOK)
	IF @typeArticle = 'ARTICLE'
		SELECT * FROM ASSIGN JOIN ARTICLE ON ArticleID = ID WHERE ReviewerSsn = @ReviewerSsn AND Status = 2 AND AssignDate > DATEADD(year,-3,GETDATE()) AND ID IN (SELECT ID FROM ARTICLE)
END
EXEC ViewArticleReviewedIn3Y 'RESEARCH', 111111111;
---------------------------------------------------------------------------------------------

--(ii.5). Xem danh sách các bài báo của một tác giả mà mình đang phản biện.
CREATE PROCEDURE ViewArticleOfAuthorReviewing (@ReviewerSsn VARCHAR (15))
AS
SELECT * FROM ARTICLE WHERE AuthorSSn IN (SELECT AuthorSSn FROM ASSIGN JOIN ARTICLE ON ArticleID = ID WHERE ReviewerSsn = @ReviewerSsn AND Status IN (0,2))
EXEC ViewArticleOfAuthorReviewing 111111111;
---------------------------------------------------------------------------------------------

--(ii.6). Xem danh sách các bài báo của một tác giả mà mình đã phản biện trong 3 năm gần đây nhất.
CREATE PROCEDURE ViewArticleOfAuthorReviewingIn3Y (@ReviewerSsn VARCHAR (15))
AS
SELECT * FROM ARTICLE WHERE AuthorSSn IN (SELECT AuthorSSn FROM ASSIGN JOIN ARTICLE ON ArticleID = ID WHERE ReviewerSsn = @ReviewerSsn AND Status = 2 AND AssignDate > DATEADD(year,-3,GETDATE()))
EXEC ViewArticleOfAuthorReviewingIn3Y 111111111;
---------------------------------------------------------------------------------------------

--(ii.7). Xem danh sách tác giả có nhiều bài báo nhất mà mình đã phản biện.
CREATE PROCEDURE getXListTopAuthorReviewed (@reviewssn VARCHAR(15))
AS
BEGIN
	WITH numArticleAndAuthorReviewed
	AS
	(
		SELECT WRITE.Ssn ,COUNT(*)NumOfArtile
		FROM ASSIGN JOIN WRITE ON ASSIGN.ArticleID= WRITE.ID
		WHERE ASSIGN.ReviewerSsn=@reviewssn
		GROUP BY WRITE.Ssn
	)

	SELECT Ssn, NumOfArtile
	FROM numArticleAndAuthorReviewed
	WHERE NumOfArtile IN (SELECT MAX(NumOfArtile)
						  FROM numArticleAndAuthorReviewed)
END
EXEC getXListTopAuthorReviewed @reviewssn='1';

---------------------------------------------------------------------------------------------

--(ii.8). Xem kết quả phản biện của các bài báo mà mình đã phản biện trong năm nay.
CREATE PROCEDURE ViewResultArticleReviewed (@ReviewerSsn VARCHAR (15))
AS
SELECT Result FROM EVALUATE JOIN ARTICLE ON ID = ArticleID WHERE ReviewerSsn = @ReviewerSsn
EXEC ViewResultArticleReviewed 111111111;
---------------------------------------------------------------------------------------------

--(ii.9). Xem 3 năm có số bài báo mà mình đã phản biện nhiều nhất.
CREATE PROCEDURE get3YearsHaveTopArticleReviewed(@reviewssn VARCHAR(15))
AS
BEGIN
	SELECT TOP(3) *
	FROM (
		SELECT DATEPART(YEAR,AssignDate)Year, COUNT(*)NumberOfArticle
		FROM ASSIGN
		WHERE ReviewerSsn=@reviewssn
		GROUP BY DATEPART(YEAR, AssignDate)
		) AS NumOfArc Order by NumberOfArticle desc
END
EXEC get3YearsHaveTopArticleReviewed @reviewssn='1';

---------------------------------------------------------------------------------------------

--(ii.10). Xem 3 bài báo mà mình đã phản biện có kết quả tốt nhất (acceptance).
CREATE PROCEDURE ViewArticleReviewedBestResult (@ReviewerSsn VARCHAR (15))
AS
SELECT TOP 3 * FROM ARTICLE WHERE ID IN (SELECT ArticleID FROM EVALUATE WHERE Result = '3' AND ReviewerSsn = @ReviewerSsn)
EXEC ViewArticleReviewedBestResult 111111111;
---------------------------------------------------------------------------------------------

--(ii.11). Xem 3 bài báo mà mình đã phản biện có kết quả thấp nhất (rejection).
CREATE PROCEDURE ViewArticleReviewedWorstResult (@ReviewerSsn VARCHAR (15))
AS
SELECT TOP 3 * FROM ARTICLE WHERE ID IN (SELECT ArticleID FROM EVALUATE WHERE Result = '0' AND ReviewerSsn = @ReviewerSsn)
EXEC ViewArticleReviewedWorstResult 111111111;
---------------------------------------------------------------------------------------------

--(ii.12). Xem trung bình số bài báo mỗi năm mà mình đã phản biện trong 5 năm gần đây nhất.

CREATE PROCEDURE getNumOfArticleReviewedin5Years (@reviewssn VARCHAR(15))
AS
BEGIN
	SELECT AVG(NumberOfArticle)AvgArticleReviwedin5Year
	FROM (
			SELECT DATEPART(YEAR,AssignDate)Year, COUNT(*)NumberOfArticle 
			FROM ASSIGN
			WHERE ReviewerSsn=@reviewssn AND AssignDate > DATEADD(year,-5,GETDATE())
			GROUP BY DATEPART(YEAR, AssignDate)
	) as NumOfArc;
	
END
EXEC getNumOfArticleReviewedin5Years @reviewssn = '1';

---------------------------------------------------------------------------------------------------------------------------------

-- (iii). Tác giả liên lạc
-- (iii.1). Cập nhật thông tin cá nhân.
CREATE PROCEDURE updateProfile (@ssn VARCHAR(15), @email VARCHAR(100),  @job VARCHAR(255), @fname VARCHAR(50), @lname VARCHAR(50), @address TEXT, @workplace VARCHAR(255), @field VARCHAR(15))
AS
BEGIN
	UPDATE SCIENTIST SET Email=@email, Job=@job, Fname=@fname, LName = @lname, Address = @address, WorkPlace = @workplace
	WHERE Ssn = @ssn;
	UPDATE FIELD SET FieldID=@field
	WHERE Ssn = @ssn;
END
EXEC updateProfile @ssn='12', @email='evans@gmmail.com', @job='Streamer', @fname='Lewandoski', @lname = 'Uzumaki', @address = '127 East 55th Street, Midtown East, New York, US', @WorkPlace = 'NK Company', @field='Music';

-- (iii.2). Cập nhật thông tin của một bài báo đang được nộp.

CREATE PROCEDURE updateArticle (@id VARCHAR(15), @title TEXT, @summary TEXT, @articlefile VARCHAR(255))
AS
BEGIN
	UPDATE ARTICLE SET Title=@title,Summary=@summary ,ArticleFile=@articlefile 
	WHERE ID = @id;
END
EXEC updateArticle @id='3', @title='Road to Ninja', @summary='Naruto and the leaf ninja drive off a group of White Zetsu posing as fallen Akatsuki members', @articlefile='RoadToNinja.pdf';

-- (iii.3). Xem thông tin các tác giả của một bài báo.
CREATE PROCEDURE getAuthorInfoOfArticle(@id VARCHAR(15))
AS
BEGIN
	SELECT *
	FROM SCIENTIST JOIN FIELD ON SCIENTIST.Ssn = FIELD.Ssn
	WHERE SCIENTIST.Ssn = (SELECT Ssn
				 FROM WRITE
				 WHERE ID=@id)
END
EXEC getAuthorInfoOfArticle @id='8';

-- (iii.4). Xem trạng thái của một bài báo

CREATE PROCEDURE getStatusofArticle(@id  VARCHAR(15))
AS
BEGIN
	SELECT ID, Title, Status
	FROM ARTICLE
	WHERE ID=@id
END
EXEC getStatusofArticle @id='3';

-- (iii.5). Xem kết quả phản biện của một bài báo.

CREATE PROCEDURE getResultofArticle (@id VARCHAR(15))
AS
BEGIN
	SELECT ArticleID, NoteForAU, Result
	FROM EVALUATE JOIN ARTICLE ON ID = ArticleID
	WHERE ArticleID=@id 
END
EXEC getResultofArticle @id='7';
-- (iii.6). Xem danh sách các bài báo trong một năm.

CREATE PROCEDURE getListArticle(@ssn VARCHAR(15))
AS
BEGIN
	SELECT ID, Title, SentDate
	FROM ARTICLE
	WHERE AuthorSSn=@ssn AND SentDate > DATEADD(year,-1,GETDATE())
END
EXEC getListArticle @ssn = '0';
-- (iii.7). Xem danh sách các bài báo đã đăng trong một năm.

CREATE PROCEDURE getListArticleAccepted(@ssn VARCHAR(15))
AS
BEGIN
	SELECT * 
	FROM ARTICLE 
	WHERE Result = '4' AND SentDate > DATEADD(year,-1,GETDATE()) AND AuthorSSn=@ssn
END
EXEC getListArticleAccepted @ssn = '0';

-- (iii.8). Xem danh sách các bài báo đang được xuất bản.

CREATE PROCEDURE getListArticlePublishing(@ssn VARCHAR(15))
AS
BEGIN
	SELECT * 
	FROM ARTICLE 
	WHERE Status = 3 AND AuthorSSn=@ssn
END
EXEC getListArticlePublishing @ssn = '0';

-- (iii.9). Xem danh sách các bài báo có kết quả thấp nhất (rejection).

CREATE PROCEDURE getListArticleRejected(@ssn VARCHAR(15))
AS
BEGIN
	SELECT ArticleID, NoteForAU, Result
	FROM EVALUATE JOIN ARTICLE ON ID = ArticleID
	WHERE Result='0'
	AND ArticleID IN (SELECT ID 
					  FROM ARTICLE
					  WHERE AuthorSSn=@ssn)
END
EXEC getListArticleRejected @ssn='2';

-- (iii.10). Xem tổng số bài báo đã gởi tạp chí mỗi năm trong 5 năm gần đây nhất.
CREATE PROCEDURE getNumArticleIn5Years(@ssn VARCHAR(15))
AS
BEGIN
	SELECT DATEPART(YEAR,SentDate)Year, COUNT(*)NumberOfArticle
	FROM ARTICLE
	WHERE AuthorSSn=@ssn AND SentDate > DATEADD(year,-5,GETDATE())
	GROUP BY DATEPART(YEAR,SentDate)
	ORDER BY DATEPART(YEAR,SentDate) DESC
END
EXEC getNumArticleIn5Years @ssn='2';

-- (iii.11). Xem tổng số bài báo nghiên cứu được đăng mỗi năm trong 5 năm gần đây nhất.
CREATE PROCEDURE getListResearchArticleAcceptedIn5Years(@ssn VARCHAR(15))
AS
BEGIN
	SELECT DATEPART(YEAR,SentDate)Year, COUNT(*)NumberOfArticle
	FROM ARTICLE
	WHERE AuthorSSn=@ssn AND Status='4' AND SentDate > DATEADD(year,-5,GETDATE()) AND ID IN (SELECT ID FROM RESEARCH)
	GROUP BY DATEPART(YEAR,SentDate)
	ORDER BY DATEPART(YEAR,SentDate) DESC
END
EXEC getListResearchArticleAcceptedIn5Years @ssn='2';
-- (iii.12). Xem tổng số bài báo tổng quan được đăng mỗi năm trong 5 năm gần đây nhất.
CREATE PROCEDURE getListOverviewArticleAcceptedIn5Years(@ssn VARCHAR(15))
AS
BEGIN
	SELECT DATEPART(YEAR,SentDate)Year, COUNT(*)NumberOfArticle
	FROM ARTICLE
	WHERE AuthorSSn=@ssn AND Status='4' AND SentDate > DATEADD(year,-5,GETDATE()) AND ID IN (SELECT ID FROM OVERVIEW)
	GROUP BY DATEPART(YEAR,SentDate)
	ORDER BY DATEPART(YEAR,SentDate) DESC
END
EXEC getListOverviewArticleAcceptedIn5Years @ssn='2';