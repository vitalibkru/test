USE [esklad]
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


