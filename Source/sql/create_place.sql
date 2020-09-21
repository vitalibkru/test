USE [esklad]
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


