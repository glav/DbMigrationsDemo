/****** Object:  StoredProcedure [vendor].[GetInProgressAttributes]    Script Date: 26 Apr 2017 11:30:27 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/***************************************************************************
* Procedure   :   vendor.[GetInProgressAttributes]
* Description :   Gets all attributes for articles in progress state.
*                  
* Param/Arg				IN/OUT  Description
* -----------			------  ------------------------------------------
* @articleNumber		IN		
*
* Changelog	
* When				Who		Why
* 26/04/2017    Rahul		Create v1.0
***************************************************************************/
CREATE OR ALTER  PROCEDURE [vendor].[GetInProgressAttributes]
(
	@articleNumber	VARCHAR(18)
)
AS
BEGIN
	SET NOCOUNT ON

	SELECT amd.Id AS MetaDataId, 
		   vavs.attributename      AS AttributeName, 
		   vavs.attributevalue     AS AttributeValue 
	FROM   [vendor].[vendorattributevaluestaging] vavs 
		   INNER JOIN [vendor].[vendorproductsstaging] vps 
				   ON vavs.articlenumber = vps.articlenumber 
		   INNER JOIN [vendor].[vendorproductstatus] vpstatus 
				   ON vps.statusid = vpstatus.id 
		   INNER JOIN [pies].attributemetadata amd 
				   ON amd.[name] = vavs.attributename 
	WHERE  vpstatus.[name] = 'inprogress' 
		   AND vps.articlenumber = @articleNumber 
	
	SET NOCOUNT OFF
END
GO


