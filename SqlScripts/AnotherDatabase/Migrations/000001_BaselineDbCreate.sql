IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = N'blah')
EXEC sys.sp_executesql N'CREATE SCHEMA [blah]'

GO

IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = N'stuff')
EXEC sys.sp_executesql N'CREATE SCHEMA [stuff]'

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[blah].[Descriptions]') AND type in (N'U'))
BEGIN
CREATE TABLE [blah].[Descriptions](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Code] [varchar](2) NULL,
	[Description] [varchar](50) NULL,
 CONSTRAINT [PK_Descriptions] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[stuff].[SomeDataTable]') AND type in (N'U'))
BEGIN
CREATE TABLE [stuff].[SomeDataTable](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[SomeNumber] [INT] NULL,
	[SomeText] [varchar](50) NULL,
 CONSTRAINT [PK_SomeDataTable] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)
END
GO
