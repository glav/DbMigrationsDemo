-- =============================================   
-- Author:   Amit  
-- Create date:  18/04/2017  
-- Description:  To get article status  
-- =============================================   
 CREATE OR ALTER PROCEDURE [vendor].[Getarticlestatusforvendor]   
  -- Add the parameters for the stored procedure here   
  @articleNumber VARCHAR(18),   
  @vendorNumber  VARCHAR(100)   
AS   
  BEGIN   
      -- SET NOCOUNT ON added to prevent extra result sets from   
      -- interfering with SELECT statements.   
      SET nocount ON;   
      -- Insert statements for procedure here   
      SELECT s.NAME as 'Status', vps.Note as 'Node'   
      FROM   [vendor].[vendorproductsstaging] vps   
             LEFT JOIN [vendor].[vendorproductstatus] s   
                     ON vps.statusid = s.id   
      WHERE  vps.articlenumber = @articleNumber
        
END
