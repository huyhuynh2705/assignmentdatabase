--- EDITORIALBOARD
CREATE ROLE EDITORIALBOARD;

GRANT SELECT, UPDATE ON ARTICLE TO EDITORIALBOARD;
GRANT SELECT ON RESEARCH TO EDITORIALBOARD;
GRANT SELECT ON REVIEWER TO EDITORIALBOARD;
GRANT SELECT ON EDITORIAL_BOARD TO EDITORIALBOARD;
GRANT SELECT ON OVERVIEW TO EDITORIALBOARD;
GRANT SELECT ON REVIEW_BOOK TO EDITORIALBOARD;
GRANT SELECT, INSERT, UPDATE ON CRITERIA TO EDITORIALBOARD;
GRANT SELECT, INSERT, DELETE, UPDATE ON ASSIGN TO EDITORIALBOARD;

GRANT EXECUTE ON OBJECT::UpdateStatusArticle TO EDITORIALBOARD; 
GRANT EXECUTE ON OBJECT::UpdateResult TO EDITORIALBOARD;  
GRANT EXECUTE ON OBJECT::GetAuthorInforOfArticle TO EDITORIALBOARD;  
GRANT EXECUTE ON OBJECT::GetAuthorWriteArticle TO EDITORIALBOARD; 

REVOKE SELECT, UPDATE ON ARTICLE TO EDITORIALBOARD;
REVOKE SELECT ON RESEARCH TO EDITORIALBOARD;
REVOKE SELECT ON OVERVIEW TO EDITORIALBOARD;
REVOKE SELECT ON REVIEW_BOOK TO EDITORIALBOARD;
REVOKE SELECT, INSERT, UPDATE ON CRITERIA TO EDITORIALBOARD;
REVOKE SELECT, INSERT, DELETE, UPDATE ON ASSIGN TO EDITORIALBOARD;

REVOKE EXECUTE ON OBJECT::UpdateStatusArticle TO EDITORIALBOARD; 
REVOKE EXECUTE ON OBJECT::UpdateResult TO EDITORIALBOARD;  
REVOKE EXECUTE ON OBJECT::GetAuthorInforOfArticle TO EDITORIALBOARD;  
REVOKE EXECUTE ON OBJECT::GetAuthorWriteArticle TO EDITORIALBOARD;  
  
CREATE LOGIN eb1 WITH PASSWORD = '123456';
CREATE USER eb1 FOR LOGIN eb1;
EXEC sp_addrolemember 'EDITORIALBOARD', 'eb1'; 

DROP ROLE EDITORIALBOARD;
DROP LOGIN eb1;
DROP USER eb1;

--- REVIEWER

CREATE ROLE REVIEWER;

GRANT SELECT ON ARTICLE TO REVIEWER;
GRANT SELECT ON RESEARCH TO REVIEWER;
GRANT SELECT ON OVERVIEW TO REVIEWER;
GRANT SELECT ON REVIEW_BOOK TO REVIEWER;
GRANT SELECT ON ASSIGN TO REVIEWER;
GRANT SELECT, INSERT, DELETE, UPDATE ON EVALUATE TO REVIEWER;
GRANT SELECT, INSERT, DELETE, UPDATE ON SCIENTIST TO REVIEWER;
GRANT SELECT, UPDATE ON FIELD TO REVIEWER;

GRANT EXECUTE ON OBJECT::UpdateInformation TO REVIEWER; 
GRANT EXECUTE ON OBJECT::UpdateCriteriaReviewer TO REVIEWER;  
GRANT EXECUTE ON OBJECT::GetArticleMyReview TO REVIEWER;  
GRANT EXECUTE ON OBJECT::UpdateInformation TO REVIEWER; 
GRANT EXECUTE ON OBJECT::UpdateCriteriaReviewer TO REVIEWER;  
GRANT EXECUTE ON OBJECT::GetArticleMyReview TO REVIEWER;
GRANT EXECUTE ON OBJECT::GetAuthorWriteArticle TO REVIEWER;
GRANT EXECUTE ON OBJECT::getXListTopAuthorReviewed1 TO REVIEWER;
GRANT EXECUTE ON OBJECT::GetArticleMyReview TO REVIEWER;
GRANT EXECUTE ON OBJECT::ViewResultArticleReviewed TO REVIEWER;


REVOKE SELECT ON ARTICLE TO REVIEWER;
REVOKE SELECT ON RESEARCH TO REVIEWER;
REVOKE SELECT ON OVERVIEW TO REVIEWER;
REVOKE SELECT ON REVIEW_BOOK TO REVIEWER;
REVOKE SELECT ON ASSIGN TO REVIEWER;
REVOKE SELECT, INSERT, DELETE, UPDATE ON EVALUATE TO REVIEWER;
REVOKE SELECT, INSERT, DELETE, UPDATE ON SCIENTIST TO REVIEWER;
REVOKE SELECT, UPDATE ON FIELD TO REVIEWER;

REVOKE EXECUTE ON OBJECT::UpdateInformation TO REVIEWER; 
REVOKE EXECUTE ON OBJECT::UpdateCriteriaReviewer TO REVIEWER;  
REVOKE EXECUTE ON OBJECT::GetArticleMyReview TO REVIEWER;  
REVOKE EXECUTE ON OBJECT::UpdateInformation TO REVIEWER; 
REVOKE EXECUTE ON OBJECT::UpdateCriteriaReviewer TO REVIEWER;  
REVOKE EXECUTE ON OBJECT::GetArticleMyReview TO REVIEWER;
REVOKE EXECUTE ON OBJECT::GetAuthorWriteArticle TO REVIEWER;
REVOKE EXECUTE ON OBJECT::getXListTopAuthorReviewed1 TO REVIEWER;
REVOKE EXECUTE ON OBJECT::GetArticleMyReview TO REVIEWER;
REVOKE EXECUTE ON OBJECT::ViewResultArticleReviewed TO REVIEWER;  

CREATE LOGIN rv1 WITH PASSWORD = '123456';
CREATE USER rv1 FOR LOGIN rv1;
EXEC sp_addrolemember 'REVIEWER', 'rv1';

DROP ROLE REVIEWER;
DROP LOGIN rv1;
DROP USER rv1;

--- AUTHOR CONTACT

CREATE ROLE AUTHORCON;

GRANT SELECT, INSERT, DELETE, UPDATE ON SCIENTIST TO AUTHORCON;
GRANT SELECT, INSERT, DELETE, UPDATE ON ARTICLE TO AUTHORCON;
GRANT SELECT, INSERT, UPDATE ON RESEARCH TO AUTHORCON;
GRANT SELECT, INSERT, UPDATE ON OVERVIEW TO AUTHORCON;
GRANT SELECT, INSERT, UPDATE ON REVIEW_BOOK TO AUTHORCON;
GRANT SELECT, INSERT, UPDATE ON WRITE TO AUTHORCON;
GRANT SELECT ON EVALUATE TO AUTHORCON;
GRANT SELECT, INSERT, DELETE, UPDATE ON FIELD TO AUTHORCON;
  
GRANT EXECUTE ON OBJECT::getAuthorInfoOfArticle TO AUTHORCON;  
GRANT EXECUTE ON OBJECT::GetArticleMyWrite TO AUTHORCON;  
GRANT EXECUTE ON OBJECT::GetAuthorWriteArticle TO AUTHORCON;  

REVOKE SELECT, INSERT, DELETE, UPDATE ON SCIENTIST TO AUTHORCON;
REVOKE SELECT, INSERT, DELETE, UPDATE ON ARTICLE TO AUTHORCON;
REVOKE SELECT, INSERT, UPDATE ON RESEARCH TO AUTHORCON;
REVOKE SELECT, INSERT, UPDATE ON OVERVIEW TO AUTHORCON;
REVOKE SELECT, INSERT, UPDATE ON REVIEW_BOOK TO AUTHORCON;
REVOKE SELECT, INSERT, UPDATE ON WRITE TO AUTHORCON;
REVOKE SELECT ON EVALUATE TO AUTHORCON;
REVOKE SELECT, INSERT, DELETE, UPDATE ON FIELD TO AUTHORCON;

REVOKE EXECUTE ON OBJECT::getAuthorInfoOfArticle TO AUTHORCON;  
REVOKE EXECUTE ON OBJECT::GetArticleMyWrite TO AUTHORCON;  
REVOKE EXECUTE ON OBJECT::GetAuthorWriteArticle TO AUTHORCON; 

CREATE LOGIN auc1 WITH PASSWORD = '123456';
CREATE USER auc1 FOR LOGIN auc1;
EXEC sp_addrolemember 'AUTHORCON', 'auc1';

DROP ROLE AUTHORCON;
DROP LOGIN auc1;
DROP USER auc1;