IF EXISTS (
	select 1 from sys.procedures sp 
	where schema_name(sp.schema_id) = 'vendor' and name = 'UpdateArticleStatusForVendor')
BEGIN
	DROP PROCEDURE [vendor].[UpdateArticleStatusForVendor]
END
GO
/***************************************************************************    
* Procedure   :   vendor.AddNotesForVendor    
* Description :   Add notes for vendor.    
*                      
* Param/Arg    IN/OUT  Description    
* -----------   ------  ------------------------------------------    
* vendorNumber  IN    
* vendorType  IN    
* articleNumber  IN    
* note    IN/OUT    
*    
* Changelog     
* When   Who  Why    
* 3/05/2017    Rahul v1.0    
* 23/05/2017   Amit  Removed Status Update  
***************************************************************************/    
CREATE PROCEDURE [vendor].[AddNotesForVendor]    
(    
 @vendorNumber  VARCHAR(18),    
 @vendorType   VARCHAR(10),    
 @articleNumber  VARCHAR(18),    
 @note    VARCHAR(1000)    
)    
AS    
BEGIN    
 SET NOCOUNT ON    
  DECLARE @vendorId VARCHAR(18)

  SELECT TOP 1 @vendorId = CostVendorNumber
	FROM sap.VendorTradingUnit vtu
	WHERE vtu.ReferenceNumber = @articleNumber AND vtu.CostVendorNumber like CONCAT(@vendorNumber,'%')


 IF EXISTS(SELECT 1     
     FROM   vendor.vendorproductsstaging     
     WHERE  [articlenumber] = @articleNumber)     
   UPDATE [vendor].[vendorproductsstaging]     
   SET    [vendornumber] = @vendorId,     
		  [usertype] = @vendorType,     
		  [note] = @note     
   WHERE  [articlenumber] = @articleNumber     
 ELSE     
   INSERT INTO [vendor].[vendorproductsstaging]     
      ([vendornumber],     
       [articlenumber],     
       [statusid],     
       [comments],     
       [submittedby],     
       [submittedon],     
       [reviewedby],     
       [reviewedon],     
       [usertype],     
       [note])     
   VALUES      (@vendorId,     
    @articleNumber,     
    NULL,     
    '',     
    '',     
    NULL,    
    '',     
    NULL,     
    @vendorType,     
    @note)     
 SET NOCOUNT OFF    
END