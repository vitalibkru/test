        ��  ��                  �  H   C U S T O M   S Q L _ I N S E R T _ D A T A         0         INSERT INTO [dbo].[Warehouse]
           ([WarehouseName])
     VALUES
           ('�������� �����')
GO

INSERT INTO [dbo].[Warehouse]
           ([WarehouseName])
     VALUES
           ('�������������� �����')
GO

INSERT INTO [dbo].[Place]
           ([WarehouseId]
           ,[PlaceName])
     VALUES
           (1
           ,'�������� �����')
GO


INSERT INTO [dbo].[Place]
           ([WarehouseId]
           ,[PlaceName])
     VALUES
           (1
           ,'�������������� �����')
GO

INSERT INTO [dbo].[Shipment]
           ([ShipmentName])
     VALUES
           ('�')
GO

INSERT INTO [dbo].[Shipment]
           ([ShipmentName])
     VALUES
           ('�')
GO

INSERT INTO [dbo].[Goods]
           ([GoodsArticle]
           ,[GoodsName]
           ,[GoodsCost]
           ,[GoodsSize])
     VALUES
           ('4820024700016'
           ,'����� 1'
           ,12.22
           ,3.4)
GO

INSERT INTO [dbo].[Goods]
           ([GoodsArticle]
           ,[GoodsName]
           ,[GoodsCost]
           ,[GoodsSize])
     VALUES
           ('5901234123457'
           ,'����� 2'
           ,2.3
           ,1)
GO

INSERT INTO [dbo].[Goods]
           ([GoodsArticle]
           ,[GoodsName]
           ,[GoodsCost]
           ,[GoodsSize])
     VALUES
           ('2150000000017'
           ,'����� 3'
           ,1.4
           ,3)
GO

INSERT INTO [dbo].[Doc]
           ([DocName]
           ,[DocType]
           ,[DocDate]
           ,[ShipmentId]
           ,[PlaceId]
           ,[WarehouseId])
     VALUES
           ('�������� 1'
           ,1
           ,CONVERT(DATETIME, '2019-10-15 00:38:54', 20)
           ,1
           ,1
           ,1)
GO

INSERT INTO [dbo].[Doc]
           ([DocName]
           ,[DocType]
           ,[DocDate]
           ,[ShipmentId]
           ,[PlaceId]
           ,[WarehouseId])
     VALUES
           ('�������� 2'
           ,1
           ,CONVERT(DATETIME, '2019-09-15 19:28:54', 20)
           ,2
           ,1
           ,1)
GO

INSERT INTO [dbo].[Doc]
           ([DocName]
           ,[DocType]
           ,[DocDate]
           ,[ShipmentId]
           ,[PlaceId]
           ,[WarehouseId])
     VALUES
           ('������� 1'
           ,3
           ,CONVERT(DATETIME, '2019-10-16 00:38:54', 20)
           ,1
           ,1
           ,1)
GO


INSERT INTO [dbo].[Doc]
           ([DocName]
           ,[DocType]
           ,[DocDate]
           ,[ShipmentId]
           ,[PlaceId]
           ,[WarehouseId])
     VALUES
           ('�������� 3'
           ,1
           ,CONVERT(DATETIME, '2018-02-20 00:22:12', 20)
           ,1
           ,NULL
           ,2)
GO

INSERT INTO [dbo].[Doc]
           ([DocName]
           ,[DocType]
           ,[DocDate]
           ,[ShipmentId]
           ,[PlaceId]
           ,[WarehouseId])
     VALUES
           ('����������� 1'
           ,2
           ,CONVERT(DATETIME, '2020-02-22 07:38:54', 20)
           ,1
           ,1
           ,1)
GO

INSERT INTO [dbo].[Doc]
           ([DocName]
           ,[DocType]
           ,[DocDate]
           ,[ShipmentId]
           ,[PlaceId]
           ,[WarehouseId])
     VALUES
           ('����������� 1'
           ,2
           ,CONVERT(DATETIME, '2020-02-22 19:02:32', 20)
           ,1
           ,NULL
           ,2)
GO

INSERT INTO [dbo].[DocLink]
           ([DocId]
           ,[GoodsId]
           ,[Count])
     VALUES
           (1
           ,1
           ,10)
GO

INSERT INTO [dbo].[DocLink]
           ([DocId]
           ,[GoodsId]
           ,[Count])
     VALUES
           (1
           ,2
           ,8)
GO

INSERT INTO [dbo].[DocLink]
           ([DocId]
           ,[GoodsId]
           ,[Count])
     VALUES
           (2
           ,1
           ,3)
GO

INSERT INTO [dbo].[DocLink]
           ([DocId]
           ,[GoodsId]
           ,[Count])
     VALUES
           (3
           ,1
           ,-2)
GO

INSERT INTO [dbo].[DocLink]
           ([DocId]
           ,[GoodsId]
           ,[Count])
     VALUES
           (4
           ,1
           ,1)
GO

INSERT INTO [dbo].[DocLink]
           ([DocId]
           ,[GoodsId]
           ,[Count])
     VALUES
           (5
           ,1
           ,-1)
GO

INSERT INTO [dbo].[DocLink]
           ([DocId]
           ,[GoodsId]
           ,[Count])
     VALUES
           (6
           ,1
           ,1)
GO

   �  H   C U S T O M   S Q L _ C R E A T E _ P R O C         0         USE [esklad]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID (N'dbo.date2int', N'FN') IS NOT NULL  
    DROP FUNCTION dbo.date2int;  
GO 

CREATE FUNCTION [dbo].[date2int]
(
	@Date datetime
)
RETURNS bigint
AS
BEGIN
	RETURN ROUND(convert(float, ISNULL(@Date,0),0),0,1)+2;
END
GO

IF OBJECT_ID (N'dbo.time2int', N'FN') IS NOT NULL  
    DROP FUNCTION dbo.time2int;  
GO 

CREATE FUNCTION [dbo].[time2int]
(
	@Date datetime
)
RETURNS bigint
AS
BEGIN
	DECLARE @RET float = convert(float, ISNULL(@Date,0),0);
	SET @RET = @RET - round(@RET, 0, 1)

	RETURN round(86400*@RET, 0, 1);
END
GO

IF OBJECT_ID (N'dbo.dateOver', N'FN') IS NOT NULL  
    DROP FUNCTION dbo.dateOver;  
GO 

CREATE FUNCTION [dbo].[dateOver]
(
	@Value bigint
	, @Date datetime
)
RETURNS bit
AS
BEGIN
	DECLARE @RET bit = 0;

	IF (@Value=0) 
		SET @RET = 1;
	
	ELSE IF (@Value >= dbo.date2int(@Date))
		SET @RET = 1;
	
	RETURN @RET;

END
GO

IF OBJECT_ID (N'dbo.datetimeOver', N'FN') IS NOT NULL  
    DROP FUNCTION dbo.datetimeOver;  
GO 

CREATE FUNCTION [dbo].[datetimeOver]
(
	@VDate bigint
	,@VTime bigint
	,@Date datetime
)
RETURNS bit
AS
BEGIN
  DECLARE @RET bit = 0;
  DECLARE @DD bigint = dbo.date2int(@Date);

  IF (@VDate=0)
    SET @RET = 1;
  ELSE IF (@VDate > @DD)
    SET @RET = 1;
  ELSE IF (@VDate = @DD)
    IF (@VTime=0)
      SET @RET = 1;
    ELSE IF (@VTime >= dbo.time2int(@Date))
      SET @RET = 1;

	RETURN @RET;
END
GO

	  D   C U S T O M   S Q L _ C R E A T E _ D B         0         USE [master]
GO

CREATE DATABASE [%dbname%]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'%dbname%', FILENAME = N'%dbpath%\%dbname%.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON
( NAME = N'%dbname%_log', FILENAME = N'%dbpath%\%dbname%_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
GO

IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [%dbname%].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO

ALTER DATABASE [%dbname%] SET ANSI_NULL_DEFAULT OFF
GO

ALTER DATABASE [%dbname%] SET ANSI_NULLS OFF
GO

ALTER DATABASE [%dbname%] SET ANSI_PADDING OFF
GO

ALTER DATABASE [%dbname%] SET ANSI_WARNINGS OFF
GO

ALTER DATABASE [%dbname%] SET ARITHABORT OFF
GO

ALTER DATABASE [%dbname%] SET AUTO_CLOSE OFF
GO

ALTER DATABASE [%dbname%] SET AUTO_SHRINK OFF
GO

ALTER DATABASE [%dbname%] SET AUTO_UPDATE_STATISTICS ON
GO

ALTER DATABASE [%dbname%] SET CURSOR_CLOSE_ON_COMMIT OFF
GO

ALTER DATABASE [%dbname%] SET CURSOR_DEFAULT  GLOBAL
GO

ALTER DATABASE [%dbname%] SET CONCAT_NULL_YIELDS_NULL OFF
GO

ALTER DATABASE [%dbname%] SET NUMERIC_ROUNDABORT OFF
GO

ALTER DATABASE [%dbname%] SET QUOTED_IDENTIFIER OFF
GO

ALTER DATABASE [%dbname%] SET RECURSIVE_TRIGGERS OFF
GO

ALTER DATABASE [%dbname%] SET  DISABLE_BROKER
GO

ALTER DATABASE [%dbname%] SET AUTO_UPDATE_STATISTICS_ASYNC OFF
GO

ALTER DATABASE [%dbname%] SET DATE_CORRELATION_OPTIMIZATION OFF
GO

ALTER DATABASE [%dbname%] SET TRUSTWORTHY OFF
GO

ALTER DATABASE [%dbname%] SET ALLOW_SNAPSHOT_ISOLATION OFF
GO

ALTER DATABASE [%dbname%] SET PARAMETERIZATION SIMPLE
GO

ALTER DATABASE [%dbname%] SET READ_COMMITTED_SNAPSHOT OFF
GO

ALTER DATABASE [%dbname%] SET HONOR_BROKER_PRIORITY OFF
GO

ALTER DATABASE [%dbname%] SET RECOVERY SIMPLE
GO

ALTER DATABASE [%dbname%] SET  MULTI_USER
GO

ALTER DATABASE [%dbname%] SET PAGE_VERIFY CHECKSUM
GO

ALTER DATABASE [%dbname%] SET DB_CHAINING OFF
GO

ALTER DATABASE [%dbname%] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF )
GO

ALTER DATABASE [%dbname%] SET TARGET_RECOVERY_TIME = 60 SECONDS
GO

ALTER DATABASE [%dbname%] SET DELAYED_DURABILITY = DISABLED
GO

ALTER DATABASE [%dbname%] SET QUERY_STORE = OFF
GO

ALTER DATABASE [%dbname%] SET  READ_WRITE
GO


   L  H   C U S T O M   S Q L _ C R E A T E _ G O O D S       0         USE [esklad]
GO

/****** Object:  Table [dbo].[Goods]    Script Date: 17.09.2020 3:44:08 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Goods](
	[GoodsId] [bigint] IDENTITY(1,1) NOT NULL,
	[GoodsArticle] [nchar](13) NOT NULL,
	[GoodsName] [nvarchar](100) NULL,
	[GoodsCost] [float] NULL,
	[GoodsSize] [float] NULL,
 CONSTRAINT [PK_Goods] PRIMARY KEY CLUSTERED 
(
	[GoodsId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO


�  P   C U S T O M   S Q L _ C R E A T E _ S H I P M E N T         0         USE [esklad]
GO

/****** Object:  Table [dbo].[Shipment]    Script Date: 17.09.2020 3:44:33 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Shipment](
	[ShipmentId] [bigint] IDENTITY(1,1) NOT NULL,
	[ShipmentName] [nvarchar](100) NULL,
 CONSTRAINT [PK_Shipment] PRIMARY KEY CLUSTERED 
(
	[ShipmentId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO


 �  H   C U S T O M   S Q L _ C R E A T E _ P L A C E       0         USE [esklad]
GO

/****** Object:  Table [dbo].[Place]    Script Date: 17.09.2020 3:44:22 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Place](
	[PlaceId] [bigint] IDENTITY(1,1) NOT NULL,
	[WarehouseId] [bigint] NOT NULL,
	[PlaceName] [nvarchar](100) NULL,
 CONSTRAINT [PK_Place] PRIMARY KEY CLUSTERED 
(
	[PlaceId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Place]  WITH CHECK ADD  CONSTRAINT [FK_Place_Warehouse] FOREIGN KEY([WarehouseId])
REFERENCES [dbo].[Warehouse] ([WarehouseId])
GO

ALTER TABLE [dbo].[Place] CHECK CONSTRAINT [FK_Place_Warehouse]
GO


    P   C U S T O M   S Q L _ C R E A T E _ W A R E H O U S E       0         USE [esklad]
GO

/****** Object:  Table [dbo].[Warehouse]    Script Date: 17.09.2020 3:44:49 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Warehouse](
	[WarehouseId] [bigint] IDENTITY(1,1) NOT NULL,
	[WarehouseName] [nvarchar](100) NULL,
 CONSTRAINT [PK_Warehouse] PRIMARY KEY CLUSTERED 
(
	[WarehouseId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO


   	  D   C U S T O M   S Q L _ C R E A T E _ D O C       0         USE [esklad]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Doc](
	[DocId] [bigint] IDENTITY(1,1) NOT NULL,
	[DocName] [nvarchar](100) NULL,
	[DocType] [bigint] NULL,
	[DocDate] [datetime] NULL,
	[ShipmentId] [bigint] NULL,
	[PlaceId] [bigint] NULL,
	[WarehouseId] [bigint] NULL,
 CONSTRAINT [PK_Doc] PRIMARY KEY CLUSTERED 
(
	[DocId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Doc]  WITH CHECK ADD  CONSTRAINT [FK_Doc_Place] FOREIGN KEY([PlaceId])
REFERENCES [dbo].[Place] ([PlaceId])
GO

ALTER TABLE [dbo].[Doc] CHECK CONSTRAINT [FK_Doc_Place]
GO

ALTER TABLE [dbo].[Doc]  WITH CHECK ADD  CONSTRAINT [FK_Doc_Shipment] FOREIGN KEY([ShipmentId])
REFERENCES [dbo].[Shipment] ([ShipmentId])
GO

ALTER TABLE [dbo].[Doc] CHECK CONSTRAINT [FK_Doc_Shipment]
GO

IF OBJECT_ID ('PlaceIdUPDATE', 'TR') IS NOT NULL
   DROP TRIGGER [dbo].[PlaceIdUPDATE];
GO

CREATE TRIGGER [dbo].[PlaceIdUPDATE]
   ON  [dbo].[Doc]
   AFTER INSERT,UPDATE
AS IF UPDATE(PlaceId)
BEGIN
	SET NOCOUNT ON;

declare @DocId bigint = (select DocId from inserted)
declare @WarehouseId bigint = (select Place.WarehouseId from Place,inserted WHERE Place.PlaceId = inserted.PlaceId)
IF NOT (@WarehouseId IS NULL)
	begin
		update Doc set WarehouseId = @WarehouseId where (Doc.DocId = @DocId)
	end

END
GO

IF OBJECT_ID ('WarehouseIdUPDATE', 'TR') IS NOT NULL
   DROP TRIGGER [dbo].[WarehouseIdUPDATE];
GO

CREATE TRIGGER [dbo].[WarehouseIdUPDATE]
   ON  [dbo].[Doc]
   AFTER INSERT,UPDATE
AS IF UPDATE(WarehouseId) 
BEGIN
	SET NOCOUNT ON;

declare @DocId bigint = (select DocId from inserted) 
declare @WarehouseId bigint = (select WarehouseId from inserted) 
declare @PlaceWarehouseId bigint = (select Place.WarehouseId from Place,inserted WHERE Place.PlaceId = inserted.PlaceId)

IF (NOT (@PlaceWarehouseId IS NULL)) AND (@WarehouseId <> @PlaceWarehouseId)
	begin
		update Doc set PlaceId = (select top(1) PlaceId from Place WHERE Place.WarehouseId = @WarehouseId) where (Doc.DocId = @DocId)
	end

END
GO

ALTER TABLE [dbo].[Doc] ENABLE TRIGGER [WarehouseIdUPDATE]
GO

ALTER TABLE [dbo].[Doc] ENABLE TRIGGER [PlaceIdUPDATE]
GO   ~  L   C U S T O M   S Q L _ C R E A T E _ D O C L I N K       0         USE [esklad]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[DocLink](
	[DocId] [bigint] NOT NULL,
	[GoodsId] [bigint] NOT NULL,
	[Count] [bigint] NOT NULL
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[DocLink]  WITH CHECK ADD  CONSTRAINT [FK_DocLink_Doc] FOREIGN KEY([DocId])
REFERENCES [dbo].[Doc] ([DocId])
GO

ALTER TABLE [dbo].[DocLink] CHECK CONSTRAINT [FK_DocLink_Doc]
GO

ALTER TABLE [dbo].[DocLink]  WITH CHECK ADD  CONSTRAINT [FK_DocLink_Goods] FOREIGN KEY([GoodsId])
REFERENCES [dbo].[Goods] ([GoodsId])
GO

ALTER TABLE [dbo].[DocLink] CHECK CONSTRAINT [FK_DocLink_Goods]
GO


  