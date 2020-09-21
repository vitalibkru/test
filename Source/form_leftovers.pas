unit form_leftovers;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Grids, Vcl.ComCtrls, Vcl.StdCtrls,
  Vcl.ExtCtrls, Data.DB, Vcl.DBCtrls, Vcl.DBGrids, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  FireDAC.UI.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Phys,
  FireDAC.Phys.MSSQL, FireDAC.Phys.MSSQLDef, FireDAC.VCLUI.Wait,
  System.ImageList, Vcl.ImgList, System.Actions, Vcl.ActnList,
  FireDAC.Comp.Client, FireDAC.Comp.DataSet, Vcl.Buttons, Grids.Helper, appconfig;

type
  Tfrm_leftovers = class(TForm)
    pnl_docdate: TPanel;
    lbl_docdate: TLabel;
    fld_docdate: TDateTimePicker;
    pnl_grid: TPanel;
    fld_doc_time: TDateTimePicker;
    Label1: TLabel;
    DocGrid: TDBGrid;
    DBNavigator1: TDBNavigator;
    FDataSource: TDataSource;
    FDQuery_Leftovers: TFDQuery;
    FActions: TActionList;
    act_file_close: TAction;
    act_file_refresh: TAction;
    FImages: TImageList;
    pnl_tools: TPanel;
    btn_file_close: TSpeedButton;
    Panel1: TPanel;
    SpeedButton1: TSpeedButton;
    FDQuery_LeftoversGoodsId: TLargeintField;
    FDQuery_LeftoversShipmentId: TLargeintField;
    FDQuery_LeftoversShipmentName: TWideStringField;
    FDQuery_LeftoversPlaceId: TLargeintField;
    FDQuery_LeftoversPlaceName: TWideStringField;
    FDQuery_LeftoversWarehouseId: TLargeintField;
    FDQuery_LeftoversWarehouseName: TWideStringField;
    FDQuery_LeftoversGoodsArticle: TWideStringField;
    FDQuery_LeftoversGoodsName: TWideStringField;
    FDQuery_LeftoversGoodsCost: TFloatField;
    FDQuery_LeftoversGoodsSize: TFloatField;
    FDQuery_LeftoversGoodsCount: TLargeintField;
    act_group_shipment: TAction;
    act_group_place: TAction;
    act_group_warehouse: TAction;
    Panel2: TPanel;
    btn_group_goods: TSpeedButton;
    btn_group_shipment: TSpeedButton;
    btn_group_place: TSpeedButton;
    Bevel1: TBevel;
    Bevel2: TBevel;
    FDQuery_LeftoversDocDate: TSQLTimeStampField;
    act_group_goods: TAction;
    btn_group_warehouse: TSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure act_file_closeExecute(Sender: TObject);
    procedure act_file_refreshExecute(Sender: TObject);
    procedure FDQuery_LeftoversAfterOpen(DataSet: TDataSet);
    procedure FDQuery_LeftoversBeforeClose(DataSet: TDataSet);
    procedure act_group_shipmentExecute(Sender: TObject);
    procedure act_group_placeExecute(Sender: TObject);
    procedure act_group_warehouseExecute(Sender: TObject);
    procedure act_group_goodsExecute(Sender: TObject);
    procedure fld_docdateExit(Sender: TObject);
  private
    FConnection: TFDConnection;
    FDisabledControls: boolean;
    FChanged: boolean;
    FQueryDateTime: TDateTime;
    FConfig: TAppConfig;
    function GetDocDate: TDateTime;
    procedure SetDocDate(Value: TDateTime);
    procedure SetConnection(AConnection: TFDConnection);
    function GetConnected: boolean;
    procedure show_group_state;
    procedure set_group_state(Value: integer);
    function get_group_state: integer;
    procedure SetConfig(AConfig: TAppConfig);
  public
    property DocDate: TDateTime read GetDocDate write SetDocDate;
    property Connection: TFDConnection read FConnection write SetConnection;
    property Connected: boolean read GetConnected;
    procedure DisableControls;
    procedure EnableControls;
    property Config: TAppConfig read FConfig write SetConfig;
  end;

implementation

{$R *.dfm}

procedure Tfrm_leftovers.FormCreate(Sender: TObject);
begin
FConfig := nil;
DisableControls;
DocDate := Now();
set_group_state(get_group_state);
FChanged := false;
EnableControls;
end;

procedure Tfrm_leftovers.FormClose(Sender: TObject; var Action: TCloseAction);
begin
DisableControls;
Action := caFree;
if Assigned(FConfig) then begin
  FConfig.Write(ClassName, 'position', Self);
  FConfig.Write(ClassName, 'group', get_group_state);
  FConfig.Close;
end;
end;

procedure Tfrm_leftovers.SetConfig(AConfig: TAppConfig);
begin
FConfig := AConfig;
if Assigned(FConfig) then begin
  FConfig.Read(ClassName, 'position', Self);
  set_group_state(FConfig.Read(ClassName, 'group', get_group_state));
  FConfig.Close;
end;
end;

function Tfrm_leftovers.GetConnected: boolean;
begin
Result := false;
if Assigned(FConnection) then begin
  Result := FConnection.Connected;
end;
end;

procedure Tfrm_leftovers.act_file_closeExecute(Sender: TObject);
begin
Close;
end;

procedure Tfrm_leftovers.DisableControls;
begin
FDisabledControls := true;
end;

procedure Tfrm_leftovers.EnableControls;
begin
FDisabledControls := false;
if FChanged then act_file_refresh.Execute;
end;

procedure Tfrm_leftovers.SetConnection(AConnection: TFDConnection);
begin
if FDQuery_Leftovers.Active then FDQuery_Leftovers.Close;
FConnection := AConnection;
FDQuery_Leftovers.Connection := FConnection;
end;

procedure Tfrm_leftovers.act_file_refreshExecute(Sender: TObject);
const bint: array[boolean]of integer = (1, 0);
begin
FChanged := true;
if FDisabledControls then exit;
DisableControls;
if Connected then begin
  if FDQuery_Leftovers.Active then FDQuery_Leftovers.Close;
  if get_group_state=0 then set_group_state($01);
  FQueryDateTime := DocDate;
  FDQuery_Leftovers.Params.ParamValues['PDATE'] := round(int(FQueryDateTime));
  FDQuery_Leftovers.Params.ParamValues['PSHIPMENT'] := bint[act_group_shipment.Checked];
  FDQuery_Leftovers.Params.ParamValues['PPLACE'] := bint[act_group_place.Checked];
  FDQuery_Leftovers.Params.ParamValues['PWAREHOUSE'] := bint[act_group_warehouse.Checked];
  FDQuery_Leftovers.Params.ParamValues['PGOODS'] := bint[act_group_goods.Checked];
  FDQuery_LeftoversWarehouseName.Visible := act_group_warehouse.Checked;
  FDQuery_LeftoversPlaceName.Visible := act_group_place.Checked;
  FDQuery_LeftoversShipmentName.Visible := act_group_shipment.Checked;
  FDQuery_LeftoversGoodsName.Visible := act_group_goods.Checked;
  FDQuery_LeftoversGoodsArticle.Visible := act_group_goods.Checked;
  FDQuery_LeftoversGoodsCost.Visible := act_group_goods.Checked;
  FDQuery_LeftoversGoodsSize.Visible := act_group_goods.Checked;
  FDQuery_Leftovers.Params.ParamValues['PTIME'] := frac(FQueryDateTime);
  FDQuery_Leftovers.Open;
  DocGrid.UpdateColumnStyle;
end;
FChanged := false;
EnableControls;
end;

function Tfrm_leftovers.get_group_state: integer;
begin
Result := 0;
if act_group_warehouse.Checked then Result := Result or $01;
if act_group_place.Checked then Result := Result or $02;
if act_group_shipment.Checked then Result := Result or $04;
if act_group_goods.Checked then Result := Result or $08;
end;

procedure Tfrm_leftovers.set_group_state(Value: integer);
var conn: boolean;
begin
conn := FDisabledControls;
DisableControls;
act_group_warehouse.Checked := (Value and $01)=$01;
act_group_place.Checked := (Value and $02)=$02;
act_group_shipment.Checked := (Value and $04)=$04;
act_group_goods.Checked := (Value and $08)=$08;
show_group_state;
if not conn then EnableControls;
act_file_refresh.Execute;
end;

procedure Tfrm_leftovers.show_group_state;
begin
btn_group_place.Flat := not act_group_place.Checked;
btn_group_shipment.Flat := not act_group_shipment.Checked;
btn_group_warehouse.Flat := not act_group_warehouse.Checked;
btn_group_goods.Flat := not act_group_goods.Checked;
end;

procedure Tfrm_leftovers.act_group_goodsExecute(Sender: TObject);
begin
act_group_goods.Checked := not act_group_goods.Checked;
btn_group_goods.Flat := not act_group_goods.Checked;
act_file_refresh.Execute;
end;

procedure Tfrm_leftovers.act_group_placeExecute(Sender: TObject);
begin
act_group_place.Checked := not act_group_place.Checked;
btn_group_place.Flat := not act_group_place.Checked;
act_file_refresh.Execute;
end;

procedure Tfrm_leftovers.act_group_shipmentExecute(Sender: TObject);
begin
act_group_shipment.Checked := not act_group_shipment.Checked;
btn_group_shipment.Flat := not act_group_shipment.Checked;
act_file_refresh.Execute;
end;

procedure Tfrm_leftovers.act_group_warehouseExecute(Sender: TObject);
begin
act_group_warehouse.Checked := not act_group_warehouse.Checked;
btn_group_warehouse.Flat := not act_group_warehouse.Checked;
act_file_refresh.Execute;
end;

procedure Tfrm_leftovers.FDQuery_LeftoversAfterOpen(DataSet: TDataSet);
begin
if Assigned(FConfig) then begin
  FConfig.Read(ClassName, 'grid', DocGrid);
  FConfig.Close;
end;
end;

procedure Tfrm_leftovers.FDQuery_LeftoversBeforeClose(DataSet: TDataSet);
begin
if Assigned(FConfig) then begin
  FConfig.Write(ClassName, 'grid', DocGrid);
  FConfig.Close;
end;
end;

procedure Tfrm_leftovers.fld_docdateExit(Sender: TObject);
begin
if FQueryDateTime<>DocDate then begin
  act_file_refresh.Execute;
end;
end;

procedure Tfrm_leftovers.SetDocDate(Value: TDateTime);
var ctime: boolean;
  conn: boolean;
begin
conn := FDisabledControls;
DisableControls;
fld_docdate.Date := int(Value);
ctime := fld_doc_time.Checked;
fld_doc_time.Time := frac(Value);
fld_doc_time.Checked := ctime;
if not conn then EnableControls;
act_file_refresh.Execute;
end;

function Tfrm_leftovers.GetDocDate: TDateTime;
begin
Result := fld_docdate.Date;
if fld_doc_time.Checked then Result := Result+fld_doc_time.Time;
end;

end.
