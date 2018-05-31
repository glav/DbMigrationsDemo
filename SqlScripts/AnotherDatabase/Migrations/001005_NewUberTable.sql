
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[stuff].[Uber]') AND type in (N'U'))
BEGIN
CREATE TABLE [stuff].[Uber](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[UberNumber] [INT] NULL,
	[UberText] [varchar](50) NULL,
 CONSTRAINT [PK_FourFive] PRIMARY KEY CLUSTERED 
(
	[Id] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)
END
GO

