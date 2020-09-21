INSERT INTO [dbo].[Warehouse]
           ([WarehouseName])
     VALUES
           ('Основной склад')
GO

INSERT INTO [dbo].[Warehouse]
           ([WarehouseName])
     VALUES
           ('Дополнительный склад')
GO

INSERT INTO [dbo].[Place]
           ([WarehouseId]
           ,[PlaceName])
     VALUES
           (1
           ,'Основное место')
GO


INSERT INTO [dbo].[Place]
           ([WarehouseId]
           ,[PlaceName])
     VALUES
           (1
           ,'Дополнительное место')
GO

INSERT INTO [dbo].[Shipment]
           ([ShipmentName])
     VALUES
           ('А')
GO

INSERT INTO [dbo].[Shipment]
           ([ShipmentName])
     VALUES
           ('Б')
GO

INSERT INTO [dbo].[Goods]
           ([GoodsArticle]
           ,[GoodsName]
           ,[GoodsCost]
           ,[GoodsSize])
     VALUES
           ('4820024700016'
           ,'Товар 1'
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
           ,'Товар 2'
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
           ,'Товар 3'
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
           ('Поставка 1'
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
           ('Поставка 2'
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
           ('Продажа 1'
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
           ('Поставка 3'
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
           ('Перемещение 1'
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
           ('Перемещение 1'
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

