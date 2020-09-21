unit form_doccreate;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Menus, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Buttons, Vcl.Grids, Vcl.StdCtrls,
  Vcl.ComCtrls, Vcl.ExtCtrls, System.ImageList, Vcl.ImgList, System.Actions,
  Vcl.ActnList, Grids.Helper, appconfig, docparam, strtools;

type
  TQueryDictionary = procedure (const Name: string; Data: TStrings; const Where: string)of object;
  TNotifyProgress = procedure (const Progress: double)of object;

  Tfrm_doccreate = class(TForm)
    FActions: TActionList;
    act_file_close: TAction;
    act_doc_create: TAction;
    act_doc_import: TAction;
    FImages: TImageList;
    pnl_docdate: TPanel;
    lbl_docdate: TLabel;
    fld_docdate: TDateTimePicker;
    pnl_main: TPanel;
    fld_grid: TStringGrid;
    pnl_tools: TPanel;
    btn_file_close: TSpeedButton;
    pnl_tool_left: TPanel;
    btn_doc_import: TSpeedButton;
    btn_doc_create: TSpeedButton;
    btn_help: TSpeedButton;
    act_help: TAction;
    act_doc_append: TAction;
    btn_doc_append: TSpeedButton;
    bvl_1: TBevel;
    Label1: TLabel;
    pnl_grid: TPanel;
    pnl_header: TPanel;
    fld_docname: TEdit;
    Panel2: TPanel;
    Label3: TLabel;
    SpeedButton1: TSpeedButton;
    fld_shipment: TComboBox;
    fld_place: TComboBox;
    Panel3: TPanel;
    lbl_place: TLabel;
    SpeedButton3: TSpeedButton;
    fld_warehouse: TComboBox;
    act_dict_query_shipment: TAction;
    act_dict_query_warehouse: TAction;
    OpenDialog1: TOpenDialog;
    Splitter1: TSplitter;
    procedure FormClose(Sender: TObject; var Action: TCloseAction); virtual;
    procedure act_file_closeExecute(Sender: TObject);
    procedure act_doc_importExecute(Sender: TObject);
    procedure act_doc_exportExecute(Sender: TObject);
    procedure act_helpExecute(Sender: TObject);
    procedure act_doc_createExecute(Sender: TObject); virtual;
    procedure act_doc_appendExecute(Sender: TObject);
    procedure act_dict_query_shipmentExecute(Sender: TObject);
    procedure act_dict_query_warehouseExecute(Sender: TObject);
    procedure fld_warehouseChange(Sender: TObject);
  private
    FQueryDictionary: TQueryDictionary;
    FOnProgress: TNotifyProgress;
    FOnComplite: TNotifyEvent;
    FConfig: TAppConfig;
    function GetDocName: string;
    function GetDocDate: TDateTime;
    function GetDocCount: integer;
    procedure SetDocName(const AName: string);
    procedure DoOnProgress(const Progress: double);
    procedure DoOnComplite(Sender: TObject);
  protected
    FOnQueryDoc: TQueryDocFind;
    procedure SetConfig(AConfig: TAppConfig); virtual;
    function edithelp_info: string; virtual;
    function help_info: string; virtual;
    procedure DoExecute(ProgressEvent: TNotifyProgress; CompliteEvent: TNotifyEvent); virtual;
    function GetDocType: Cardinal; virtual;
    procedure GetData(Index: integer; Goods: TGoods); virtual;
    function DoQueryDoc(Values: TStrings): Cardinal; virtual;
    function get_key_dict(List: TComboBox): Cardinal;
    procedure set_key_dict(List: TComboBox; KeyDict: Cardinal);
    procedure QueryDictionary(const DictName: string; DictData: TStrings; const Where: string);
    procedure dictQuery(Sender: TComboBox; DictName: string; DichWhere: string);
    function MessageBox(const Text: string; Flag: Cardinal): Cardinal;
    function AppendAction(const ACaption: string; AIcon: integer; AExecute: TNotifyEvent; const AShortCut: string): TAction;
    function OpenChildForm(ClassChild: TFormClass): TForm;
  public
    constructor Create(AOwner: TComponent); override;
    procedure DoInit; virtual;
    property Config: TAppConfig read FConfig write SetConfig;
    property DocType: Cardinal read GetDocType;
    property DocCount: integer read GetDocCount;
    property DocDate: TDateTime read GetDocDate;
    property DocName: string read GetDocName write SetDocName;
    property OnQueryDoc: TQueryDocFind read FOnQueryDoc write FOnQueryDoc;
    property GetDictionary: TQueryDictionary read FQueryDictionary write FQueryDictionary;
    property OnProgress: TNotifyProgress read FOnProgress write FOnProgress;
    property OnComplite: TNotifyEvent read FOnComplite write FOnComplite;
  end;

implementation

{$R *.dfm}

constructor Tfrm_doccreate.Create(AOwner: TComponent);
begin
inherited Create(AOwner);
Caption := 'Создать документ';
DocName := 'Документ №';
FConfig := nil;
fld_docdate.DateTime := Now();
fld_grid.RowCount := 2;
fld_grid.Rows[1].Clear;
fld_grid.Fields.DisableControls;
fld_grid.Fields.Add('num', '№').Width := 60;
fld_grid.Fields.Add('shipment', 'Партия товара').Width := 160;
fld_grid.Fields.Add('warehouse', 'Склад').Width := 160;
fld_grid.Fields.Add('place', 'Место хранения').Width := 160;
fld_grid.Fields.Add('name', 'Наименование').Width := 160;
fld_grid.Fields.Add('article', 'Артикул').Width := 160;
fld_grid.Fields.Add('count', 'Количество').Width := 80;
fld_grid.Fields.Add('size', 'Размер').Width := 80;
fld_grid.Fields.Add('cost', 'Цена').Width := 60;
fld_grid.Fields.EnableControls;
AppendAction('Экспорт в файл', -1, act_doc_exportExecute, 'Ctrl+S');
btn_doc_import.Hint := act_doc_import.Hint+#13#10'Ctrl+S Экспорт в файл';
end;

procedure Tfrm_doccreate.SetConfig(AConfig: TAppConfig);
begin
FConfig := AConfig;
if Assigned(FConfig) then begin
  FConfig.Read(ClassName, 'position', Self);
  fld_warehouse.Width := FConfig.Read(ClassName, 'w1', fld_warehouse.Width);
  FConfig.Read(ClassName, 'grid', fld_grid.Fields);
  FConfig.Close;
end;
end;

procedure Tfrm_doccreate.DoInit;
begin
  act_dict_query_shipment.Execute;
  act_dict_query_warehouse.Execute;
  fld_shipment.ItemIndex := -1;
  fld_warehouse.ItemIndex := -1;
  fld_place.ItemIndex := -1;
end;

procedure Tfrm_doccreate.FormClose(Sender: TObject; var Action: TCloseAction);
begin
Action := caFree;
if Assigned(FConfig) then begin
  FConfig.Write(ClassName, 'position', Self);
  FConfig.Write(ClassName, 'w1', fld_warehouse.Width);
  FConfig.Write(ClassName, 'grid', fld_grid.Fields);
  FConfig.Close;
end;
end;

function Tfrm_doccreate.OpenChildForm(ClassChild: TFormClass): TForm;
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

function Tfrm_doccreate.MessageBox(const Text: string; Flag: Cardinal): Cardinal;
begin
Result := MessageBoxW(0, PWideChar(Text), PWideChar(Caption), Flag);
end;

function Tfrm_doccreate.GetDocType: Cardinal;
begin
Result := 0;
end;

function Tfrm_doccreate.GetDocCount: integer;
begin
Result := fld_grid.Count;
end;

function Tfrm_doccreate.GetDocDate: TDateTime;
begin
Result := fld_docdate.Date;
end;

function Tfrm_doccreate.GetDocName: string;
begin
Result := fld_docname.Text;
end;

procedure Tfrm_doccreate.SetDocName(const AName: string);
begin
fld_docname.Text := Trim(AName);
end;

procedure Tfrm_doccreate.act_file_closeExecute(Sender: TObject);
begin
Close;
end;

procedure Tfrm_doccreate.act_helpExecute(Sender: TObject);
begin
MessageBox(help_info, MB_ICONINFORMATION + MB_OK);
end;

procedure Tfrm_doccreate.GetData(Index: integer; Goods: TGoods);
begin
if Index<0 then begin
  Goods.Header.Clear;
  Goods.Header.Warehouse.Id := get_key_dict(fld_warehouse);
  Goods.Header.Warehouse.Name := fld_warehouse.Text;
  Goods.Header.Place.Id := get_key_dict(fld_place);
  Goods.Header.Place.Name := fld_place.Text;
  Goods.Header.Shipment.Id := get_key_dict(fld_shipment);
  Goods.Header.Shipment.Name := fld_shipment.Text;
end
else begin
  Goods.Clear;
  Goods.Dictionary.Warehouse.Name := fld_grid.GetValue(Index, 'warehouse');
  Goods.Dictionary.Place.Name := fld_grid.GetValue(Index, 'place');
  Goods.Dictionary.Shipment.Name := fld_grid.GetValue(Index, 'shipment');
  Goods.Id := str2uint(fld_grid.GetValue(Index, 'num'));
  Goods.Name := fld_grid.GetValue(Index, 'name');
  Goods.Article := fld_grid.GetValue(Index, 'article');
  Goods.Count := str2int(fld_grid.GetValue(Index, 'count'));
  Goods.Size := str2float(fld_grid.GetValue(Index, 'size'));
  Goods.Cost := str2float(fld_grid.GetValue(Index, 'cost'));
end;
end;

function Tfrm_doccreate.help_info: string;
begin
Result := edithelp_info;
end;

function Tfrm_doccreate.edithelp_info: string;
begin
Result := 'Редактирование списка:'#13#10+
  '<Down> - на последней строке добавится новая'#13#10+
  '<Ctrl> + <Del> - удалить строку'#13#10+
  '<Ctrl> + <Ins> - вставить строку';
end;

procedure Tfrm_doccreate.act_doc_importExecute(Sender: TObject);
begin
if OpenDialog1.Execute then begin
  fld_grid.LoadFromFile(OpenDialog1.Filename);
end;
end;

procedure Tfrm_doccreate.act_doc_exportExecute(Sender: TObject);
begin
with TSaveDialog.Create(Self) do begin
  Title := 'Экспорт документа';
  Filter := OpenDialog1.Filter;
  DefaultExt := OpenDialog1.DefaultExt;
  if Execute then begin
    fld_grid.SaveToFile(Filename);
  end;
  Free;
end;
end;

procedure Tfrm_doccreate.act_doc_createExecute(Sender: TObject);
begin
DoExecute(DoOnProgress, DoOnComplite);
Close;
end;

procedure Tfrm_doccreate.DoOnProgress(const Progress: double);
begin
if Assigned(FOnProgress) then FOnProgress(Progress);
end;

procedure Tfrm_doccreate.DoOnComplite(Sender: TObject);
begin
if Assigned(FOnComplite) then FOnComplite(Sender);
end;

function Tfrm_doccreate.DoQueryDoc(Values: TStrings): Cardinal;
begin
Result := 0;
Values.Values['WarehouseId'] := get_key_dict(fld_warehouse).ToString;
Values.Values['PlaceId'] := get_key_dict(fld_place).ToString;
Values.Values['ShipmentId'] := get_key_dict(fld_shipment).ToString;
if Assigned(FOnQueryDoc) then Result := FOnQueryDoc(Self, fld_docdate.Date, Values);
end;

procedure Tfrm_doccreate.fld_warehouseChange(Sender: TObject);
begin
dictQuery(fld_place, 'Place', Format('WarehouseId = %d', [get_key_dict(fld_warehouse)]));
end;

procedure Tfrm_doccreate.act_doc_appendExecute(Sender: TObject);
var LValues: TStrings;
begin
LValues := TStringList.Create;
try
  if DoQueryDoc(LValues)>0 then begin
    fld_grid.SetValues(fld_grid.Count, LValues);
  end;
finally
  LValues.Free;
end;
end;

procedure Tfrm_doccreate.QueryDictionary(const DictName: string; DictData: TStrings; const Where: string);
begin
if Assigned(FQueryDictionary) then FQueryDictionary(DictName, DictData, Where);
end;

function Tfrm_doccreate.get_key_dict(List: TComboBox): Cardinal;
begin
Result := 0;
if List.ItemIndex>=0 then begin
  Result := Cardinal(List.Items.Objects[List.ItemIndex]);
end;
end;

procedure Tfrm_doccreate.set_key_dict(List: TComboBox; KeyDict: Cardinal);
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

procedure Tfrm_doccreate.dictQuery(Sender: TComboBox; DictName: string; DichWhere: string);
var LIndex: integer;
begin
LIndex := Sender.ItemIndex;
QueryDictionary(DictName, Sender.Items, DichWhere);
if (LIndex<1) and (Sender.Items.Count>1) then LIndex := 1;
if LIndex>=Sender.Items.Count then LIndex := Sender.Items.Count-1;
Sender.ItemIndex := LIndex;
end;

procedure Tfrm_doccreate.act_dict_query_shipmentExecute(Sender: TObject);
begin
dictQuery(fld_shipment, 'Shipment', '');
end;

procedure Tfrm_doccreate.act_dict_query_warehouseExecute(Sender: TObject);
begin
dictQuery(fld_warehouse, 'Warehouse', '');
dictQuery(fld_place, 'Place', Format('WarehouseId = %d', [get_key_dict(fld_warehouse)]));
end;

procedure Tfrm_doccreate.DoExecute(ProgressEvent: TNotifyProgress; CompliteEvent: TNotifyEvent);
begin

end;

function Tfrm_doccreate.AppendAction(const ACaption: string; AIcon: integer; AExecute: TNotifyEvent; const AShortCut: string): TAction;
begin
Result := TAction.Create(Self);
Result.Caption := ACaption;
Result.Hint := ACaption;
Result.ImageIndex := AIcon;
Result.ShortCut := TextToShortcut(AShortCut);
Result.OnExecute := AExecute;
FActions.InsertComponent(Result);
Result.ActionList := FActions;
end;

end.
