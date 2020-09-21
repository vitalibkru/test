USE [esklad]
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


