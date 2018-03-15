/****** Object:  StoredProcedure [dbo].[usp_someProc]    Script Date: 12/03/2018 6:11:46 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[usp_someProc2]
GO

/****** Object:  StoredProcedure [dbo].[usp_someProc]    Script Date: 12/03/2018 6:11:46 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_someProc2]') AND type IN (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[usp_someProc2] AS' 
END
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[usp_someProc2] 
AS
BEGIN
	SELECT 'hello from someProc2'
END
GO


