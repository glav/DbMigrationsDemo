
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = N'test')
EXEC sys.sp_executesql N'CREATE SCHEMA [test]'

GO
/****** Object:  Schema [staging]    Script Date: 6/12/2016 4:31:24 PM ******/
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = N'anotherschema')
EXEC sys.sp_executesql N'CREATE SCHEMA [anotherschema]'

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[test].[TableOne]') AND type in (N'U'))
BEGIN
CREATE TABLE [test].[TableOne](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Code] [varchar](2) NULL,
	[Description] [varchar](50) NULL,
 CONSTRAINT [PK_TableOne] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[anotherschema].[SomeTable]') AND type in (N'U'))
BEGIN
CREATE TABLE [anotherschema].[SomeTable](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[SomeNumber] [INT] NULL,
	[SomeText] [varchar](50) NULL,
 CONSTRAINT [PK_SomeTable] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)
END
GO
