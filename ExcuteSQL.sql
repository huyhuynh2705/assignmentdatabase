USE PUBLICATION;



-------------------------------------------------------------------------------------------
--(i). Ban biên tập
--(i.1). Cập nhật phân công phản biện cho một bài báo.
select * from ARTICLE
select * from REVIEWER
select * from EDITORIAL_BOARD
EXEC updateAssign 2,4,1,'2020-11-20' 
--------------------------------------------------------------------------------------------
--(i.2). Cập nhật trạng thái xử lý cho một bài báo: 
-- phản biện = 0, phản hồi phản biện = 1, hoàn tất phản biện = 2, xuất bản = 3, đã đăng = 4.
EXEC updateStatusArticle 1,3  
---------------------------------------------------------------------------------------------
--(i.3). Cập nhật kết quả sau phản biện cho một bài báo.
--rejection = 0, minor revision = 1, major revision = 2, acceptance = 3.
EXEC UpdateResult 0, 1;
EXEC UpdateResult 0, 2;
----------------------------------------------------------------------------------------------
--(i.4). Cập nhật kết quả sau hoàn tất phản biện cho một bài báo.
EXEC UpdateResult 0, 0;
EXEC UpdateResult 0, 3;
----------------------------------------------------------------------------------------------
--i.5.0 Xem danh sách các bài báo theo mỗi loại (nghiên cứu, phản biện sách, tổng quan) hoặc toàn bộ theo mỗi trạng thái xử lý
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
--EXEC ViewArticleByTypeByYear 'REVIEW_BOOK', 3, 3
------------------------------------------------------------------------------------------------------------------
--(i.7). Xem danh sách các bài báo đã đăng theo mỗi loại (nghiên cứu, phản biện sách, tổng quan) trong 3 năm gần nhất.
EXEC ViewArticleByTypeByYear 'REVIEW_BOOK', 3, 3
-----------------------------------------------------------------------------------------------
-- i.8.0 Xem danh sách các bài báo theo mỗi loại (nghiên cứu, phản biện sách, tổng quan) hoặc toàn bộ theo mỗi trạng thái xử lý của một tác giả 
EXEC ViewArticleByTypeByYear 'ARTICLE', 3, 0
-----------------------------------------------------------------------------------------------
--(i.8). Xem danh sách các bài báo được xuất bản của một tác giả.
EXEC ViewArticleByTypeByYear 'ARTICLE', 3, 0
-----------------------------------------------------------------------------------------------
--(i.9). Xem danh sách các bài báo đã đăng của một tác giả.
EXEC ViewArticleByTypeByYear 'ARTICLE', 4, 0
------------------------------------------------------------------------------------------------
--i.10.0 Xem tổng số bài báo theo mỗi loại hoặc toàn bộ theo trạng thái xử lý
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
EXEC UpdateInformation @Ssn = 111111111, @Email = 'abc@gmmail.com', @Job='Teacher', @Fname='Tom', @LName = 'Cruise', @Address = '221B Baker .St', @WorkPlace = 'London' ;
--------------------------------------------------------------------------------------------

--(ii.2). Cập nhật phản biện cho một bài báo.
EXEC UpdateCriteriaContent 1,'abcabcabcabc';
---------------------------------------------------------------------------------------------

--(ii.3). Xem danh sách các bài báo theo mỗi loại (nghiên cứu, phản biện sách, tổng quan) mà mình đang phản biện.
EXEC ViewArticleReviewing 'RESEARCH', 111111111;
---------------------------------------------------------------------------------------------

--(ii.4). Xem danh sách các bài báo theo mỗi loại (nghiên cứu, phản biện sách, tổng quan) mà mình đã phản biện trong 3 năm gần đây nhất.
EXEC ViewArticleReviewedIn3Y 'RESEARCH', 111111111;
---------------------------------------------------------------------------------------------

--(ii.5). Xem danh sách các bài báo của một tác giả mà mình đang phản biện.
EXEC ViewArticleOfAuthorReviewing 111111111;
---------------------------------------------------------------------------------------------

--(ii.6). Xem danh sách các bài báo của một tác giả mà mình đã phản biện trong 3 năm gần đây nhất.
EXEC ViewArticleOfAuthorReviewingIn3Y 111111111;
---------------------------------------------------------------------------------------------

--(ii.7). Xem danh sách tác giả có nhiều bài báo nhất mà mình đã phản biện.
EXEC getXListTopAuthorReviewed @reviewssn='1';

---------------------------------------------------------------------------------------------

--(ii.8). Xem kết quả phản biện của các bài báo mà mình đã phản biện trong năm nay.
EXEC ViewResultArticleReviewed 111111111;
---------------------------------------------------------------------------------------------

--(ii.9). Xem 3 năm có số bài báo mà mình đã phản biện nhiều nhất.
EXEC get3YearsHaveTopArticleReviewed @reviewssn='1';

---------------------------------------------------------------------------------------------

--(ii.10). Xem 3 bài báo mà mình đã phản biện có kết quả tốt nhất (acceptance).
EXEC ViewArticleReviewedBestResult 111111111;
---------------------------------------------------------------------------------------------

--(ii.11). Xem 3 bài báo mà mình đã phản biện có kết quả thấp nhất (rejection).
EXEC ViewArticleReviewedWorstResult 111111111;
---------------------------------------------------------------------------------------------

--(ii.12). Xem trung bình số bài báo mỗi năm mà mình đã phản biện trong 5 năm gần đây nhất.

EXEC getNumOfArticleReviewedin5Years @reviewssn = '1';

---------------------------------------------------------------------------------------------------------------------------------

-- (iii). Tác giả liên lạc
-- (iii.1). Cập nhật thông tin cá nhân.
EXEC updateProfile @ssn='12', @email='evans@gmmail.com', @job='Streamer', @fname='Lewandoski', @lname = 'Uzumaki', @address = '127 East 55th Street, Midtown East, New York, US', @WorkPlace = 'NK Company', @field='Music';

-- (iii.2). Cập nhật thông tin của một bài báo đang được nộp.

EXEC updateArticle @id='3', @title='Road to Ninja', @summary='Naruto and the leaf ninja drive off a group of White Zetsu posing as fallen Akatsuki members', @articlefile='RoadToNinja.pdf';

-- (iii.3). Xem thông tin các tác giả của một bài báo.
EXEC getAuthorInfoOfArticle @id='8';

-- (iii.4). Xem trạng thái của một bài báo

EXEC getStatusofArticle @id='3';

-- (iii.5). Xem kết quả phản biện của một bài báo.

EXEC getResultofArticle @id='7';
-- (iii.6). Xem danh sách các bài báo trong một năm.

EXEC getListArticle @ssn = '0';
-- (iii.7). Xem danh sách các bài báo đã đăng trong một năm.

EXEC getListArticleAccepted @ssn = '0';

-- (iii.8). Xem danh sách các bài báo đang được xuất bản.

EXEC getListArticlePublishing @ssn = '0';

-- (iii.9). Xem danh sách các bài báo có kết quả thấp nhất (rejection).

EXEC getListArticleRejected @ssn='2';

-- (iii.10). Xem tổng số bài báo đã gởi tạp chí mỗi năm trong 5 năm gần đây nhất.
EXEC getNumArticleIn5Years @ssn='2';

-- (iii.11). Xem tổng số bài báo nghiên cứu được đăng mỗi năm trong 5 năm gần đây nhất.
EXEC getListResearchArticleAcceptedIn5Years @ssn='2';
-- (iii.12). Xem tổng số bài báo tổng quan được đăng mỗi năm trong 5 năm gần đây nhất.
EXEC getListOverviewArticleAcceptedIn5Years @ssn='2';