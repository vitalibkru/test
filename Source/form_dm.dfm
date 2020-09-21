object FDM: TFDM
  OldCreateOrder = False
  Height = 541
  Width = 734
  object FDConnection: TFDConnection
    Params.Strings = (
      'SERVER=localhost\SQLE'
      'User_Name=sa'
      'ApplicationName=Enterprise/Architect/Ultimate'
      'Workstation=WS151-2'
      'MARS=yes'
      'Database=esklad'
      'DriverID=MSSQL')
    LoginPrompt = False
    AfterConnect = FDConnectionChangeState
    AfterDisconnect = FDConnectionChangeState
    Left = 32
    Top = 24
  end
  object FDTable_Goods: TFDTable
    IndexFieldNames = 'GoodsId'
    Connection = FDConnection
    UpdateOptions.UpdateTableName = 'Goods'
    TableName = 'Goods'
    Left = 136
    Top = 144
    object FDTable_GoodsGoodsId: TLargeintField
      AutoGenerateValue = arAutoInc
      FieldName = 'GoodsId'
      Origin = 'GoodsId'
      ProviderFlags = [pfInWhere]
      ReadOnly = True
      Visible = False
    end
    object FDTable_GoodsGoodsArticle: TWideStringField
      DisplayLabel = #1040#1088#1090#1080#1082#1091#1083
      FieldName = 'GoodsArticle'
      Origin = 'GoodsArticle'
      Required = True
      FixedChar = True
      Size = 13
    end
    object FDTable_GoodsGoodsName: TWideStringField
      DisplayLabel = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
      FieldName = 'GoodsName'
      Origin = 'GoodsName'
      Size = 100
    end
    object FDTable_GoodsGoodsCost: TFloatField
      DisplayLabel = #1062#1077#1085#1072
      FieldName = 'GoodsCost'
      Origin = 'GoodsCost'
    end
    object FDTable_GoodsGoodsSize: TFloatField
      DisplayLabel = #1056#1072#1079#1084#1077#1088
      FieldName = 'GoodsSize'
      Origin = 'GoodsSize'
    end
  end
  object FDTable_Warehouse: TFDTable
    IndexFieldNames = 'WarehouseId'
    Connection = FDConnection
    UpdateOptions.UpdateTableName = 'Warehouse'
    TableName = 'Warehouse'
    Left = 136
    Top = 24
    object FDTable_WarehouseWarehouseId: TLargeintField
      AutoGenerateValue = arAutoInc
      FieldName = 'WarehouseId'
      Origin = 'WarehouseId'
      ProviderFlags = [pfInWhere, pfInKey]
      ReadOnly = True
      Visible = False
    end
    object FDTable_WarehouseWarehouseName: TWideStringField
      DisplayLabel = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
      FieldName = 'WarehouseName'
      Origin = 'WarehouseName'
      Size = 100
    end
  end
  object FDTable_Place: TFDTable
    BeforeOpen = FDTable_PlaceBeforeOpen
    AfterClose = FDTable_PlaceAfterClose
    IndexFieldNames = 'PlaceId'
    Connection = FDConnection
    UpdateOptions.UpdateTableName = 'Place'
    TableName = 'Place'
    Left = 136
    Top = 88
    object FDTable_PlacePlaceId: TLargeintField
      AutoGenerateValue = arAutoInc
      FieldName = 'PlaceId'
      Origin = 'PlaceId'
      ProviderFlags = [pfInWhere, pfInKey]
      ReadOnly = True
      Visible = False
    end
    object FDTable_PlaceWarehouseId: TLargeintField
      FieldName = 'WarehouseId'
      Origin = 'WarehouseId'
      Required = True
      Visible = False
    end
    object FDTable_PlaceWarehouseName: TStringField
      DisplayLabel = #1057#1082#1083#1072#1076
      FieldKind = fkLookup
      FieldName = 'WarehouseName'
      LookupDataSet = FDQuery_PlaceWarehouse
      LookupKeyFields = 'WarehouseId'
      LookupResultField = 'WarehouseName'
      KeyFields = 'WarehouseId'
      Size = 100
      Lookup = True
    end
    object FDTable_PlacePlaceName: TWideStringField
      DisplayLabel = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
      FieldName = 'PlaceName'
      Origin = 'PlaceName'
      Size = 100
    end
  end
  object FDPhysMSSQLDriverLink: TFDPhysMSSQLDriverLink
    ODBCDriver = 'SQL Server Native Client 11.0'
    Left = 32
    Top = 136
  end
  object FDGUIxWaitCursor: TFDGUIxWaitCursor
    Provider = 'Forms'
    Left = 32
    Top = 80
  end
  object FDQuery_PlaceWarehouse: TFDQuery
    Connection = FDConnection
    SQL.Strings = (
      'SELECT        NULL AS WarehouseId, '#39#39' AS WarehouseName'
      'UNION'
      'SELECT        WarehouseId, WarehouseName'
      'FROM            Warehouse'
      'ORDER BY WarehouseName')
    Left = 280
    Top = 88
    object FDQuery_PlaceWarehouseWarehouseId: TLargeintField
      FieldName = 'WarehouseId'
      Origin = 'WarehouseId'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      ReadOnly = True
    end
    object FDQuery_PlaceWarehouseWarehouseName: TWideStringField
      FieldName = 'WarehouseName'
      Origin = 'WarehouseName'
      ReadOnly = True
      Size = 100
    end
  end
  object FDQuery_DocPlace: TFDQuery
    Connection = FDConnection
    SQL.Strings = (
      'SELECT        NULL AS PlaceId, '#39#39' AS PlaceName'
      'UNION'
      'SELECT        PlaceId, PlaceName'
      'FROM            Place ')
    Left = 360
    Top = 256
    object FDQuery_DocPlacePlaceId: TLargeintField
      FieldName = 'PlaceId'
      Origin = 'PlaceId'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      ReadOnly = True
    end
    object FDQuery_DocPlacePlaceName: TWideStringField
      FieldName = 'PlaceName'
      Origin = 'PlaceName'
      ReadOnly = True
      Size = 100
    end
  end
  object FDTable_Shipment: TFDTable
    IndexFieldNames = 'ShipmentId'
    Connection = FDConnection
    UpdateOptions.UpdateTableName = 'Shipment'
    TableName = 'Shipment'
    Left = 136
    Top = 200
    object FDTable_ShipmentShipmentId: TLargeintField
      AutoGenerateValue = arAutoInc
      FieldName = 'ShipmentId'
      Origin = 'ShipmentId'
      ProviderFlags = [pfInWhere, pfInKey]
      ReadOnly = True
      Visible = False
    end
    object FDTable_ShipmentShipmentName: TWideStringField
      DisplayLabel = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
      FieldName = 'ShipmentName'
      Origin = 'ShipmentName'
      Size = 100
    end
  end
  object FDTable_Doc: TFDTable
    BeforeOpen = FDTable_DocBeforeOpen
    AfterClose = FDTable_DocAfterClose
    IndexFieldNames = 'DocId'
    Connection = FDConnection
    UpdateOptions.UpdateTableName = 'Doc'
    TableName = 'Doc'
    Left = 136
    Top = 256
    object FDTable_DocDocId: TLargeintField
      AutoGenerateValue = arAutoInc
      FieldName = 'DocId'
      Origin = 'DocId'
      ProviderFlags = [pfInWhere, pfInKey]
      ReadOnly = True
      Visible = False
    end
    object FDTable_DocDocType: TLargeintField
      FieldName = 'DocType'
      Origin = 'DocType'
      Visible = False
    end
    object FDTable_DocDocTypeName: TStringField
      DisplayLabel = #1058#1080#1087' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
      FieldKind = fkLookup
      FieldName = 'DocTypeName'
      LookupDataSet = FDQuery_DocType
      LookupKeyFields = 'DocTypeId'
      LookupResultField = 'DocTypeName'
      KeyFields = 'DocType'
      Size = 50
      Lookup = True
    end
    object FDTable_DocDocDate: TSQLTimeStampField
      DisplayLabel = #1044#1072#1090#1072
      FieldName = 'DocDate'
      Origin = 'DocDate'
      EditMask = '!99/99/0000;1;*'
    end
    object FDTable_DocDocName: TWideStringField
      DisplayLabel = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
      FieldName = 'DocName'
      Origin = 'DocName'
      Size = 100
    end
    object FDTable_DocShipmentId: TLargeintField
      FieldName = 'ShipmentId'
      Origin = 'ShipmentId'
      Visible = False
    end
    object FDTable_DocPlaceId: TLargeintField
      FieldName = 'PlaceId'
      Origin = 'PlaceId'
      Visible = False
    end
    object FDTable_DocShipmentName: TStringField
      DisplayLabel = #1055#1072#1088#1090#1080#1103
      FieldKind = fkLookup
      FieldName = 'ShipmentName'
      LookupDataSet = FDQuery_DocShipment
      LookupKeyFields = 'ShipmentId'
      LookupResultField = 'ShipmentName'
      KeyFields = 'ShipmentId'
      Size = 100
      Lookup = True
    end
    object FDTable_DocPlaceName: TStringField
      DisplayLabel = #1052#1077#1089#1090#1086' '#1093#1088#1072#1085#1077#1085#1080#1103
      FieldKind = fkLookup
      FieldName = 'PlaceName'
      LookupDataSet = FDQuery_DocPlace
      LookupKeyFields = 'PlaceId'
      LookupResultField = 'PlaceName'
      KeyFields = 'PlaceId'
      Size = 100
      Lookup = True
    end
    object FDTable_DocWarehouseId: TLargeintField
      FieldName = 'WarehouseId'
      Origin = 'WarehouseId'
      Visible = False
    end
    object FDTable_DocWarehouseName: TStringField
      DisplayLabel = #1057#1082#1083#1072#1076
      FieldKind = fkLookup
      FieldName = 'WarehouseName'
      LookupDataSet = FDQuery_DocWarehouse
      LookupKeyFields = 'WarehouseId'
      LookupResultField = 'WarehouseName'
      KeyFields = 'WarehouseId'
      Size = 100
      Lookup = True
    end
  end
  object FDQuery_DocType: TFDQuery
    Connection = FDConnection
    SQL.Strings = (
      'SELECT        NULL AS DocTypeId, '#39#39' AS DocTypeName'
      'UNION'
      'SELECT        1, '#39#1055#1088#1080#1093#1086#1076#39' '
      'UNION'
      'SELECT        2, '#39#1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077#39' '
      'UNION'
      'SELECT        3, '#39#1056#1072#1089#1093#1086#1076#39' '
      '')
    Left = 248
    Top = 256
    object FDQuery_DocTypeDocTypeId: TIntegerField
      FieldName = 'DocTypeId'
      Origin = 'DocTypeId'
      ReadOnly = True
    end
    object FDQuery_DocTypeDocTypeName: TStringField
      FieldName = 'DocTypeName'
      Origin = 'DocTypeName'
      ReadOnly = True
      Required = True
      Size = 11
    end
  end
  object FDTable_DocLink: TFDTable
    BeforeOpen = FDTable_DocLinkBeforeOpen
    AfterClose = FDTable_DocLinkAfterClose
    Connection = FDConnection
    UpdateOptions.UpdateTableName = 'DocLink'
    TableName = 'DocLink'
    Left = 136
    Top = 312
    object FDTable_DocLinkDocId: TLargeintField
      FieldName = 'DocId'
      Origin = 'DocId'
      Required = True
      Visible = False
    end
    object FDTable_DocLinkGoodsId: TLargeintField
      FieldName = 'GoodsId'
      Origin = 'GoodsId'
      Required = True
      Visible = False
    end
    object FDTable_DocLinkDocTypeName: TStringField
      DisplayLabel = #1058#1080#1087' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
      FieldKind = fkLookup
      FieldName = 'DocTypeName'
      LookupDataSet = FDQuery_DocLinkDocType
      LookupKeyFields = 'DocId'
      LookupResultField = 'DocTypeName'
      KeyFields = 'DocId'
      ReadOnly = True
      Size = 50
      Lookup = True
    end
    object FDTable_DocLinkDocName: TStringField
      DisplayLabel = #1044#1086#1082#1091#1084#1077#1085#1090
      FieldKind = fkLookup
      FieldName = 'DocName'
      LookupDataSet = FDQuery_DocLinkDoc
      LookupKeyFields = 'DocId'
      LookupResultField = 'DocName'
      KeyFields = 'DocId'
      Size = 254
      Lookup = True
    end
    object FDTable_DocLinkGoodsName: TStringField
      DisplayLabel = #1058#1086#1074#1072#1088
      FieldKind = fkLookup
      FieldName = 'GoodsName'
      LookupDataSet = FDQuery_DocLinkGoods
      LookupKeyFields = 'GoodsId'
      LookupResultField = 'GoodsInfo'
      KeyFields = 'GoodsId'
      Size = 254
      Lookup = True
    end
    object FDTable_DocLinkShipmentName: TStringField
      DisplayLabel = #1055#1072#1088#1090#1080#1103' '#1090#1086#1074#1072#1088#1072
      FieldKind = fkLookup
      FieldName = 'ShipmentName'
      LookupDataSet = FDQuery_DocLinkShipment
      LookupKeyFields = 'DocId'
      LookupResultField = 'ShipmentName'
      KeyFields = 'DocId'
      ReadOnly = True
      Size = 100
      Lookup = True
    end
    object FDTable_DocLinkPlacePath: TStringField
      DisplayLabel = #1057#1082#1083#1072#1076
      FieldKind = fkLookup
      FieldName = 'WarehouseName'
      LookupDataSet = FDQuery_DocLinkWarehouse
      LookupKeyFields = 'DocId'
      LookupResultField = 'WarehouseName'
      KeyFields = 'DocId'
      ReadOnly = True
      Lookup = True
    end
    object FDTable_DocLinkPlaceName: TStringField
      DisplayLabel = #1052#1077#1089#1090#1086' '#1093#1088#1072#1085#1077#1085#1080#1103
      FieldKind = fkLookup
      FieldName = 'PlaceName'
      LookupDataSet = FDQuery_DocLinkPlace
      LookupKeyFields = 'DocId'
      LookupResultField = 'PlaceName'
      KeyFields = 'DocId'
      ReadOnly = True
      Size = 100
      Lookup = True
    end
    object FDTable_DocLinkCount: TLargeintField
      DisplayLabel = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086
      FieldName = 'Count'
      Origin = 'Count'
      Required = True
    end
  end
  object FDQuery_DocShipment: TFDQuery
    Connection = FDConnection
    SQL.Strings = (
      'SELECT        NULL AS ShipmentId, '#39#39' AS ShipmentName'
      'UNION'
      'SELECT        ShipmentId, ShipmentName'
      'FROM            Shipment'
      'ORDER BY ShipmentName')
    Left = 480
    Top = 256
    object FDQuery_DocShipmentShipmentId: TLargeintField
      FieldName = 'ShipmentId'
      Origin = 'ShipmentId'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      ReadOnly = True
    end
    object FDQuery_DocShipmentShipmentName: TWideStringField
      FieldName = 'ShipmentName'
      Origin = 'ShipmentName'
      ReadOnly = True
      Size = 100
    end
  end
  object FDQuery_DocLinkDoc: TFDQuery
    Connection = FDConnection
    SQL.Strings = (
      
        'SELECT        DocId, ISNULL(DocName, '#39#39') + '#39' '#1086#1090' '#39' + CONVERT(varc' +
        'har, DocDate, 4) AS DocName'
      'FROM            Doc'
      'ORDER BY DocName, DocDate'
      '')
    Left = 264
    Top = 328
    object FDQuery_DocLinkDocDocId: TLargeintField
      AutoGenerateValue = arAutoInc
      FieldName = 'DocId'
      Origin = 'DocId'
      ProviderFlags = [pfInWhere, pfInKey]
      ReadOnly = True
    end
    object FDQuery_DocLinkDocDocName: TWideStringField
      FieldName = 'DocName'
      Origin = 'DocName'
      ReadOnly = True
      Size = 134
    end
  end
  object FDQuery_DocLinkGoods: TFDQuery
    Connection = FDConnection
    SQL.Strings = (
      
        'SELECT        GoodsId, GoodsArticle, GoodsName, GoodsSize, Goods' +
        'Cost, ISNULL(GoodsArticle, '#39#39') + '#39' '#39' + ISNULL(GoodsName, '#39#39') AS ' +
        'GoodsInfo'
      'FROM            Goods'
      '')
    Left = 416
    Top = 328
    object FDQuery_DocLinkGoodsGoodsId: TLargeintField
      AutoGenerateValue = arAutoInc
      FieldName = 'GoodsId'
      Origin = 'GoodsId'
      ProviderFlags = [pfInWhere, pfInKey]
      ReadOnly = True
    end
    object FDQuery_DocLinkGoodsGoodsArticle: TWideStringField
      FieldName = 'GoodsArticle'
      Origin = 'GoodsArticle'
      Required = True
      FixedChar = True
      Size = 13
    end
    object FDQuery_DocLinkGoodsGoodsName: TWideStringField
      FieldName = 'GoodsName'
      Origin = 'GoodsName'
      Size = 100
    end
    object FDQuery_DocLinkGoodsGoodsSize: TFloatField
      FieldName = 'GoodsSize'
      Origin = 'GoodsSize'
    end
    object FDQuery_DocLinkGoodsGoodsCost: TFloatField
      FieldName = 'GoodsCost'
      Origin = 'GoodsCost'
    end
    object FDQuery_DocLinkGoodsGoodsInfo: TWideStringField
      FieldName = 'GoodsInfo'
      Origin = 'GoodsInfo'
      ReadOnly = True
      Required = True
      Size = 114
    end
  end
  object FDQuery_DocLinkWarehouse: TFDQuery
    Connection = FDConnection
    SQL.Strings = (
      
        'SELECT        Doc.DocId, Warehouse.WarehouseName, Doc.WarehouseI' +
        'd'
      'FROM            Doc LEFT OUTER JOIN'
      
        '                         Warehouse ON Doc.WarehouseId = Warehous' +
        'e.WarehouseId')
    Left = 264
    Top = 376
    object FDQuery_DocLinkWarehouseDocId: TLargeintField
      AutoGenerateValue = arAutoInc
      FieldName = 'DocId'
      Origin = 'DocId'
      ProviderFlags = [pfInWhere, pfInKey]
      ReadOnly = True
    end
    object FDQuery_DocLinkWarehouseWarehouseName: TWideStringField
      FieldName = 'WarehouseName'
      Origin = 'WarehouseName'
      Size = 100
    end
    object FDQuery_DocLinkWarehouseWarehouseId: TLargeintField
      FieldName = 'WarehouseId'
      Origin = 'WarehouseId'
    end
  end
  object FDQuery_DocLinkDocType: TFDQuery
    Connection = FDConnection
    SQL.Strings = (
      'SELECT        Doc.DocId, Doc.DocType, tDocTypeName.DocTypeName'
      
        'FROM            (SELECT        NULL AS DocTypeId, '#39#1076#1086#1082#1091#1084#1077#1085#1090#39' AS ' +
        'DocTypeName'
      '                          UNION'
      
        '                          SELECT        1 AS DocTypeId, '#39#1055#1088#1080#1093#1086#1076#39 +
        ' AS DocTypeName'
      '                          UNION'
      
        '                          SELECT        2 AS DocTypeId, '#39#1055#1077#1088#1077#1084#1077#1097 +
        #1077#1085#1080#1077#39' AS DocTypeName'
      '                          UNION'
      
        '                          SELECT        3 AS DocTypeId, '#39#1056#1072#1089#1093#1086#1076#39 +
        ' AS DocTypeName) AS tDocTypeName RIGHT OUTER JOIN'
      
        '                         Doc ON tDocTypeName.DocTypeId = Doc.Doc' +
        'Type'
      '')
    Left = 568
    Top = 376
    object FDQuery_DocLinkDocTypeDocId: TLargeintField
      AutoGenerateValue = arAutoInc
      FieldName = 'DocId'
      Origin = 'DocId'
      ProviderFlags = [pfInWhere]
      ReadOnly = True
    end
    object FDQuery_DocLinkDocTypeDocType: TLargeintField
      FieldName = 'DocType'
      Origin = 'DocType'
    end
    object FDQuery_DocLinkDocTypeDocTypeName: TStringField
      FieldName = 'DocTypeName'
      Origin = 'DocTypeName'
      ReadOnly = True
      Size = 11
    end
  end
  object FDQuery_findleftovers: TFDQuery
    BeforeOpen = FDQuery_findleftoversBeforeOpen
    AfterClose = FDQuery_findleftoversAfterClose
    Connection = FDConnection
    SQL.Strings = (
      'DECLARE @PLIMIT bigint = :PLIMIT'
      'DECLARE @PGOODS bigint = :PGOODS'
      'DECLARE @PARTICLE varchar(100) = :PARTICLE'
      'DECLARE @PNAME varchar(100) = :PNAME'
      ''
      'DECLARE @PDATE bigint = :PDATE'
      'DECLARE @PWAREHOUSE bigint = :PWAREHOUSE'
      'DECLARE @PPLACE bigint = :PPLACE'
      'DECLARE @PSHIPMENT bigint = :PSHIPMENT'
      ''
      'SELECT TOP(@PLIMIT) * FROM ('
      ''
      'SELECT DocGoods.GoodsId'
      ', Doc.WarehouseId'
      ', Doc.PlaceId'
      ', Doc.ShipmentId'
      ', MIN(Doc.DocDate) AS DocDate'
      ', SUM(DocLink.Count) AS GoodsCount'
      ''
      'FROM            DocLink RIGHT OUTER JOIN'
      '                             ('
      #9#9#9#9#9#9#9'   SELECT GoodsId'
      '                               FROM Goods'
      '                               WHERE (@PGOODS=GoodsId) OR ('
      '                                (@PGOODS=0)'
      
        ' '#9#9#9#9#9#9#9#9#9'             AND ( (@PARTICLE = '#39#39') OR (@PARTICLE = RT' +
        'RIM(isnull(GoodsArticle,'#39#39')) ))'
      
        #9#9#9#9#9#9#9#9#9'             AND ( (@PNAME = '#39#39') OR (@PNAME = RTRIM(isn' +
        'ull(GoodsName,'#39#39'))) )'
      #9#9#9#9#9#9#9#9')'
      #9#9#9#9#9#9'     ) AS DocGoods'
      
        '                ON DocLink.GoodsId = DocGoods.GoodsId LEFT OUTER' +
        ' JOIN Doc ON DocLink.DocId = Doc.DocId'
      ''
      
        'WHERE ((@PDATE=0) OR (@PDATE > round(convert(float, isnull(Doc.D' +
        'ocDate,0),0),0,1)+1))'
      'AND((@PSHIPMENT=0) OR (@PSHIPMENT = Doc.ShipmentId))'
      'AND((@PPLACE=0) OR (@PPLACE = Doc.PlaceId))'
      'AND((@PWAREHOUSE=0) OR (@PWAREHOUSE = Doc.WarehouseId))'
      ''
      'GROUP BY DocGoods.GoodsId'
      ', Doc.WarehouseId'
      ', Doc.PlaceId'
      ', Doc.ShipmentId'
      ''
      ') AS T1'
      ''
      'WHERE (@PLIMIT<1) OR (GoodsCount>0)'
      ''
      'ORDER BY DocDate')
    Left = 472
    Top = 64
    ParamData = <
      item
        Name = 'PLIMIT'
        DataType = ftLargeint
        ParamType = ptInput
        Value = 1
      end
      item
        Name = 'PGOODS'
        DataType = ftLargeint
        ParamType = ptInput
        Value = 0
      end
      item
        Name = 'PARTICLE'
        DataType = ftWideString
        ParamType = ptInput
        Value = ''
      end
      item
        Name = 'PNAME'
        DataType = ftWideString
        ParamType = ptInput
        Value = ''
      end
      item
        Name = 'PDATE'
        DataType = ftLargeint
        ParamType = ptInput
        Value = 0
      end
      item
        Name = 'PWAREHOUSE'
        DataType = ftLargeint
        ParamType = ptInput
        Value = 0
      end
      item
        Name = 'PPLACE'
        DataType = ftLargeint
        ParamType = ptInput
        Value = 0
      end
      item
        Name = 'PSHIPMENT'
        DataType = ftLargeint
        ParamType = ptInput
        Value = '0'
      end>
    object FDQuery_findleftoversGoodsId: TLargeintField
      AutoGenerateValue = arAutoInc
      FieldName = 'GoodsId'
      Origin = 'GoodsId'
      ProviderFlags = [pfInWhere]
      ReadOnly = True
      Visible = False
    end
    object FDQuery_findleftoversWarehouseId: TLargeintField
      FieldName = 'WarehouseId'
      Origin = 'WarehouseId'
      Visible = False
    end
    object FDQuery_findleftoversPlaceId: TLargeintField
      FieldName = 'PlaceId'
      Origin = 'PlaceId'
      Visible = False
    end
    object FDQuery_findleftoversShipmentId: TLargeintField
      FieldName = 'ShipmentId'
      Origin = 'ShipmentId'
      ReadOnly = True
      Visible = False
    end
    object FDQuery_findleftoversWarehouseName: TStringField
      DisplayLabel = #1057#1082#1083#1072#1076
      FieldKind = fkLookup
      FieldName = 'WarehouseName'
      LookupDataSet = FDQuery_findleftovers_warehouse
      LookupKeyFields = 'WarehouseId'
      LookupResultField = 'WarehouseName'
      KeyFields = 'WarehouseId'
      Size = 100
      Lookup = True
    end
    object FDQuery_findleftoversPlaceName: TStringField
      DisplayLabel = #1052#1077#1089#1090#1086' '#1093#1088#1072#1085#1077#1085#1080#1103
      FieldKind = fkLookup
      FieldName = 'PlaceName'
      LookupDataSet = FDQuery_findleftovers_place
      LookupKeyFields = 'PlaceId'
      LookupResultField = 'PlaceName'
      KeyFields = 'PlaceId'
      Size = 100
      Lookup = True
    end
    object FDQuery_findleftoversShipmentName: TStringField
      DisplayLabel = #1055#1072#1088#1090#1080#1103' '#1090#1086#1074#1072#1088#1072
      FieldKind = fkLookup
      FieldName = 'ShipmentName'
      LookupDataSet = FDQuery_findleftovers_shipment
      LookupKeyFields = 'ShipmentId'
      LookupResultField = 'ShipmentName'
      KeyFields = 'ShipmentId'
      Size = 100
      Lookup = True
    end
    object FDQuery_findleftoversDocDate: TSQLTimeStampField
      DisplayLabel = #1055#1086#1089#1090#1091#1087#1083#1077#1085#1080#1077
      FieldName = 'DocDate'
      Origin = 'DocDate'
      ReadOnly = True
    end
    object FDQuery_findleftoversGoodsTitle: TStringField
      DisplayLabel = #1058#1086#1074#1072#1088
      FieldKind = fkLookup
      FieldName = 'GoodsTitle'
      LookupDataSet = FDQuery_findleftovers_goods
      LookupKeyFields = 'GoodsId'
      LookupResultField = 'GoodsTitle'
      KeyFields = 'GoodsId'
      Size = 100
      Lookup = True
    end
    object FDQuery_findleftoversGoodsCount: TLargeintField
      DisplayLabel = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086
      FieldName = 'GoodsCount'
      Origin = 'GoodsCount'
      ReadOnly = True
    end
  end
  object FDQuery_DocWarehouse: TFDQuery
    Connection = FDConnection
    SQL.Strings = (
      'SELECT        NULL AS WarehouseId, '#39#39' AS WarehouseName'
      'UNION'
      'SELECT        WarehouseId, WarehouseName'
      'FROM            Warehouse')
    Left = 616
    Top = 256
    object FDQuery_DocWarehouseWarehouseId: TLargeintField
      FieldName = 'WarehouseId'
      Origin = 'WarehouseId'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      ReadOnly = True
    end
    object FDQuery_DocWarehouseWarehouseName: TWideStringField
      FieldName = 'WarehouseName'
      Origin = 'WarehouseName'
      ReadOnly = True
      Size = 100
    end
  end
  object FDQuery_DocLinkShipment: TFDQuery
    Connection = FDConnection
    SQL.Strings = (
      'SELECT        Doc.DocId, Shipment.ShipmentName, Doc.ShipmentId'
      'FROM            Doc LEFT OUTER JOIN'
      
        '                         Shipment ON Doc.ShipmentId = Shipment.S' +
        'hipmentId')
    Left = 416
    Top = 376
    object FDQuery_DocLinkShipmentDocId: TLargeintField
      AutoGenerateValue = arAutoInc
      FieldName = 'DocId'
      Origin = 'DocId'
      ProviderFlags = [pfInWhere, pfInKey]
      ReadOnly = True
    end
    object FDQuery_DocLinkShipmentShipmentName: TWideStringField
      FieldName = 'ShipmentName'
      Origin = 'ShipmentName'
      Size = 100
    end
    object FDQuery_DocLinkShipmentShipmentId: TLargeintField
      FieldName = 'ShipmentId'
      Origin = 'ShipmentId'
    end
  end
  object FDQuery_DocLinkPlace: TFDQuery
    Connection = FDConnection
    SQL.Strings = (
      'SELECT        Doc.DocId, Place.PlaceName, Doc.PlaceId'
      'FROM            Doc LEFT OUTER JOIN'
      '                         Place ON Doc.PlaceId = Place.PlaceId')
    Left = 264
    Top = 432
    object FDQuery_DocLinkPlaceDocId: TLargeintField
      AutoGenerateValue = arAutoInc
      FieldName = 'DocId'
      Origin = 'DocId'
      ProviderFlags = [pfInWhere, pfInKey]
      ReadOnly = True
    end
    object FDQuery_DocLinkPlacePlaceName: TWideStringField
      FieldName = 'PlaceName'
      Origin = 'PlaceName'
      Size = 100
    end
    object FDQuery_DocLinkPlacePlaceId: TLargeintField
      FieldName = 'PlaceId'
      Origin = 'PlaceId'
    end
  end
  object FDQuery_findleftovers_warehouse: TFDQuery
    Connection = FDConnection
    SQL.Strings = (
      'SELECT        NULL AS WarehouseId, '#39#39' AS WarehouseName'
      'UNION'
      'SELECT        WarehouseId, WarehouseName'
      'FROM            Warehouse')
    Left = 600
    Top = 56
    object FDQuery_findleftovers_warehouseWarehouseId: TLargeintField
      FieldName = 'WarehouseId'
      Origin = 'WarehouseId'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      ReadOnly = True
    end
    object FDQuery_findleftovers_warehouseWarehouseName: TWideStringField
      FieldName = 'WarehouseName'
      Origin = 'WarehouseName'
      ReadOnly = True
      Size = 100
    end
  end
  object FDQuery_findleftovers_shipment: TFDQuery
    Connection = FDConnection
    SQL.Strings = (
      'SELECT        NULL AS ShipmentId, '#39#39' AS ShipmentName'
      'UNION'
      'SELECT        ShipmentId, ShipmentName'
      'FROM            Shipment'
      'ORDER BY ShipmentName')
    Left = 600
    Top = 104
    object FDQuery_findleftovers_shipmentShipmentId: TLargeintField
      FieldName = 'ShipmentId'
      Origin = 'ShipmentId'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      ReadOnly = True
    end
    object FDQuery_findleftovers_shipmentShipmentName: TWideStringField
      FieldName = 'ShipmentName'
      Origin = 'ShipmentName'
      ReadOnly = True
      Size = 100
    end
  end
  object FDQuery_findleftovers_place: TFDQuery
    Connection = FDConnection
    SQL.Strings = (
      'SELECT        NULL AS PlaceId, '#39#39' AS PlaceName'
      'UNION'
      'SELECT        PlaceId, PlaceName'
      'FROM            Place ')
    Left = 600
    Top = 8
    object FDQuery_findleftovers_placePlaceId: TLargeintField
      FieldName = 'PlaceId'
      Origin = 'PlaceId'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      ReadOnly = True
    end
    object FDQuery_findleftovers_placePlaceName: TWideStringField
      FieldName = 'PlaceName'
      Origin = 'PlaceName'
      ReadOnly = True
      Size = 100
    end
  end
  object FDQuery_findleftovers_goods: TFDQuery
    Connection = FDConnection
    SQL.Strings = (
      'SELECT        NULL AS GoodsId, '#39#39' AS GoodsTitle'
      'UNION'
      
        'SELECT        GoodsId, ISNULL(GoodsName, '#39#39') + '#39' '#1072#1088#1090'.'#39' + ISNULL(' +
        'GoodsArticle, '#39#39') AS GoodsTitle'
      'FROM            Goods')
    Left = 600
    Top = 152
    object FDQuery_findleftovers_goodsGoodsId: TLargeintField
      FieldName = 'GoodsId'
      Origin = 'GoodsId'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      ReadOnly = True
    end
    object FDQuery_findleftovers_goodsGoodsTitle: TWideStringField
      FieldName = 'GoodsTitle'
      Origin = 'GoodsTitle'
      ReadOnly = True
      Required = True
      Size = 118
    end
  end
end
