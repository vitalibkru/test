unit form_main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.Grids, Vcl.DBGrids,
  System.Actions, Vcl.ActnList, System.ImageList, Vcl.ImgList, Vcl.ExtCtrls,
  Vcl.Buttons, Vcl.DBCtrls, Vcl.ComCtrls, form_dm, form_conf, deploy, Vcl.Menus, Vcl.Samples.Gauges, Vcl.ToolWin,
  Grids.Helper, ShellAPI, form_doc_consumption, form_doc_arrival, form_doc_moving, strtools,
  form_find_goods, form_leftovers, form_docview, appconfig;

type
  Tfrm_main = class(TForm)
    DBGrid1: TDBGrid;
    FDataSource: TDataSource;
    Panel1: TPanel;
    FActions: TActionList;
    FImages: TImageList;
    act_file_close: TAction;
    SpeedButton1: TSpeedButton;
    StatusBar1: TStatusBar;
    pnl_ds: TPanel;
    DBNavigator1: TDBNavigator;
    act_ds_goods: TAction;
    act_ds_place: TAction;
    act_ds_warehouse: TAction;
    act_ds_shipment: TAction;
    act_file_connect: TAction;
    act_file_conf: TAction;
    act_ds_doc: TAction;
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton_Table: TToolButton;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    PopupMenu_Table: TPopupMenu;
    N1: TMenuItem;
    k1: TMenuItem;
    k2: TMenuItem;
    k3: TMenuItem;
    k4: TMenuItem;
    Panel2: TPanel;
    act_doc_arrival: TAction;
    act_doc_moving: TAction;
    act_doc_consumption: TAction;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    ToolButton7: TToolButton;
    Gauge1: TGauge;
    Panel3: TPanel;
    ToolButton8: TToolButton;
    act_ds_leftovers: TAction;
    act_ds_doclink: TAction;
    N2: TMenuItem;
    act_file_readonly: TAction;
    ToolButton9: TToolButton;
    act_file_update: TAction;
    SpeedButton2: TSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure act_ds_goodsExecute(Sender: TObject);
    procedure act_ds_placeExecute(Sender: TObject);
    procedure act_ds_warehouseExecute(Sender: TObject);
    procedure act_file_closeExecute(Sender: TObject);
    procedure act_ds_shipmentExecute(Sender: TObject);
    procedure act_file_connectExecute(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure act_file_confExecute(Sender: TObject);
    procedure act_ds_docExecute(Sender: TObject);
    procedure act_doc_arrivalExecute(Sender: TObject);
    procedure act_doc_movingExecute(Sender: TObject);
    procedure act_doc_consumptionExecute(Sender: TObject);
    procedure act_ds_leftoversExecute(Sender: TObject);
    procedure act_ds_doclinkExecute(Sender: TObject);
    procedure DBGrid1DblClick(Sender: TObject);
    procedure act_file_readonlyExecute(Sender: TObject);
    procedure act_file_updateExecute(Sender: TObject);
  private
    FDM: TFDM;
    FConfig: TAppConfig;
    function GetDataSetActive: boolean;
    function GetFieldValue(FieldName: string): string;
    procedure OpenDataSet(Sender: TDataSet);
    procedure SetStatus(const S: string);
    procedure OnChangeState(Sender: TObject);
    procedure OnChangeReadOnly(Sender: TObject);
    procedure SetConnectionParams;
    function OpenChildForm(ClassChild: TFormClass): TForm;
    function on_doc_goodsFind(Sender: TObject; DocDate: TDateTime; Values: TStrings): Cardinal;
    procedure DoProgress(const Progress: double);
    procedure DoViewDataSet(Sender: TDataSet);
    procedure on_doc_complite(Sender: TObject);
  protected
    function MessageBox(const Text: string; Flag: Cardinal): Cardinal;
  public
    constructor Create(AOwner: TComponent); override;
    property DataSetActive: boolean read GetDataSetActive;
    property Value[FieldName: string]: string read GetFieldValue;
  end;

var
  frm_main: Tfrm_main;

implementation

const
  cloud = 'https://cloud.mail.ru/public/4fec/3ma74bHY2';

  icon_db_connected: array[boolean]of integer = (6, 5);
  hint_db_connected: array[boolean]of string = ('Подключить базу', 'Отключить базу');

  icon_db_readonly: array[boolean]of integer = (14, 15);
  hint_db_readonly: array[boolean]of string = ('Редактирование', 'Только просмотр');
  nav_db_readonly: array[boolean]of TNavButtonSet = (
    [nbFirst,nbPrior,nbNext,nbLast,nbInsert,nbDelete,nbEdit,nbPost,nbCancel,nbRefresh],
    [nbFirst,nbPrior,nbNext,nbLast,nbRefresh]
  );

{$R *.dfm}

constructor Tfrm_main.Create(AOwner: TComponent);
begin
inherited Create(AOwner);
if TAppParams.Exists(['fileconf']) then FConfig := TFileConfig.Create(Self)
else FConfig := TRegConfig.Create(Self);
FConfig.Write(ClassName, 'started', Now());
FConfig.Close;
InsertComponent(FConfig);
FDM := TFDM.Create(Self);
InsertComponent(FDM);
FDM.Disconnect;
FDM.OnChangeState := OnChangeState;
DBGrid1.OnChangeReadOnly := OnChangeReadOnly;
OnChangeState(FDM);
OnChangeReadOnly(Self);
end;

procedure Tfrm_main.FormCreate(Sender: TObject);
begin
SetConnectionParams;
if DeployValidate(FConfig) then begin
  FDM.Connect;
end;
if not FDM.Connected then begin
  if MessageBox('Нет подключения к базе данных.'#13#10+
    'Настроить параметры?',
    MB_ICONEXCLAMATION + MB_YESNO)=6 then begin
    act_file_conf.Execute;
    end
  else begin
    Halt(1);
  end;
end;
FConfig.Read(ClassName, 'position', Self);
FConfig.Close;
end;

procedure Tfrm_main.FormClose(Sender: TObject; var Action: TCloseAction);
begin
FConfig.Write(ClassName, 'position', Self);
FConfig.Write(ClassName, 'closed', Now());
FConfig.Close;
OpenDataSet(nil);
FDM.Disconnect;
Action := caFree;
end;

procedure Tfrm_main.SetStatus(const S: string);
begin
StatusBar1.SimpleText := S;
end;

procedure Tfrm_main.OnChangeReadOnly(Sender: TObject);
var ro: boolean;
begin
ro := DBGrid1.ReadOnly;
act_file_readonly.ImageIndex := icon_db_readonly[ro];
act_file_readonly.Hint := hint_db_readonly[ro];
DBNavigator1.VisibleButtons := nav_db_readonly[ro];
end;

procedure Tfrm_main.OnChangeState(Sender: TObject);
var conn: boolean;
begin
conn := FDM.Connected;
act_ds_goods.Enabled := conn;
act_ds_place.Enabled := conn;
act_ds_warehouse.Enabled := conn;
act_ds_shipment.Enabled := conn;
act_ds_doc.Enabled := conn;
act_file_connect.ImageIndex := icon_db_connected[conn];
act_file_connect.Hint := hint_db_connected[conn];
if conn then begin
  act_ds_doc.Execute;
end
else begin
  OpenDataSet(nil);
end;
end;

procedure Tfrm_main.act_file_closeExecute(Sender: TObject);
begin
Close;
end;

function Tfrm_main.GetFieldValue(FieldName: string): string;
var Field: TField;
begin
Result := '';
if DataSetActive then begin
  Field := FDataSource.DataSet.FindField(FieldName);
  if Assigned(Field) then begin
    if Field.DataType in [ftDate, ftTime, ftDateTime, ftTimeStamp] then Result := Field.AsFloat.ToString
    else Result := Trim(Field.AsString);
  end;
end;
end;

function Tfrm_main.GetDataSetActive: boolean;
begin
Result := false;
if Assigned(FDataSource.DataSet) then  begin
  Result := FDataSource.DataSet.Active;
end;
end;

procedure Tfrm_main.OpenDataSet(Sender: TDataSet);
begin
FConfig.Write(ClassName, DBGrid1.GetDataName, DBGrid1);
if Assigned(FDataSource.DataSet) then begin
  FDataSource.DataSet.Close;
end;
FDataSource.DataSet := Sender;
pnl_ds.Visible := Assigned(Sender);
if Assigned(Sender) then
if FDM.Connected then begin
  Sender.Open;
  DBGrid1.UpdateColumnStyle;
end;
FConfig.Read(ClassName, DBGrid1.GetDataName, DBGrid1);
FConfig.Close;
end;

function Tfrm_main.OpenChildForm(ClassChild: TFormClass): TForm;
var j: integer;
  obj: TComponent;
begin
for j := 0 to ComponentCount-1 do begin
  obj := Components[j];
  if obj is ClassChild then begin
    Result := TForm(obj);
    Result.Show;
    exit;
  end;
end;
Result := ClassChild.Create(Self);
InsertComponent(Result);
Result.Show;
end;

procedure Tfrm_main.SetConnectionParams;
var st: TStrings;
begin
st := TStringList.Create;
try
  with TDeploy.Create(FConfig) do begin
    conf_load(st);
    Free;
  end;
  FDM.SetConnectionParams(st);
finally
  st.Free;
end;
end;

procedure Tfrm_main.act_file_confExecute(Sender: TObject);
var st: TStrings;
begin
with Tfrm_conf.Create(Self) do begin
  Config := Self.FConfig;
  OnParamsApply := FDM.SetConnectionParams;
  Config := Self.FConfig;
  st := TStringList.Create;
  try
    FDM.GetConnectionParams(st);
    conf_set(st);
  finally
    st.Free;
  end;
  ShowModal;
  Release;
end;
end;

procedure Tfrm_main.act_file_connectExecute(Sender: TObject);
begin
if FDM.Connected then FDM.Disconnect
else FDM.Connect;
end;

procedure Tfrm_main.act_file_readonlyExecute(Sender: TObject);
begin
DBGrid1.ReadOnly := not DBGrid1.ReadOnly;
end;

procedure Tfrm_main.act_file_updateExecute(Sender: TObject);
begin
ShellExecute(Handle, 'open', cloud, '', '', SW_SHOW);
end;

procedure Tfrm_main.act_doc_arrivalExecute(Sender: TObject);
begin
with Tfrm_doc_arrival(OpenChildForm(Tfrm_doc_arrival)) do begin
  Config := Self.FConfig;
  OnQueryDoc := on_doc_goodsFind;
  GetDictionary := FDM.QueryDictionary;
  OnProgress := DoProgress;
  OnComplite := on_doc_complite;
  DM := FDM;
  DoInit;
end;
end;

procedure Tfrm_main.act_doc_consumptionExecute(Sender: TObject);
begin
with Tfrm_doc_consumption(OpenChildForm(Tfrm_doc_consumption)) do begin
  Config := Self.FConfig;
  OnQueryDoc := on_doc_goodsFind;
  GetDictionary := FDM.QueryDictionary;
  OnProgress := DoProgress;
  OnComplite := on_doc_complite;
  DM := FDM;
  DoInit;
end;
end;

procedure Tfrm_main.act_doc_movingExecute(Sender: TObject);
begin
with Tfrm_doc_moving(OpenChildForm(Tfrm_doc_moving)) do begin
  Config := Self.FConfig;
  OnQueryDoc := on_doc_goodsFind;
  GetDictionary := FDM.QueryDictionary;
  OnProgress := DoProgress;
  OnComplite := on_doc_complite;
  DM := FDM;
  DoInit;
end;
end;

procedure Tfrm_main.act_ds_docExecute(Sender: TObject);
begin
OpenDataSet(FDM.FDTable_Doc);
SetStatus(act_ds_doc.Hint);
ToolButton_Table.Action := act_ds_doc;
end;

procedure Tfrm_main.act_ds_doclinkExecute(Sender: TObject);
begin
OpenDataSet(FDM.FDTable_DocLink);
SetStatus(act_ds_doclink.Hint);
ToolButton_Table.Action := act_ds_doclink;
end;

procedure Tfrm_main.act_ds_goodsExecute(Sender: TObject);
begin
OpenDataSet(FDM.FDTable_Goods);
SetStatus(act_ds_goods.Hint);
ToolButton_Table.Action := act_ds_goods;
end;

procedure Tfrm_main.act_ds_placeExecute(Sender: TObject);
begin
OpenDataSet(FDM.FDTable_Place);
SetStatus(act_ds_place.Hint);
ToolButton_Table.Action := act_ds_place;
end;

procedure Tfrm_main.act_ds_shipmentExecute(Sender: TObject);
begin
OpenDataSet(FDM.FDTable_Shipment);
SetStatus(act_ds_shipment.Hint);
ToolButton_Table.Action := act_ds_shipment;
end;

procedure Tfrm_main.act_ds_warehouseExecute(Sender: TObject);
begin
OpenDataSet(FDM.FDTable_Warehouse);
SetStatus(act_ds_warehouse.Hint);
ToolButton_Table.Action := act_ds_warehouse;
end;

procedure Tfrm_main.DBGrid1DblClick(Sender: TObject);
begin
if Assigned(DBGrid1.DataSource) then begin
  DoViewDataSet(DBGrid1.DataSource.DataSet);
end;
end;

procedure Tfrm_main.DoProgress(const Progress: double);
begin
if Progress<=0 then begin
  Gauge1.Progress := 0;
  Gauge1.Visible := true;
end
else if Progress>=1 then begin
  Gauge1.Visible := false;
end
else begin
  Gauge1.Progress := round(Progress*Gauge1.MaxValue);
end;
end;

function Tfrm_main.MessageBox(const Text: string; Flag: Cardinal): Cardinal;
begin
Result := MessageBoxW(0, PWideChar(Text), PWideChar(Caption), Flag);
end;

function Tfrm_main.on_doc_goodsFind(Sender: TObject; DocDate: TDateTime; Values: TStrings): Cardinal;
var dlg: Tfrm_find_goods;
begin
Result := 0;
if not FDM.Connected then exit;
dlg := Tfrm_find_goods.Create(Self);
try
  dlg.Config := Self.FConfig;
  dlg.Caption := 'Выбор товара';
  dlg.Connection := FDM.FDConnection;
  dlg.GetDictionary := FDM.QueryDictionary;
  dlg.act_dict_query_shipment.Execute;
  dlg.act_dict_query_place.Execute;
  dlg.WarehouseId := str2uint(Values.Values['WarehouseId']);
  dlg.PlaceId := str2uint(Values.Values['PlaceId']);
  dlg.ShipmentId := str2uint(Values.Values['ShipmentId']);
  dlg.DictReadOnly := str2uint(Values.Values['ReadOnly']);
  dlg.DocDate := DocDate;
  dlg.ShowModal;
  if dlg.ModalResult=mrOk then
  if dlg.Key>0 then begin
    Result := dlg.Key;
    Values.Values['num'] := dlg.Value['GoodsId'];
    Values.Values['name'] := dlg.Value['GoodsName'];
    Values.Values['article'] := dlg.Value['GoodsArticle'];
    Values.Values['size'] := dlg.Value['GoodsSize'];
    Values.Values['cost'] := dlg.Value['GoodsCost'];
    Values.Values['count'] := dlg.Value['GoodsCount'];
    Values.Values['shipment'] := dlg.Value['ShipmentName'];
    Values.Values['warehouse'] := dlg.Value['WarehouseName'];
    Values.Values['place'] := dlg.Value['PlaceName'];
  end;
finally
  dlg.Free;
end;
end;

procedure Tfrm_main.act_ds_leftoversExecute(Sender: TObject);
begin
with Tfrm_leftovers(OpenChildForm(Tfrm_leftovers)) do begin
  Config := Self.FConfig;
  DisableControls;
  Connection := FDM.FDConnection;
  DocDate := Now();
  EnableControls;
end;
end;

procedure Tfrm_main.DoViewDataSet(Sender: TDataSet);
begin
if Assigned(Sender) then
if Sender.Active then
if Sender.Equals(FDM.FDTable_Doc) then
with Tfrm_docview(OpenChildForm(Tfrm_docview)) do begin
  Config := Self.FConfig;
  Connection := FDM.FDConnection;
  DocId := Sender.FieldByName('DocId').AsLargeInt;
  DocReadOnly := DBGrid1.ReadOnly;
end;
end;

procedure Tfrm_main.on_doc_complite(Sender: TObject);
begin
if FDM.FDTable_Doc.Equals(FDataSource.DataSet) then begin
  act_ds_doc.Execute;
end;
end;

end.
