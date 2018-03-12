IF NOT EXISTS (SELECT schema_name 
    FROM information_schema.schemata 
    WHERE schema_name = 'b2b' )
BEGIN
    EXEC sp_executesql N'CREATE SCHEMA b2b;';
END


IF EXISTS (
	select 1 from sys.procedures sp 
	where schema_name(sp.schema_id) = 'b2b' and name = 'GetArticleInformation')
BEGIN
	DROP PROCEDURE [b2b].[GetArticleInformation]
END
GO

IF EXISTS (
	select 1 from sys.procedures sp 
	where schema_name(sp.schema_id) = 'b2b' and name = 'GetArticleImages')
BEGIN
	DROP PROCEDURE [b2b].[GetArticleImages]
END
GO

IF EXISTS (
	select 1 from sys.procedures sp 
	where schema_name(sp.schema_id) = 'b2b' and name = 'GetArticleAttributes')
BEGIN
	DROP PROCEDURE [b2b].[GetArticleAttributes]
END
GO


-- =============================================
-- Author:		Amit
-- Create date: 17/07/2017
-- Description:	Get article information for b2b
-- =============================================

CREATE PROCEDURE [b2b].[GetArticleInformation] 
	-- Add the parameters for the stored procedure here
	@articleNumber VARCHAR(18)
AS
BEGIN
	SET NOCOUNT ON;
	
	SELECT *, 
	amu.IsB2BReady,
	ISNULL(amu.IsB2BReady, 0) AS 'Display'
	FROM [sap].[Article] sa
	LEFT JOIN [pies].[ArticleMasterUpdate] amu
	ON sa.ReferenceNumber = amu.ArticleNumber
	WHERE [ReferenceNumber] = @articleNumber

END
GO

CREATE PROCEDURE [b2b].[GetArticleImages]
	@articleNumber VARCHAR(18)
AS
BEGIN
	SET NOCOUNT ON;

	SELECT ai.ImageName as 'Name',
		   ai.ImageUrl as 'Url', 
		   ai.Thumbnail as 'Thumbnail'
	FROM [pies].[ArticleImage] ai
	where ai.ArticleNumber = @articleNumber
END
GO


CREATE PROCEDURE [b2b].[GetArticleAttributes]
	@articleNumber VARCHAR(18)
AS
BEGIN
	SET NOCOUNT ON;

	SELECT av.AttributeMetaDataId as 'AttributeId',
			av.AttributeValue as 'Value'
	FROM [pies].[AttributeValue] av
	where av.ArticleNumber = @articleNumber
END
GO