unit form_find_goods;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.StdCtrls, Vcl.ExtCtrls,
  System.Actions, Vcl.ActnList, System.ImageList, Vcl.ImgList, Vcl.Buttons,
  Data.DB, Vcl.Grids, Vcl.DBGrids, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, FireDAC.UI.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool,
  FireDAC.Phys, FireDAC.Phys.MSSQL, FireDAC.Phys.MSSQLDef, FireDAC.VCLUI.Wait,
  appconfig;

type
  TQueryDictionary = procedure (const Name: string; Data: TStrings; const Where: string)of object;

  Tfrm_find_goods = class(TForm)
    Panel2: TPanel;
    Label2: TLabel;
    pnl_tools: TPanel;
    btn_file_close: TSpeedButton;
    FImages: TImageList;
    FActions: TActionList;
    act_file_apply: TAction;
    DBGrid1: TDBGrid;
    pnl_header: TPanel;
    Panel1: TPanel;
    Label1: TLabel;
    fld_docdate: TDateTimePicker;
    fld_shipment: TComboBox;
    Button2: TSpeedButton;
    act_file_refresh: TAction;
    SpeedButton1: TSpeedButton;
    FDQuery_Goods: TFDQuery;
    FDataSource: TDataSource;
    FDQuery_GoodsDoc: TFDQuery;
    FDQuery_GoodsGoodsId: TLargeintField;
    FDQuery_GoodsGoodsArticle: TWideStringField;
    FDQuery_GoodsGoodsName: TWideStringField;
    FDQuery_GoodsGoodsCost: TFloatField;
    FDQuery_GoodsGoodsSize: TFloatField;
    FDQuery_GoodsDocGoodsId: TLargeintField;
    FDQuery_GoodsDocGoodsArticle: TWideStringField;
    FDQuery_GoodsDocGoodsName: TWideStringField;
    FDQuery_GoodsDocGoodsCost: TFloatField;
    FDQuery_GoodsDocGoodsSize: TFloatField;
    FDQuery_GoodsDocShipmentId: TLargeintField;
    FDQuery_GoodsDocGoodsCount: TLargeintField;
    act_dict_query_shipment: TAction;
    FDQuery_GoodsDocShipmentName: TWideStringField;
    FDQuery_GoodsDocWarehouseId: TLargeintField;
    FDQuery_GoodsDocWarehouseName: TWideStringField;
    chk_file_refresh: TCheckBox;
    Panel3: TPanel;
    Label3: TLabel;
    SpeedButton2: TSpeedButton;
    fld_place: TComboBox;
    fld_warehouse: TComboBox;
    act_dict_query_place: TAction;
    FDQuery_GoodsDocPlaceId: TLargeintField;
    FDQuery_GoodsDocPlaceName: TWideStringField;
    procedure act_file_applyExecute(Sender: TObject);
    procedure act_dict_query_shipmentExecute(Sender: TObject);
    procedure act_file_refreshExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FDQuery_GoodsAfterOpen(DataSet: TDataSet);
    procedure FDQuery_GoodsDocAfterOpen(DataSet: TDataSet);
    procedure FDQuery_GoodsBeforeClose(DataSet: TDataSet);
    procedure FDQuery_GoodsDocBeforeClose(DataSet: TDataSet);
    procedure FormDestroy(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure SetDictReadOnly(AReadOnly: word);
    procedure act_dict_query_placeExecute(Sender: TObject);
    procedure fld_docdateChange(Sender: TObject);
    procedure fld_shipmentChange(Sender: TObject);
    procedure fld_warehouseChange(Sender: TObject);
    procedure fld_placeChange(Sender: TObject);
  private
    FConnection: TFDConnection;
    FQueryDictionary: TQueryDictionary;
    FDictReadOnly: word;
    FConfig: TAppConfig;
    procedure QueryDictionary(const DictName: string; DictData: TStrings; const Where: string);
    procedure set_key_dict(List: TComboBox; KeyDict: Cardinal);
    function get_key_dict(List: TComboBox): Cardinal;
    procedure SetConnection(AConnection: TFDConnection);
    function GetConnected: boolean;
    function GetGoodsKey: Cardinal;
    function GetFieldValue(FieldName: string): string;
    function GetDocDate: TDateTime;
    procedure SetDocDate(ADate: TDateTime);
    procedure ds_goodsRefresh();
    procedure ds_goodsdocRefresh();
    procedure dictQuery(Sender: TComboBox; DictName: string; DichWhere: string);
    function GetDictName(Index: integer): string;
    function GetDictId(Index: integer): Cardinal;
    procedure SetDictId(Index: integer; KeyDict: Cardinal);
    procedure SetConfig(AConfig: TAppConfig);
  public
    property Config: TAppConfig read FConfig write SetConfig;
    property Connection: TFDConnection read FConnection write SetConnection;
    property Connected: boolean read GetConnected;
    property Key: Cardinal read GetGoodsKey;
    property DocDate: TDateTime read GetDocDate write SetDocDate;
    property Value[FieldName: string]: string read GetFieldValue;
    property DictReadOnly: word read FDictReadOnly write SetDictReadOnly;
    property GetDictionary: TQueryDictionary read FQueryDictionary write FQueryDictionary;
    property WarehouseId: Cardinal index 0 read GetDictId write SetDictId;
    property PlaceId: Cardinal index 1 read GetDictId write SetDictId;
    property ShipmentId: Cardinal index 2 read GetDictId write SetDictId;
    property WarehouseName: string index 0 read GetDictName;
    property PlaceName: string index 1 read GetDictName;
    property ShipmentName: string index 2 read GetDictName;
  end;

implementation

{$R *.dfm}

procedure Tfrm_find_goods.FormCreate(Sender: TObject);
begin
FConfig := nil;
SetConnection(nil);
SetDictReadOnly($00);
end;

procedure Tfrm_find_goods.FormDestroy(Sender: TObject);
begin
SetConnection(nil);
end;

procedure Tfrm_find_goods.SetConfig(AConfig: TAppConfig);
begin
FConfig := AConfig;
if Assigned(FConfig) then begin
  FConfig.Read(ClassName, 'position', Self);
  FConfig.Close;
end;
end;

procedure Tfrm_find_goods.FormClose(Sender: TObject; var Action: TCloseAction);
begin
Action := caFree;
if Assigned(FConfig) then begin
  FConfig.Write(ClassName, 'position', Self);
  FConfig.Close;
end;
end;

procedure Tfrm_find_goods.SetDictReadOnly(AReadOnly: word);
begin
FDictReadOnly := AReadOnly;
fld_shipment.Enabled := (AReadOnly and $01)<>$01;
fld_warehouse.Enabled := (AReadOnly and $02)<>$02;
fld_place.Enabled := (AReadOnly and $04)<>$04;
fld_docdate.Enabled := (AReadOnly and $80)<>$80;
end;

procedure Tfrm_find_goods.FDQuery_GoodsAfterOpen(DataSet: TDataSet);
begin
if Assigned(FConfig) then begin
  FConfig.Read(ClassName, 'goods', DBGrid1);
  FConfig.Close;
end;
end;

procedure Tfrm_find_goods.FDQuery_GoodsBeforeClose(DataSet: TDataSet);
begin
if Assigned(FConfig) then begin
  FConfig.Write(ClassName, 'goods', DBGrid1);
  FConfig.Close;
end;
end;

procedure Tfrm_find_goods.FDQuery_GoodsDocAfterOpen(DataSet: TDataSet);
begin
if Assigned(FConfig) then begin
  FConfig.Read(ClassName, 'goodsdoc', DBGrid1);
  FConfig.Close;
end;
end;

procedure Tfrm_find_goods.FDQuery_GoodsDocBeforeClose(DataSet: TDataSet);
begin
if Assigned(FConfig) then begin
  FConfig.Write(ClassName, 'goodsdoc', DBGrid1);
  FConfig.Close;
end;
end;

procedure Tfrm_find_goods.fld_docdateChange(Sender: TObject);
begin
if chk_file_refresh.Checked then act_file_refresh.Execute;
end;

procedure Tfrm_find_goods.fld_placeChange(Sender: TObject);
begin
if chk_file_refresh.Checked then act_file_refresh.Execute;
end;

procedure Tfrm_find_goods.fld_shipmentChange(Sender: TObject);
begin
if chk_file_refresh.Checked then act_file_refresh.Execute;
end;

procedure Tfrm_find_goods.fld_warehouseChange(Sender: TObject);
begin
dictQuery(fld_place, 'Place', Format('WarehouseId = %d', [get_key_dict(fld_warehouse)]));
if chk_file_refresh.Checked then act_file_refresh.Execute;
end;

procedure Tfrm_find_goods.QueryDictionary(const DictName: string; DictData: TStrings; const Where: string);
begin
if Assigned(FQueryDictionary) then FQueryDictionary(DictName, DictData, Where);
end;

function Tfrm_find_goods.GetConnected: boolean;
begin
Result := false;
if Assigned(FConnection) then begin
  Result := FConnection.Connected;
end;
end;

procedure Tfrm_find_goods.SetConnection(AConnection: TFDConnection);
begin
if FDQuery_Goods.Active then FDQuery_Goods.Close;
if FDQuery_GoodsDoc.Active then FDQuery_GoodsDoc.Close;
FConnection := AConnection;
FDQuery_Goods.Connection := FConnection;
FDQuery_GoodsDoc.Connection := FConnection;
end;

function Tfrm_find_goods.get_key_dict(List: TComboBox): Cardinal;
begin
Result := 0;
if List.ItemIndex>=0 then begin
  Result := Cardinal(List.Items.Objects[List.ItemIndex]);
end;
end;

procedure Tfrm_find_goods.set_key_dict(List: TComboBox; KeyDict: Cardinal);
var j: integer;
  lkey: Cardinal;
begin
if KeyDict>0 then
for j := 0 to List.Items.Count-1 do begin
  lkey := Cardinal(List.Items.Objects[j]);
  if lkey=KeyDict then begin
    List.ItemIndex := j;
    exit;
  end;
end;
List.ItemIndex := -1;
end;

function Tfrm_find_goods.GetDocDate: TDateTime;
begin
Result := fld_docdate.Date;
end;

procedure Tfrm_find_goods.SetDocDate(ADate: TDateTime);
begin
fld_docdate.Date := ADate;
if ADate>4000 then begin
  FDataSource.DataSet := FDQuery_GoodsDoc;
  fld_docdate.Date := ADate;
end
else begin
  FDataSource.DataSet := FDQuery_Goods;
  fld_docdate.Date := Now();
end;
act_file_refresh.Execute;
end;

function Tfrm_find_goods.GetGoodsKey: Cardinal;
var ds: TDataSet;
begin
Result := 0;
if Assigned(DBGrid1.DataSource) then begin
  ds := DBGrid1.DataSource.DataSet;
  if ds.Active then begin
    Result := ds.FieldByName('GoodsId').AsLargeInt;
  end;
end;
end;

function Tfrm_find_goods.GetFieldValue(FieldName: string): string;
var ds: TDataSet;
  fld: TField;
begin
Result := '';
if FieldName<>'' then
if Assigned(DBGrid1.DataSource) then begin
  ds := DBGrid1.DataSource.DataSet;
  if ds.Active then begin
    fld := ds.FindField(FieldName);
    if Assigned(fld) then begin
      Result := Trim(fld.AsString);
    end;
  end;
end;
end;

procedure Tfrm_find_goods.act_file_applyExecute(Sender: TObject);
begin
ModalResult := mrOk;
end;

procedure Tfrm_find_goods.ds_goodsRefresh();
begin
if Connected then begin
  if FDQuery_Goods.Active then FDQuery_Goods.Close;
  FDQuery_Goods.Params.ParamValues['PDATE'] := round(int(DocDate));
  FDQuery_Goods.Params.ParamValues['PSHIPMENT'] := get_key_dict(fld_shipment);
  FDQuery_Goods.Params.ParamValues['PWAREHOUSE'] := get_key_dict(fld_warehouse);
  FDQuery_GoodsDoc.Params.ParamValues['PPLACE'] := get_key_dict(fld_place);
  FDQuery_Goods.Open;
end;
end;

procedure Tfrm_find_goods.ds_goodsdocRefresh();
begin
if Connected then begin
  if FDQuery_GoodsDoc.Active then FDQuery_GoodsDoc.Close;
  FDQuery_GoodsDoc.Params.ParamValues['PDATE'] := round(int(DocDate));
  FDQuery_GoodsDoc.Params.ParamValues['PSHIPMENT'] := get_key_dict(fld_shipment);
  FDQuery_GoodsDoc.Params.ParamValues['PWAREHOUSE'] := get_key_dict(fld_warehouse);
  FDQuery_GoodsDoc.Params.ParamValues['PPLACE'] := get_key_dict(fld_place);
  FDQuery_GoodsDoc.Open;
end;
end;

procedure Tfrm_find_goods.act_file_refreshExecute(Sender: TObject);
begin
if Assigned(FDataSource.DataSet) then begin
  if FDataSource.DataSet.Equals(FDQuery_GoodsDoc) then ds_goodsdocRefresh()
  else if FDataSource.DataSet.Equals(FDQuery_Goods) then ds_goodsRefresh();
end;
end;

function Tfrm_find_goods.GetDictName(Index: integer): string;
begin
Result := '';
case Index of
  0: Result := Trim(fld_warehouse.Text);     //WarehouseId
  1: Result := Trim(fld_place.Text);         //PlaceId
  2: Result := Trim(fld_shipment.Text);      //ShipmentId
end;
end;

function Tfrm_find_goods.GetDictID(Index: integer): Cardinal;
begin
Result := 0;
case Index of
  0: Result := get_key_dict(fld_warehouse);     //WarehouseId
  1: Result := get_key_dict(fld_place);         //PlaceId
  2: Result := get_key_dict(fld_shipment);      //ShipmentId
end;
end;

procedure Tfrm_find_goods.SetDictId(Index: integer; KeyDict: Cardinal);
begin
case Index of
  0: set_key_dict(fld_warehouse, KeyDict);   //WarehouseId
  1: set_key_dict(fld_place, KeyDict);       //PlaceId
  2: set_key_dict(fld_shipment, KeyDict);    //ShipmentId
end;
end;

procedure Tfrm_find_goods.dictQuery(Sender: TComboBox; DictName: string; DichWhere: string);
var LIndex: integer;
begin
LIndex := Sender.ItemIndex;
QueryDictionary(DictName, Sender.Items, DichWhere);
if (LIndex<1) and (Sender.Items.Count>1) then LIndex := 1;
if LIndex>=Sender.Items.Count then LIndex := Sender.Items.Count-1;
Sender.ItemIndex := LIndex;
end;

procedure Tfrm_find_goods.act_dict_query_placeExecute(Sender: TObject);
begin
dictQuery(fld_warehouse, 'Warehouse', '');
dictQuery(fld_place, 'Place', Format('WarehouseId = %d', [get_key_dict(fld_warehouse)]));
end;

procedure Tfrm_find_goods.act_dict_query_shipmentExecute(Sender: TObject);
begin
dictQuery(fld_shipment, 'Shipment', '');
end;

end.
