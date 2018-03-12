/****** Object:  StoredProcedure [dbo].[usp_someProc]    Script Date: 12/03/2018 6:11:46 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[usp_dummyProc]
GO

/****** Object:  StoredProcedure [dbo].[usp_someProc]    Script Date: 12/03/2018 6:11:46 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_dummyProc]') AND type IN (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[usp_dummyProc] AS' 
END
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[usp_dummyProc] 
AS
BEGIN
	SELECT * FROM [anotherschema].[SomeTable]
END
GO


