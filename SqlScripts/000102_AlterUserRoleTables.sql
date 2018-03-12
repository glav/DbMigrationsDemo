IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[pies].[RoleManagement]') AND type in (N'U'))
BEGIN
	IF OBJECT_ID('pies.[FK_RoleManagement_UserRole_RoleId]') IS NOT NULL 
	BEGIN
		ALTER TABLE [pies].[RoleManagement] DROP CONSTRAINT [FK_RoleManagement_UserRole_RoleId]
	END

	IF OBJECT_ID('pies.[FK_RoleManagement_User_UserId]') IS NOT NULL 
	BEGIN
		ALTER TABLE [pies].[RoleManagement] DROP CONSTRAINT [FK_RoleManagement_User_UserId]
	END

	DROP TABLE [pies].[RoleManagement]
END

IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[pies].[UserRole]') AND type in (N'U'))
BEGIN
	DROP TABLE [pies].[UserRole]
END

IF EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[pies].[User]') AND type in (N'U'))
BEGIN
	IF OBJECT_ID('pies.[FK_Login_User_UserId]') IS NOT NULL 
	BEGIN
		ALTER TABLE pies.[Login] DROP CONSTRAINT FK_Login_User_UserId
	END

	IF OBJECT_ID('pies.[FK_Login_UserId]') IS NOT NULL 
	BEGIN
		ALTER TABLE pies.[Login] DROP CONSTRAINT FK_Login_UserId
	END

	DROP TABLE [pies].[User]
END

IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[pies].[User]') AND type in (N'U'))
BEGIN
	CREATE TABLE [pies].[User]
	(
		UserId INTEGER IDENTITY(1,1) NOT NULL,
		SalesOrganisationId	INTEGER	NOT NULL,
		UserEmail VARCHAR(100) NOT NULL,
		IsActive BIT NOT NULL,
		CreatedOn	DATETIME NOT NULL,
		CreatedBy	VARCHAR(100) NOT NULL,
		UpdatedOn	DATETIME,
		UpdatedBy	VARCHAR(100)
	)

	ALTER TABLE [pies].[User]
	ADD  CONSTRAINT [PK_PiesUser] PRIMARY KEY CLUSTERED 
	(
		UserId ASC
	)

	CREATE NONCLUSTERED INDEX [IX_User] ON [pies].[User]
	(
		SalesOrganisationId ASC,
		UserEmail ASC
	)

	ALTER TABLE [pies].[Login] 
	ADD CONSTRAINT [FK_Login_UserId] FOREIGN KEY([UserId])
	REFERENCES [pies].[User] ([UserId])

END

IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[pies].[Role]') AND type in (N'U'))
BEGIN
	CREATE TABLE [pies].[Role]
	(
		RoleId INTEGER IDENTITY(1,1) NOT NULL,
		RoleName VARCHAR(50) NOT NULL,
		RoleDescription VARCHAR(500) NOT NULL,
		IsActive BIT NOT NULL,
		CreatedOn DATETIME NOT NULL,
		CreatedBy VARCHAR(100) NOT NULL,
		UpdatedOn DATETIME NULL,
		UpdatedBy VARCHAR(100) NULL
	)

	ALTER TABLE [pies].[Role]
	ADD  CONSTRAINT [PK_PiesRole] PRIMARY KEY CLUSTERED 
	(
		[RoleId] ASC
	)
END

IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[pies].[UserRole]') AND type in (N'U'))
BEGIN

	CREATE TABLE [pies].[UserRole]
	(
		UserRoleId INTEGER IDENTITY(1,1) NOT NULL,
		RoleId INTEGER NOT NULL,
		UserId INTEGER NOT NULL,
		IsActive BIT NOT NULL,
		CreatedOn DATETIME NOT NULL,
		CreatedBy VARCHAR(100) NOT NULL,
		UpdatedOn DATETIME NULL,
		UpdatedBy VARCHAR(100) NULL
	)

	ALTER TABLE [pies].[UserRole]
	ADD  CONSTRAINT [PK_UserRole] PRIMARY KEY CLUSTERED 
	(
		[UserRoleId] ASC
	)

	CREATE NONCLUSTERED INDEX [IX_UserRole] ON [pies].[UserRole]
	(
		[RoleId] ASC,
		[UserId] ASC
	)

	ALTER TABLE [pies].[UserRole] 
	ADD CONSTRAINT [FK_UserRole_UserId] FOREIGN KEY([UserId])
	REFERENCES [pies].[User] ([UserId])

	ALTER TABLE [pies].[UserRole] 
	ADD CONSTRAINT [FK_UserRole_RoleId] FOREIGN KEY([RoleId])
	REFERENCES [pies].[Role] ([RoleId])
END