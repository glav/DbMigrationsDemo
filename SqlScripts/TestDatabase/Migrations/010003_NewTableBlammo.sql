
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[anotherschema].[Blammo]') AND type in (N'U'))
BEGIN
CREATE TABLE [anotherschema].[Blammo](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[SomeNumber] [INT] NULL,
	[SomeText] [varchar](50) NULL,
 CONSTRAINT [PK_Blammo] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)
END
GO
