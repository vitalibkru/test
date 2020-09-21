USE [esklad]
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
GO