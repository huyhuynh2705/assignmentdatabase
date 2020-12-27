-----------------------------------------------
-- ALL
CREATE PROCEDURE GetAuthorWriteArticle
AS
BEGIN
	Select * 
	from SCIENTIST
	Where Ssn in (Select Ssn from WRITE )
END
GO

------ Reviewer -------------------------------

---- Cập nhật thông tin Reviewer
GO
CREATE PROCEDURE UpdateInformation (@Ssn VARCHAR(15), @Email VARCHAR(100), @Job VARCHAR(255), @Fname VARCHAR(50), @LName VARCHAR(50), @Address TEXT, @WorkPlace VARCHAR(255))
AS
BEGIN
	IF EXISTS(SELECT * FROM SCIENTIST WHERE Ssn = @Ssn)
	BEGIN
	   UPDATE SCIENTIST set Email = @Email, Job = @Job, Fname = @Fname, LName = @LName, Address = @Address, WorkPlace = @WorkPlace
	   WHERE Ssn = @Ssn
	END

END
GO

--- Cập nhật phản biện cho một bài báo.
CREATE PROCEDURE UpdateCriteriaReviewer (@ReviewerSsn VARCHAR(15), @ID VARCHAR(15), @Criteria VARCHAR(15), @ReviewContent Text, @NoteForEB Text, @NoteForAU Text)
AS
BEGIN
	IF EXISTS(SELECT * FROM EVALUATE WHERE ArticleID = @ID AND ReviewerSsn = @ReviewerSsn AND CriteriaID = @Criteria)
		UPDATE EVALUATE 
		SET
			ReviewContent = @ReviewContent,
			NoteForEB = @NoteForEB,
			NoteForAU = @NoteForAU,
			DateEval = GETDATE()
		WHERE ArticleID = @ID AND ReviewerSsn = @ReviewerSsn AND CriteriaID = @Criteria
	ELSE
	INSERT INTO EVALUATE
	VALUES(
	@ReviewerSsn,
	@ID,
	@Criteria,
	@ReviewContent,
	@NoteForEB,
	@NoteForAU,
	GETDATE()
	)
END
GO

-----------------------------------------------------------
CREATE PROCEDURE GetArticleMyReview (@ReviewerSsn VARCHAR (15))
AS
BEGIN
	SELECT ARTICLE.ID, Title, Summary, ArticleFile, Status, SentDate, AuthorSSn, ARTICLE.EditorialBoardSsn, Result, Detail, AnnoucementDate
	FROM ASSIGN JOIN ARTICLE ON ArticleID = ID 
	WHERE ReviewerSsn = @ReviewerSsn AND ID IN (SELECT ID FROM ARTICLE)	
END
GO

-----------------------------------------------------------

CREATE PROCEDURE getXListTopAuthorReviewed1 (@reviewssn VARCHAR(15))
AS
BEGIN
	WITH numArticleAndAuthorReviewed
	AS
	(
		SELECT WRITE.Ssn ,COUNT(*)NumOfArticle
		FROM ASSIGN JOIN WRITE ON ASSIGN.ArticleID= WRITE.ID
		WHERE ASSIGN.ReviewerSsn=@reviewssn
		GROUP BY WRITE.Ssn
	)

	SELECT SCIENTIST.Ssn, Email, Job, Fname, LName, Address, WorkPlace
	FROM numArticleAndAuthorReviewed JOIN SCIENTIST ON numArticleAndAuthorReviewed.Ssn = SCIENTIST.Ssn
	WHERE NumOfArticle IN (SELECT MAX(NumOfArticle)
						  FROM numArticleAndAuthorReviewed)
END
GO

CREATE PROCEDURE ViewResultArticleReviewed (@ReviewerSsn VARCHAR (15))
AS
SELECT Result,ID FROM EVALUATE JOIN ARTICLE ON ID = ArticleID WHERE ReviewerSsn = @ReviewerSsn
GO
-----------------------------------------------------------
-- AUTHOR -----------------------------------------------
CREATE PROCEDURE GetArticleMyWrite(@AuthorSsn VARCHAR(15))
AS
BEGIN
	Select * 
	from ARTICLE
	Where ID in (Select ID from WRITE Where Ssn = @AuthorSSn )
END
GO

-----------------------------------------------------------

----- EDITORIAL BOARD --------------------------------

------------------------------------------------------
CREATE PROCEDURE UpdateStatusArticle (@status INT, @id VARCHAR(15))
AS
BEGIN
	UPDATE ARTICLE SET Status = @status WHERE ID=@id;
END
GO
-----------------------------------------------------------
CREATE PROCEDURE UpdateResult (@ID VARCHAR(15), @Result INT)
AS 
	UPDATE ARTICLE SET Result = @Result WHERE ID = @ID;
GO
-----------------------------------------------------------
CREATE PROCEDURE GetAuthorInforOfArticle(@id VARCHAR(15))
AS
BEGIN
	SELECT *
	FROM SCIENTIST JOIN FIELD ON SCIENTIST.Ssn = FIELD.Ssn
	WHERE SCIENTIST.Ssn IN (SELECT Ssn
				 FROM WRITE
				 WHERE ID=@id)
END
GO




