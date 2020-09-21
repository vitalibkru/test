unit form_docview;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Buttons, Vcl.Grids, Vcl.StdCtrls,
  Vcl.ComCtrls, Vcl.ExtCtrls, System.ImageList, Vcl.ImgList, System.Actions,
  Vcl.ActnList, Grids.Helper, Data.DB, Vcl.DBGrids, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Vcl.DBCtrls, Vcl.Mask, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  FireDAC.UI.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Phys,
  FireDAC.Phys.MSSQL, FireDAC.Phys.MSSQLDef, FireDAC.VCLUI.Wait, appconfig;

type
  TQueryDictionary = procedure (const Name: string; Data: TStrings; const Where: string)of object;

  Tfrm_docview = class(TForm)
    FActions: TActionList;
    act_file_close: TAction;
    FImages: TImageList;
    pnl_docdate: TPanel;
    pnl_main: TPanel;
    pnl_tools: TPanel;
    btn_file_close: TSpeedButton;
    pnl_grid: TPanel;
    pnl_header: TPanel;
    Panel2: TPanel;
    Label3: TLabel;
    Panel3: TPanel;
    Label4: TLabel;
    DocGrid: TDBGrid;
    FDataSource_Doc: TDataSource;
    FDQuery_Doc: TFDQuery;
    FDQuery_Goods: TFDQuery;
    DataSource_Goods: TDataSource;
    fld_docname: TDBEdit;
    fld_docdate: TDBEdit;
    act_file_refresh: TAction;
    Panel1: TPanel;
    SpeedButton1: TSpeedButton;
    FDQuery_DocDocId: TLargeintField;
    FDQuery_DocDocName: TWideStringField;
    FDQuery_DocDocType: TLargeintField;
    FDQuery_DocDocDate: TSQLTimeStampField;
    FDQuery_DocShipmentId: TLargeintField;
    FDQuery_DocPlaceId: TLargeintField;
    FDQuery_DocShipmentName: TWideStringField;
    FDQuery_DocWarehouseId: TLargeintField;
    FDQuery_DocPlaceName: TWideStringField;
    FDQuery_DocWarehouseName: TWideStringField;
    fld_shipment: TDBEdit;
    fld_place: TDBEdit;
    fld_warehouse: TDBEdit;
    fld_doctype: TDBText;
    FDQuery_DocDocTypeName: TStringField;
    FDQuery_GoodsGoodsId: TLargeintField;
    FDQuery_GoodsGoodsArticle: TWideStringField;
    FDQuery_GoodsGoodsName: TWideStringField;
    FDQuery_GoodsGoodsCost: TFloatField;
    FDQuery_GoodsGoodsSize: TFloatField;
    FDQuery_GoodsDocId: TLargeintField;
    FDQuery_GoodsCount: TLargeintField;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure act_file_closeExecute(Sender: TObject);
    procedure act_file_refreshExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FDQuery_GoodsAfterOpen(DataSet: TDataSet);
    procedure FDQuery_GoodsBeforeClose(DataSet: TDataSet);
  private
    FConnection: TFDConnection;
    FDocId: Cardinal;
    FConfig: TAppConfig;
    procedure SetConnection(AConnection: TFDConnection);
    function GetConnected: boolean;
    function GetDataSetActive: boolean;
    procedure SetDocId(AKey: Cardinal);
    function GetDocReadOnly: boolean;
    procedure SetDocReadOnly(AReadOnly: boolean);
    procedure SetConfig(AConfig: TAppConfig);
  public
    property DocReadOnly: boolean read GetDocReadOnly write SetDocReadOnly;
    property DocId: Cardinal read FDocId write SetDocId;
    property Connection: TFDConnection read FConnection write SetConnection;
    property Connected: boolean read GetConnected;
    property DataSetActive: boolean read GetDataSetActive;
    property Config: TAppConfig read FConfig write SetConfig;
  end;

implementation

{$R *.dfm}

procedure Tfrm_docview.FormCreate(Sender: TObject);
begin
FConfig := nil;
SetConnection(nil);
FDocId := 0;
end;

procedure Tfrm_docview.FormClose(Sender: TObject; var Action: TCloseAction);
begin
Action := caFree;
if Assigned(FConfig) then begin
  FConfig.Write(ClassName, 'position', Self);
  FConfig.Write(ClassName, 'grid', DocGrid);
  FConfig.Close;
end;
end;

procedure Tfrm_docview.SetConfig(AConfig: TAppConfig);
begin
FConfig := AConfig;
if Assigned(FConfig) then begin
  FConfig.Read(ClassName, 'position', Self);
  FConfig.Read(ClassName, 'grid', DocGrid);
  FConfig.Close;
end;
end;

procedure Tfrm_docview.FDQuery_GoodsAfterOpen(DataSet: TDataSet);
begin
if Assigned(FConfig) then begin
  FConfig.Read(ClassName, 'grid', DocGrid);
  FConfig.Close;
end;
end;

procedure Tfrm_docview.FDQuery_GoodsBeforeClose(DataSet: TDataSet);
begin
if Assigned(FConfig) then begin
  FConfig.Write(ClassName, 'grid', DocGrid);
  FConfig.Close;
end;
end;

procedure Tfrm_docview.act_file_closeExecute(Sender: TObject);
begin
Close;
end;

function Tfrm_docview.GetConnected: boolean;
begin
Result := false;
if Assigned(FConnection) then begin
  Result := FConnection.Connected;
end;
end;

function Tfrm_docview.GetDataSetActive: boolean;
begin
Result := false;
if Assigned(DocGrid.DataSource) then
if Assigned(DocGrid.DataSource.DataSet) then begin
  Result := DocGrid.DataSource.DataSet.Active;
end;
end;

procedure Tfrm_docview.SetConnection(AConnection: TFDConnection);
begin
if FDQuery_Doc.Active then FDQuery_Doc.Close;
if FDQuery_Goods.Active then FDQuery_Goods.Close;
FConnection := AConnection;
FDQuery_Doc.Connection := FConnection;
FDQuery_Goods.Connection := FConnection;
end;

procedure Tfrm_docview.SetDocId(AKey: Cardinal);
begin
if FDocId<>AKey then begin
  FDocId := AKey;
  act_file_refresh.Execute;
end;
end;

procedure Tfrm_docview.act_file_refreshExecute(Sender: TObject);
begin
if Connected then begin
  if not FDQuery_Doc.Active then FDQuery_Doc.Close;
  if not FDQuery_Goods.Active then FDQuery_Goods.Close;
  FDQuery_Doc.Params.ParamValues['PDOCID'] := FDocId;
  FDQuery_Goods.Params.ParamValues['PDOCID'] := FDocId;
  FDQuery_Doc.Open;
  FDQuery_Goods.Open;
end;
end;

function Tfrm_docview.GetDocReadOnly: boolean;
begin
Result := DocGrid.ReadOnly;
end;

procedure Tfrm_docview.SetDocReadOnly(AReadOnly: boolean);
begin
DocGrid.ReadOnly := AReadOnly;
fld_docdate.ReadOnly := AReadOnly;
fld_docname.ReadOnly := AReadOnly;
fld_shipment.ReadOnly := true;
fld_warehouse.ReadOnly := true;
fld_place.ReadOnly := true;
end;

end.
