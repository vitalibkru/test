unit form_dm;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.MySQL,
  FireDAC.Phys.MySQLDef, FireDAC.VCLUI.Wait, FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.VCLUI.Login, FireDAC.Comp.UI,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, FireDAC.Phys.MSSQLDef,
  FireDAC.Phys.ODBCBase, FireDAC.Phys.MSSQL, strtools, docparam;

type
  TFDM = class(TDataModule)
    FDConnection: TFDConnection;
    FDTable_Goods: TFDTable;
    FDTable_Warehouse: TFDTable;
    FDTable_Place: TFDTable;
    FDPhysMSSQLDriverLink: TFDPhysMSSQLDriverLink;
    FDGUIxWaitCursor: TFDGUIxWaitCursor;
    FDTable_WarehouseWarehouseId: TLargeintField;
    FDTable_WarehouseWarehouseName: TWideStringField;
    FDTable_PlacePlaceId: TLargeintField;
    FDTable_PlacePlaceName: TWideStringField;
    FDQuery_PlaceWarehouse: TFDQuery;
    FDTable_PlaceWarehouseName: TStringField;
    FDQuery_DocPlace: TFDQuery;
    FDTable_Shipment: TFDTable;
    FDTable_Doc: TFDTable;
    FDTable_DocDocId: TLargeintField;
    FDTable_DocDocName: TWideStringField;
    FDQuery_DocType: TFDQuery;
    FDTable_DocDocType: TLargeintField;
    FDQuery_DocTypeDocTypeId: TIntegerField;
    FDQuery_DocTypeDocTypeName: TStringField;
    FDTable_DocDocTypeName: TStringField;
    FDTable_DocDocDate: TSQLTimeStampField;
    FDTable_ShipmentShipmentId: TLargeintField;
    FDTable_ShipmentShipmentName: TWideStringField;
    FDTable_PlaceWarehouseId: TLargeintField;
    FDTable_GoodsGoodsId: TLargeintField;
    FDTable_GoodsGoodsArticle: TWideStringField;
    FDTable_GoodsGoodsName: TWideStringField;
    FDTable_GoodsGoodsCost: TFloatField;
    FDTable_GoodsGoodsSize: TFloatField;
    FDTable_DocLink: TFDTable;
    FDTable_DocLinkDocId: TLargeintField;
    FDTable_DocLinkGoodsId: TLargeintField;
    FDTable_DocLinkCount: TLargeintField;
    FDQuery_DocPlacePlaceId: TLargeintField;
    FDQuery_PlaceWarehouseWarehouseId: TLargeintField;
    FDQuery_PlaceWarehouseWarehouseName: TWideStringField;
    FDTable_DocShipmentId: TLargeintField;
    FDTable_DocPlaceId: TLargeintField;
    FDQuery_DocShipment: TFDQuery;
    FDQuery_DocShipmentShipmentId: TLargeintField;
    FDQuery_DocShipmentShipmentName: TWideStringField;
    FDTable_DocShipmentName: TStringField;
    FDTable_DocPlaceName: TStringField;
    FDQuery_DocLinkDoc: TFDQuery;
    FDTable_DocLinkDocName: TStringField;
    FDQuery_DocLinkGoods: TFDQuery;
    FDQuery_DocLinkGoodsGoodsId: TLargeintField;
    FDQuery_DocLinkGoodsGoodsArticle: TWideStringField;
    FDQuery_DocLinkGoodsGoodsName: TWideStringField;
    FDQuery_DocLinkGoodsGoodsSize: TFloatField;
    FDQuery_DocLinkGoodsGoodsCost: TFloatField;
    FDQuery_DocLinkGoodsGoodsInfo: TWideStringField;
    FDTable_DocLinkGoodsName: TStringField;
    FDTable_DocLinkShipmentName: TStringField;
    FDQuery_DocLinkWarehouse: TFDQuery;
    FDTable_DocLinkPlacePath: TStringField;
    FDQuery_DocLinkDocDocId: TLargeintField;
    FDQuery_DocLinkDocDocName: TWideStringField;
    FDQuery_DocLinkDocType: TFDQuery;
    FDQuery_DocLinkDocTypeDocId: TLargeintField;
    FDQuery_DocLinkDocTypeDocType: TLargeintField;
    FDQuery_DocLinkDocTypeDocTypeName: TStringField;
    FDTable_DocLinkDocTypeName: TStringField;
    FDQuery_findleftovers: TFDQuery;
    FDTable_DocWarehouseId: TLargeintField;
    FDQuery_DocWarehouse: TFDQuery;
    FDQuery_DocPlacePlaceName: TWideStringField;
    FDQuery_DocWarehouseWarehouseId: TLargeintField;
    FDQuery_DocWarehouseWarehouseName: TWideStringField;
    FDTable_DocWarehouseName: TStringField;
    FDQuery_DocLinkShipment: TFDQuery;
    FDQuery_DocLinkShipmentDocId: TLargeintField;
    FDQuery_DocLinkShipmentShipmentName: TWideStringField;
    FDQuery_DocLinkShipmentShipmentId: TLargeintField;
    FDQuery_DocLinkWarehouseDocId: TLargeintField;
    FDQuery_DocLinkWarehouseWarehouseName: TWideStringField;
    FDQuery_DocLinkWarehouseWarehouseId: TLargeintField;
    FDQuery_DocLinkPlace: TFDQuery;
    FDQuery_DocLinkPlaceDocId: TLargeintField;
    FDQuery_DocLinkPlacePlaceName: TWideStringField;
    FDQuery_DocLinkPlacePlaceId: TLargeintField;
    FDTable_DocLinkPlaceName: TStringField;
    FDQuery_findleftoversGoodsId: TLargeintField;
    FDQuery_findleftoversWarehouseId: TLargeintField;
    FDQuery_findleftoversPlaceId: TLargeintField;
    FDQuery_findleftoversShipmentId: TLargeintField;
    FDQuery_findleftoversDocDate: TSQLTimeStampField;
    FDQuery_findleftoversGoodsCount: TLargeintField;
    FDQuery_findleftovers_warehouse: TFDQuery;
    FDQuery_findleftovers_warehouseWarehouseId: TLargeintField;
    FDQuery_findleftovers_warehouseWarehouseName: TWideStringField;
    FDQuery_findleftovers_shipment: TFDQuery;
    FDQuery_findleftovers_shipmentShipmentId: TLargeintField;
    FDQuery_findleftovers_shipmentShipmentName: TWideStringField;
    FDQuery_findleftovers_place: TFDQuery;
    FDQuery_findleftovers_placePlaceId: TLargeintField;
    FDQuery_findleftovers_placePlaceName: TWideStringField;
    FDQuery_findleftoversWarehouseName: TStringField;
    FDQuery_findleftoversPlaceName: TStringField;
    FDQuery_findleftoversShipmentName: TStringField;
    FDQuery_findleftovers_goods: TFDQuery;
    FDQuery_findleftovers_goodsGoodsId: TLargeintField;
    FDQuery_findleftovers_goodsGoodsTitle: TWideStringField;
    FDQuery_findleftoversGoodsTitle: TStringField;
    procedure FDTable_PlaceAfterClose(DataSet: TDataSet);
    procedure FDTable_PlaceBeforeOpen(DataSet: TDataSet);
    procedure FDConnectionChangeState(Sender: TObject);
    procedure FDTable_DocAfterClose(DataSet: TDataSet);
    procedure FDTable_DocBeforeOpen(DataSet: TDataSet);
    procedure FDTable_DocLinkAfterClose(DataSet: TDataSet);
    procedure FDTable_DocLinkBeforeOpen(DataSet: TDataSet);
    procedure FDQuery_findleftoversAfterClose(DataSet: TDataSet);
    procedure FDQuery_findleftoversBeforeOpen(DataSet: TDataSet);
  private
    FOnChangeState: TNotifyEvent;
    function GetConnected: boolean;
    function CheckConnectionParams: boolean;
    procedure SetConnectionParam(const ParamName: string; const Value: string);
  public
    procedure Connect;
    procedure Disconnect;
    procedure SetConnectionParams(Sender: TObject);
    procedure GetConnectionParams(Sender: TObject);
    property Connected: boolean read GetConnected;
    property OnChangeState: TNotifyEvent read FOnChangeState write FOnChangeState;
    procedure QueryDictionary(const DictName: string; DictData: TStrings; const Where: string);
  public
    function find_value(ATableName,AKeyName: string; AWhere: string): Cardinal;
    function find_value2(ATableName: string; ValueId,ValueName: string): Cardinal;
    function select_place(WarehouseId: Cardinal; Like: string): Cardinal;
    function insert_shipment(ShipmentName: string): Cardinal;
    function insert_shipment2(ShipmentId,ShipmentName: string): Cardinal;
    function insert_doc(DocType: Cardinal; DocName: string; DocDate: TDateTime; DocShipment, DocWarehouse, DocPlace: Cardinal): Cardinal;
    function insert_goods(GoodsArticle: string; Values: TStrings): Cardinal;
    function insert_doclink(ADocId,AGoodsId: Cardinal; ACount: integer): Cardinal;
    function find_leftovers(ADate: TDateTime; AGoods: TGoods): Integer;
  end;

var
  FDM: TFDM;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

//TFDM

function TFDM.GetConnected: boolean;
begin
Result := FDConnection.Connected;
end;

procedure TFDM.Connect;
begin
if not Connected then
if CheckConnectionParams then begin
  try
    FDConnection.Connected := true;
  except

  end;
end;
end;

procedure TFDM.Disconnect;
begin
if Connected then begin
  FDConnection.Connected := false;
end;
end;

procedure TFDM.SetConnectionParam(const ParamName: string; const Value: string);
begin
if Value<>'' then begin
  FDConnection.Params.Values[ParamName] := Value;
end;
end;

function TFDM.CheckConnectionParams: boolean;
begin
Result := False;
if Trim(FDConnection.Params.Values['Server'])<>'' then;
if Trim(FDConnection.Params.Values['Database'])<>'' then;
if Trim(FDConnection.Params.Values['User_Name'])<>'' then;
if Trim(FDConnection.Params.Values['Password'])<>'' then begin
  Result := True;
end;
end;

procedure TFDM.SetConnectionParams(Sender: TObject);
var conn: boolean;
begin
conn := Connected;
Disconnect;
with TStrings(Sender) do begin
  SetConnectionParam('Server', Trim(Values['Database\Server']));
  SetConnectionParam('Database', Trim(Values['Database\Name']));
  SetConnectionParam('User_Name', Trim(Values['Database\Account']));
  SetConnectionParam('Password', Trim(Values['Database\Password']));
end;
if conn then begin
  Connect;
end;
end;

procedure TFDM.GetConnectionParams(Sender: TObject);
begin
with TStrings(Sender) do begin
  Values['Database\Server'] := FDConnection.Params.Values['Server'];
  Values['Database\Name'] := FDConnection.Params.Values['Database'];
  Values['Database\Account'] := FDConnection.Params.Values['User_Name'];
  Values['Database\Password'] := FDConnection.Params.Values['Password'];
end;
end;

procedure TFDM.FDConnectionChangeState(Sender: TObject);
begin
if Assigned(FOnChangeState) then FOnChangeState(Self);
end;

procedure TFDM.FDQuery_findleftoversAfterClose(DataSet: TDataSet);
begin
FDQuery_findleftovers_place.Close;
FDQuery_findleftovers_warehouse.Close;
FDQuery_findleftovers_shipment.Close;
FDQuery_findleftovers_goods.Close;
end;

procedure TFDM.FDQuery_findleftoversBeforeOpen(DataSet: TDataSet);
begin
FDQuery_findleftovers_place.Open;
FDQuery_findleftovers_warehouse.Open;
FDQuery_findleftovers_shipment.Open;
FDQuery_findleftovers_goods.Open;
end;

procedure TFDM.FDTable_DocAfterClose(DataSet: TDataSet);
begin
FDQuery_DocType.Close;
FDQuery_DocPlace.Close;
FDQuery_DocShipment.Close;
FDQuery_DocWarehouse.Close;
end;

procedure TFDM.FDTable_DocBeforeOpen(DataSet: TDataSet);
begin
FDQuery_DocType.Open;
FDQuery_DocPlace.Open;
FDQuery_DocShipment.Open;
FDQuery_DocWarehouse.Open;
end;

procedure TFDM.FDTable_DocLinkAfterClose(DataSet: TDataSet);
begin
FDQuery_DocLinkGoods.Close;
FDQuery_DocLinkDoc.Close;
FDQuery_DocLinkShipment.Close;
FDQuery_DocLinkDocType.Close;
FDQuery_DocLinkWarehouse.Close;
FDQuery_DocLinkPlace.Close;
end;

procedure TFDM.FDTable_DocLinkBeforeOpen(DataSet: TDataSet);
begin
FDQuery_DocLinkGoods.Open;
FDQuery_DocLinkDoc.Open;
FDQuery_DocLinkShipment.Open;
FDQuery_DocLinkDocType.Open;
FDQuery_DocLinkWarehouse.Open;
FDQuery_DocLinkPlace.Open;
end;

procedure TFDM.FDTable_PlaceAfterClose(DataSet: TDataSet);
begin
FDQuery_PlaceWarehouse.Close;
end;

procedure TFDM.FDTable_PlaceBeforeOpen(DataSet: TDataSet);
begin
FDQuery_PlaceWarehouse.Open;
end;

procedure TFDM.QueryDictionary(const DictName: string; DictData: TStrings; const Where: string);
var q: TFDQuery;
  lkey: Cardinal;
  lname: string;
begin
DictData.Clear;
DictData.AddObject('', TObject(0));
if not Connected then exit;
q := TFDQuery.Create(Self);
try
  q.Connection := FDConnection;
  q.SQL.Add(Format('select top(1000) %sId, %sName from %s', [DictName, DictName, DictName]));
  if Where<>'' then q.SQL.Add('where ('+Where+')');
  q.SQL.Add(Format('order by %sName', [DictName]));
  q.Open;
  while not q.Eof do begin
    lkey := q.Fields[0].AsLargeInt;
    lname := Trim(q.Fields[1].AsString);
    if lname<>'' then begin
      DictData.AddObject(lname, TObject(lkey));
    end;
    q.Next;
  end;
finally
  q.Free;
end;
end;

function TFDM.find_value(ATableName,AKeyName: string; AWhere: string): Cardinal;
var q: TFDQuery;
begin
Result := 0;
if not Connected then exit;
q := TFDQuery.Create(Self);
try
  q.Connection := FDConnection;
  q.SQL.Add(Format('select top(1) [%s] from [%s]', [AKeyName,ATableName]));
  q.SQL.Add(Format('where (%s)', [AWhere]));
  q.Open;
  Result := q.Fields[0].AsLargeInt;
finally
  q.Free;
end;
end;

function TFDM.find_value2(ATableName: string; ValueId,ValueName: string): Cardinal;
begin
Result := str2uint(ValueId);
if Result>0 then begin
  Result := find_value(ATableName,ATableName+'Id', Format('(%sId = %d)', [ATableName,Result]));
end;
if (Result=0) and (ValueName<>'') then begin
  Result := find_value(ATableName,ATableName+'Id', Format('(%sName = ''%s'')', [ATableName,ValueName]));
end;
end;

function TFDM.select_place(WarehouseId: Cardinal; Like: string): Cardinal;
begin
Result := 0;
if WarehouseId>0 then begin
  if Like<>'' then Result := find_value('Place', 'PlaceId', Format('((WarehouseId = %d) AND (PlaceName like ''%%%s%%''))', [WarehouseId, Like]));
  if Result=0 then Result := find_value('Place', 'PlaceId', Format('(WarehouseId = %d)', [WarehouseId]));
end;
end;

function TFDM.insert_shipment(ShipmentName: string): Cardinal;
var conn: boolean;
begin
Result := 0;
if not Connected then exit;
ShipmentName := copy(Trim(ShipmentName), 1, FDTable_Doc.FieldByName('ShipmentName').Size);
if ShipmentName<>'' then begin
  Result := find_value('Shipment','ShipmentId', Format('(ShipmentName = ''%s'')', [ShipmentName]));
  if Result>0 then exit;
  conn := FDTable_Shipment.Active;
  if not conn then FDTable_Shipment.Open;
  FDTable_Shipment.Insert;
  FDTable_Shipment.FieldByName('ShipmentName').AsString := ShipmentName;
  FDTable_Shipment.Post;
  Result := FDTable_Shipment.FieldByName('ShipmentId').AsLargeInt;
  if not conn then FDTable_Shipment.Close;
end;
end;

function TFDM.insert_shipment2(ShipmentId,ShipmentName: string): Cardinal;
begin
Result := str2uint(ShipmentId);
if Result>0 then begin
  Result := find_value('Shipment','ShipmentId', Format('(ShipmentId = %d)', [Result]));
end;
if (Result=0) and (ShipmentName<>'') then begin
  Result := insert_shipment(ShipmentName);
end;
end;

function TFDM.insert_doc(DocType: Cardinal; DocName: string; DocDate: TDateTime; DocShipment, DocWarehouse, DocPlace: Cardinal): Cardinal;
var conn: boolean;
  lwhere: string;
begin
Result := 0;
if not Connected then exit;
if DocDate<4000 then DocDate := Now();
DocName := copy(Trim(DocName), 1, FDTable_Doc.FieldByName('DocName').Size);
if (DocName<>'') and (DocDate>4000) then begin
  lwhere := Format('(DocType = %d) AND (DocName = ''%s'')', [DocType, DocName]);
  if DocDate>4000 then lwhere := Format('%s AND (convert(varchar, isnull(DocDate,''''),102) = ''%s'')', [lwhere, datetime2str(DocDate, 'yyyy.mm.dd')]);
  if DocShipment>0 then lwhere := Format('%s AND (ShipmentId = %d)', [lwhere, DocShipment]);
  if DocWarehouse>0 then lwhere := Format('%s AND (WarehouseId = %d)', [lwhere, DocWarehouse]);
  if DocPlace>0 then lwhere := Format('%s AND (PlaceId = %d)', [lwhere, DocPlace]);
  Result := find_value('Doc','DocId', lwhere);
  if Result>0 then exit;
  conn := FDTable_Doc.Active;
  if not conn then FDTable_Doc.Open;
  FDTable_Doc.Insert;
  FDTable_Doc.FieldByName('DocType').AsInteger := DocType;
  FDTable_Doc.FieldByName('DocName').AsString := DocName;
  if DocDate>4000 then FDTable_Doc.FieldByName('DocDate').AsDateTime := DocDate;
  if DocShipment>0 then FDTable_Doc.FieldByName('ShipmentId').AsLargeInt := DocShipment;
  if DocWarehouse>0 then FDTable_Doc.FieldByName('WarehouseId').AsLargeInt := DocPlace;
  if DocPlace>0 then FDTable_Doc.FieldByName('PlaceId').AsLargeInt := DocPlace;
  FDTable_Doc.Post;
  Result := FDTable_Doc.FieldByName('DocId').AsLargeInt;
  if not conn then FDTable_Doc.Close;
end;
end;

function TFDM.insert_goods(GoodsArticle: string; Values: TStrings): Cardinal;
var conn: boolean;
  lwhere,GoodsName: string;
begin
Result := 0;
if not Connected then exit;
lwhere := str2digits(Values.Values['GoodsId']);
if (lwhere<>'') then begin
  Result := find_value('Goods','GoodsId', Format('(GoodsId = %s)', [lwhere]));
  if Result>0 then exit;
end;
GoodsName := copy(Trim(Values.Values['GoodsName']), 1, FDTable_Goods.FieldByName('GoodsName').Size);
GoodsArticle := copy(Trim(GoodsArticle), 1, FDTable_Goods.FieldByName('GoodsArticle').Size);
lwhere := '';
if GoodsArticle<>'' then lwhere := Format('(GoodsArticle = ''%s'')', [GoodsArticle]);
if GoodsName<>'' then begin
  if lwhere='' then lwhere := Format('(GoodsName = ''%s'')', [GoodsName])
  else lwhere := Format('%s AND (GoodsName = ''%s'')', [lwhere,GoodsName]);
end;
if (lwhere<>'') then begin
  Result := find_value('Goods','GoodsId', lwhere);
  if Result>0 then exit;
end;
if (GoodsArticle<>'') or (GoodsName<>'') then begin
  conn := FDTable_Goods.Active;
  if not conn then FDTable_Goods.Open;
  FDTable_Goods.Insert;
  if GoodsArticle<>'' then FDTable_Goods.FieldByName('GoodsArticle').AsString := GoodsArticle;
  if GoodsArticle<>'' then FDTable_Goods.FieldByName('GoodsName').AsString := GoodsName;
  FDTable_Goods.FieldByName('GoodsCost').AsFloat := str2float(Values.Values['GoodsCost']);
  FDTable_Goods.FieldByName('GoodsSize').AsFloat := str2float(Values.Values['GoodsSize']);
  FDTable_Goods.Post;
  Result := FDTable_Goods.FieldByName('GoodsId').AsLargeInt;
  if not conn then FDTable_Goods.Close;
end;
end;

function TFDM.insert_doclink(ADocId,AGoodsId: Cardinal; ACount: integer): Cardinal;
var conn: boolean;
begin
Result := 0;
if not Connected then exit;
if (ADocId>0) and (AGoodsId>0) and (ACount<>0) then begin
  conn := FDTable_DocLink.Active;
  if not conn then FDTable_DocLink.Open;
  FDTable_DocLink.Insert;
  FDTable_DocLink.FieldByName('DocId').AsLargeInt := ADocId;
  FDTable_DocLink.FieldByName('GoodsId').AsLargeInt := AGoodsId;
  FDTable_DocLink.FieldByName('Count').AsInteger := ACount;
  FDTable_DocLink.Post;
  Result := 1;
  if not conn then FDTable_DocLink.Close;
end;
end;

function TFDM.find_leftovers(ADate: TDateTime; AGoods: TGoods): Integer;
begin
Result := 0;
if not Connected then exit;
with FDQuery_findleftovers do begin
  Close;
  Params.ParamValues['PLIMIT'] := 1;
  Params.ParamValues['PGOODS'] := AGoods.Id;
  Params.ParamValues['PARTICLE'] := AGoods.Article;
  Params.ParamValues['PNAME'] := AGoods.Name;
  Params.ParamValues['PDATE'] := round(int(ADate));
  Params.ParamValues['PWAREHOUSE'] := AGoods.WarehouseId;
  Params.ParamValues['PSHIPMENT'] := AGoods.ShipmentId;
  Open;
  Result := FieldByName('GoodsCount').AsInteger;
  if Result>0 then begin
    AGoods.Id := FieldByName('GoodsId').AsLargeInt;
    AGoods.Dictionary.Shipment.Id := FieldByName('ShipmentId').AsInteger;
    AGoods.Dictionary.Warehouse.Id := FieldByName('WarehouseId').AsInteger;
    AGoods.Dictionary.Place.Id := FieldByName('PlaceId').AsInteger;
    //AGoods.Count := FieldByName('GoodsCount').AsInteger;
    //AGoods.Cost := FieldByName('GoodsCost').AsFloat;
    //AGoods.Size := FieldByName('GoodsSize').AsFloat;
  end;
  Close;
end;
end;

end.
