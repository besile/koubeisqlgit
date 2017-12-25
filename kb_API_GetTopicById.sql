SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<zhangzhenxing>
-- Create date: <2017-07-13>
-- Description:	<根据口碑ID获取口碑>
-- =============================================
ALTER PROCEDURE [dbo].[kb_API_GetTopicById] @TopicId INT
AS 
    BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
        SET NOCOUNT ON ;

        SELECT  A.id ,
                A.[Guid] ,
                A.[title] ,
                A.[user_id] ,
                A.[username] ,
                A.[user_type] ,
                A.[created_at] ,
                A.[posts_count] ,
                A.[model_id] ,
                CC.[cs_ShowName] ,
                CC.[csAllSpell] ,
                CC.[bs_Id] ,
                CC.[bs_Name] ,
                ISNULL(A.[trim_id], 0) AS trim_id ,
                A.[views_count] ,
                A.[rating_value] ,
                A.haowen_votes ,
                ISNULL(C.name, N'') AS trimName ,
                ISNULL(CAST(C.year_type AS NVARCHAR(8)), N'') AS trimYear ,
                ISNULL(C.fuel_type, N'') AS fueltype ,
                A.userip ,
                ISNULL(A.purchase_date, N'') AS purchase_date ,
                ISNULL(A.purchase_price, 0) AS purchase_price ,
                ISNULL(A.qianggao_votes, 0) AS mileage ,
                ISNULL(A.leiren_votes, 0) AS fee ,
                ISNULL(A.fuel_value, 0) AS fuel_value ,
                ISNULL(D.ParentCityId, 0) AS ParentCityId , --经销商省Id
                ISNULL(E.Name, N'') AS ParentCityName , --经销商省名称
                A.[image_id] , --经销商市Id
                ISNULL(D.CityName, N'') AS CityName , --经销商市名称
                A.[dealerId] , --经销商Id
                A.[dealerName] , --经销商名称
                A.[category] ,
                A.[datatype] ,
                ISNULL(A.positive_votes, 0) AS positive_votes ,
                ISNULL(A.negative_votes, 0) AS negative_votes
        FROM    dbo.topics AS A WITH ( NOLOCK )
                LEFT JOIN dbo.trims AS C WITH ( NOLOCK ) ON A.trim_id = C.id
                LEFT JOIN dbo.dim_Place AS D WITH ( NOLOCK ) ON A.image_id = D.CityId
                LEFT JOIN dbo.dim_Province AS E WITH ( NOLOCK ) ON D.ParentCityId = E.UnionId
                LEFT JOIN dbo.v_com_SerialBase AS CC WITH ( NOLOCK ) ON A.model_id = CC.cs_Id
        WHERE   A.id = @TopicId ;
        
        SELECT  [Topicid] ,
                [Title] ,
                [Content] ,
                [Rating] ,
                [CategoryId]
        FROM    dbo.topics_detail WITH ( NOLOCK )
        WHERE   Id IN ( SELECT  [Id]
                        FROM    dbo.topics_detail WITH ( NOLOCK )
                        WHERE   Topicid = @TopicId
                                AND [Status] = 1 ) ;
        
        SELECT  [Topicid] ,
                [ImagePath] ,
                [ImageName]
        FROM    dbo.topics_image WITH ( NOLOCK )
        WHERE   Id IN ( SELECT  [Id]
                        FROM    dbo.topics_image WITH ( NOLOCK )
                        WHERE   Topicid = @TopicId
                                AND [Status] = 1 ) ;
                               
        SELECT  [Content] ,
                ISNULL([BadContent], N'') AS [BadContent] ,
                ISNULL([GoodContent], N'') AS [GoodContent]
        FROM    dbo.topics_comment WITH ( NOLOCK )
        WHERE   Id IN ( SELECT  Id
                        FROM    dbo.topics_comment WITH ( NOLOCK )
                        WHERE   Topicid = @TopicId
                                AND [Status] = 1 ) ;
        
    END ;
GO
