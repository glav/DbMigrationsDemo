IF EXISTS (
	select 1 from sys.procedures sp 
	where schema_name(sp.schema_id) = 'vendor' and name = 'UpdateArticleStatusForVendor')
BEGIN
	DROP PROCEDURE [vendor].[UpdateArticleStatusForVendor]
END
GO
-- =============================================      
-- Author:  AMIT      
-- Create date: 09/04/2017      
-- Updated Obn : 19/05/2017  
-- Description: This procedure will update article status to desires status    
-- Reason   : Removed input submitted by and reviewed by  
-- =============================================      
CREATE PROCEDURE [vendor].[UpdateArticleStatusForVendor]  
 -- Add the parameters for the stored procedure here      
 @articleNumber VARCHAR(18)  
 ,@vendorNumber VARCHAR(255)  
 ,@userType VARCHAR(50)  
 ,@submittedBy VARCHAR(100) = NULL  
 ,@reviewedBy VARCHAR(100) = NULL  
 ,@comments VARCHAR(Max) = NULL  
 ,@status VARCHAR(100)  
 ,@rejectionType VARCHAR(100) = NULL  
AS  
BEGIN  
 -- SET NOCOUNT ON added to prevent extra result sets from      
 -- interfering with SELECT statements.      
 SET NOCOUNT ON;  
 DECLARE @vendorId varchar(255)
 DECLARE @statusId INT;  
  
SELECT TOP 1 @vendorId = CostVendorNumber
FROM sap.VendorTradingUnit vtu
WHERE vtu.ReferenceNumber = @articleNumber AND vtu.CostVendorNumber like CONCAT(@vendorNumber,'%')


 SELECT @statusId = Id  
 FROM [vendor].[VendorProductStatus]  
 WHERE [Name] = @status  
  


 IF EXISTS (  
   SELECT 1  
   FROM [vendor].[VendorProductsStaging]  
   WHERE [ArticleNumber] = @articleNumber  
   )  
 BEGIN  
  IF (@status = 'Approved')  
  BEGIN  
   UPDATE [vendor].[VendorProductsStaging]  
   SET Usertype = @userType  
    ,ReviewedBy = @reviewedBy  
    ,ReviewedOn = dbo.fnGetLocalDateForUTC(GETUTCDATE())  
    ,StatusId = @statusId  
    ,Note = NULL  
   WHERE [ArticleNumber] = @articleNumber  
  END  
  
  IF (@status = 'Rejected')  
  BEGIN  
   UPDATE [vendor].[VendorProductsStaging]  
   SET Usertype = @userType  
    ,ReviewedBy = @reviewedBy  
    ,ReviewedOn = dbo.fnGetLocalDateForUTC(GETUTCDATE())  
    ,Comments = @comments  
    ,RejectionType = @rejectionType  
    ,StatusId = @statusId  
   WHERE [ArticleNumber] = @articleNumber  
  END  
  
  IF (@status = 'Submitted')  
  BEGIN  
   UPDATE [vendor].[VendorProductsStaging]  
   SET Usertype = @userType  
    ,SubmittedBy = @submittedBy  
    ,SubmittedOn = dbo.fnGetLocalDateForUTC(GETUTCDATE())  
    ,RejectionType = NULL  
    ,Comments = NULL  
    ,StatusId = @statusId  
   WHERE [ArticleNumber] = @articleNumber  
  END  
  
  IF (@status = 'InProgress')  
  BEGIN  
   UPDATE [vendor].[VendorProductsStaging]  
   SET Usertype = @userType  
    ,SubmittedBy = NULL  
    ,SubmittedOn = NULL  
    ,RejectionType = NULL  
    ,Comments = NULL  
    ,StatusId = @statusId  
   WHERE [ArticleNumber] = @articleNumber  
  END  
 END  
 ELSE  
  INSERT INTO [vendor].[VendorProductsStaging]  
  (   
   [VendorNumber],  
   [ArticleNumber],  
   [StatusId],  
   [Comments],  
   [SubmittedBy],  
   [SubmittedOn],  
   [ReviewedBy],  
   [ReviewedOn],  
   [Usertype],  
   [Note],  
   [RejectionType]  
  )  
  VALUES (  
   @vendorNumber  
   ,@articleNumber  
   ,@statusId  
   ,@Comments  
   ,@submittedBy  
   ,NULL  
   ,@reviewedBy  
   ,NULL  
   ,@userType  
   ,NULL  
   ,NULL  
   )  
END