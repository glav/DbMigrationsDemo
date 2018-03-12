IF EXISTS (
	select 1 from sys.procedures sp 
	where schema_name(sp.schema_id) = 'vendor' and name = 'GetVendorProfile')
BEGIN
	DROP PROCEDURE [vendor].[GetVendorProfile]   
END
GO

-- =============================================  
-- Author:   Amit  
-- Create date: 06/06/2017  
-- Description: Get vendor profile  
-- Updated:  Addded AND Clause for vendor number is primary  
-- 17/07/2017 Carol Filter on vendor type and account group  
-- =============================================  
CREATE PROCEDURE [vendor].[GetVendorProfile]   
 @vendorNumber varchar(50)  
AS  
BEGIN  
 SET NOCOUNT ON;  
 
 declare @alternateVendorId varchar(max);  
 DECLARE @vendorNo VARCHAR(255),  
   @vendor VARCHAR(255)   
 SET @vendor = CONCAT(@vendorNumber,'%')   
  
 SELECT TOP 1 @vendorNo = sm.VendorNumber  
 FROM sap.SupplierMaster sm  
 WHERE sm.VendorNumber LIKE @vendor  
 AND  sm.VendorType = 'VN'  
 AND  sm.AccountGroup = 'SMKT'  
   

  SET @alternateVendorId = (  
    SELECT STUFF((  
        SELECT ',' + cast(subQ.numbers as varchar)   
        from  
         (SELECT  distinct(t2.vendornumber) as numbers FROM sap.suppliermaster t1, sap.suppliermaster t2  
        where t1.vendornumber = @vendorNo  
        AND t2.primaryvendornumber =  t1.primaryvendornumber  
        and t2.vendornumber != @vendorNo) subQ  
        FOR XML PATH('')),1,1,'') AS CSV)  
  
  select [BlockedIndicator],  
  [BuildingName],  
  [Country],  
  [FaxNumber],  
  [IsActive],  
  [PhoneNumber],  
  [POBox],  
  [PostCode],  
  [PrimaryVendorNumber],  
  [State],  
  [StreetName],  
  [Suburb],  
  [VendorName],  
  [VendorNumber],  
  [VendorType],
  [EmailId],  
  @alternateVendorId as 'AlternateVendorNumbers'   
  from sap.suppliermaster  
  where vendornumber = @vendorNo  
  
  SET NOCOUNT OFF  
END