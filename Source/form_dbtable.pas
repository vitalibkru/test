unit form_dbtable;

interface

uses Winapi.Windows, Winapi.Messages, Classes, Controls, Forms, Vcl.Menus, Vcl.Grids,
  Vcl.ValEdit, Vcl.DBGrids, Vcl.DBCtrls, Data.DB,
  FireDAC.Comp.Client, FireDAC.Stan.Param, SysUtils, sysmenu;

type
  TDbForm = class(TForm)
  protected
    procedure DoCreate; override;
    procedure FormClose(Sender: TObject; var Action: TCloseAction); virtual;
    procedure SetDataSet(ADataSet: TFDCustomQuery); virtual;
  protected
    procedure WMSysCommand(var Msg: TWMSysCommand); message WM_SYSCOMMAND;
  private
    FSysMenu: TSystemMenu;
    FImages: TImageList;
    FDataSet: TFDCustomQuery;
    FDataSource: TDataSource;
    FGrid: TDBGrid;
    FNavigator: TDBNavigator;
    FAutoOpen: boolean;
    function GetConnected: boolean;
    function GetDataSetActive: boolean;
    procedure SetAutoOpen(Value: boolean);
    procedure OnClickParams(Sender: TObject);
    procedure OnClickRefresh(Sender: TObject);
    procedure DoGridInit;
  public
    constructor Create(AOwner: TComponent); override;
    property Grid: TDBGrid read FGrid;
    property Navigator: TDBNavigator read FNavigator;
    property AutoOpen: boolean read FAutoOpen write SetAutoOpen;
    property DataSet: TFDCustomQuery read FDataSet write SetDataSet;
    property DataSetActive: boolean read GetDataSetActive;
    property Connected: boolean read GetConnected;
    procedure DataSetOpen(Sender: TObject); virtual;
    procedure DataSetClose(Sender: TObject); virtual;
  end;

  tfrm_values = class(TForm)
  private
    FValueList: TValueListEditor;
    function GetValue(ValueName: string): string;
    procedure SetValue(ValueName: string; Source: string);
  public
    constructor Create(AOwner: TComponent); override;
    property Values[ValueName: string]: string read GetValue write SetValue;
  end;

implementation

//TDbForm

constructor TDbForm.Create(AOwner: TComponent);
begin
inherited CreateNew(AOwner);
Width := 740;
Height := 500;
Font.Size := 10;
Position := poScreenCenter;
FImages := TImageList.Create(Self);
InsertComponent(FImages);
FSysMenu := TSystemMenu.Create(Self);
FSysMenu.Images := FImages;
InsertComponent(FSysMenu);
FSysMenu.Add('Параметры', FImages.LoadFromResource(HInstance, 'dbn_APPLYUPDATES'), OnClickParams);
FSysMenu.Add('Обновить', FImages.LoadFromResource(HInstance, 'dbn_REFRESH'), OnClickRefresh);
FSysMenu.Add('Открыть', FImages.LoadFromResource(HInstance, 'dbn_POST'), DataSetOpen);
FSysMenu.Add('Закрыть', FImages.LoadFromResource(HInstance, 'dbn_CANCEL'), DataSetClose);
FDataSet := nil;
FDataSource := TDataSource.Create(Self);
FDataSource.DataSet := FDataSet;
InsertComponent(FDataSource);
FNavigator := TDBNavigator.Create(Self);
FNavigator.Align := alBottom;
FNavigator.DataSource := FDataSource;
InsertControl(FNavigator);
FGrid := TDBGrid.Create(Self);
FGrid.Align := alClient;
FGrid.DataSource := FDataSource;
InsertControl(FGrid);
OnClose := FormClose;
FAutoOpen := true;
end;

procedure TDbForm.DoCreate;
begin
inherited;
FSysMenu.Attach(GetSystemMenu(Handle, false));
end;

procedure TDbForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
Action := caFree;
if FAutoOpen then begin
  DataSetClose(Self);
end;
end;

procedure TDbForm.SetAutoOpen(Value: boolean);
begin
FAutoOpen := Value;
if FAutoOpen then begin
  DataSetOpen(Self);
end;
end;

function TDbForm.GetConnected: boolean;
begin
Result := false;
if Assigned(FDataSet) then
if Assigned(FDataSet.Connection) then begin
  Result := FDataSet.Connection.Connected;
end;
end;

function TDbForm.GetDataSetActive: boolean;
begin
Result := false;
if Assigned(FDataSet) then  begin
  Result := FDataSet.Active;
end;
end;

procedure TDbForm.SetDataSet(ADataSet: TFDCustomQuery);
begin
FDataSet := ADataSet;
FDataSource.DataSet := FDataSet;
if FAutoOpen then begin
  DataSetOpen(Self);
end;
end;

procedure TDbForm.DataSetOpen;
begin
if Connected then begin
  if not FDataSet.Active then begin
    FDataSet.Open;
  end;
  DoGridInit;
end;
end;

procedure TDbForm.DataSetClose;
begin
if DataSetActive then begin
  FDataSet.Close;
end;
end;

procedure TDbForm.DoGridInit;
var col: TColumn;
  j,w: integer;
begin
w := (FGrid.ClientWidth-40) div 3;
for j := 0 to FGrid.Columns.Count-1 do begin
  col := FGrid.Columns[j];
  if col.Width>w then col.Width := w;
end;
end;

procedure TDbForm.OnClickParams(Sender: TObject);
var dlg: tfrm_values;
  lparam: TFDParam;
  j: integer;
begin
if not Connected then exit;
dlg := tfrm_values.Create(Self);
dlg.Caption := FDataSet.Name+'.Params';
for j := 0 to FDataSet.ParamCount-1 do begin
  lparam := FDataSet.Params[j];
  dlg.Values[lparam.Name] := lparam.AsString;
end;
dlg.ShowModal;
DataSetClose(Self);
for j := 0 to FDataSet.ParamCount-1 do begin
  lparam := FDataSet.Params[j];
  lparam.Value := dlg.Values[lparam.Name];
end;
DataSetOpen(Self);
dlg.Release;
end;

procedure TDbForm.OnClickRefresh(Sender: TObject);
begin
DataSetClose(Self);
DataSetOpen(Self);
end;

procedure TDbForm.WMSysCommand(var Msg: TWMSysCommand);
begin
if not FSysMenu.OnCommand(Msg) then
    inherited;
end;

//tfrm_values

constructor tfrm_values.Create(AOwner: TComponent);
begin
inherited CreateNew(AOwner);
Font.Size := 10;
Position := poScreenCenter;
FValueList := TValueListEditor.Create(Self);
FValueList.Align := alClient;
InsertControl(FValueList);
end;

function tfrm_values.GetValue(ValueName: string): string;
begin
if ValueName='' then Result := ''
else Result := FValueList.Values[ValueName];
end;

procedure tfrm_values.SetValue(ValueName: string; Source: string);
begin
if ValueName<>'' then begin
  FValueList.Values[ValueName] := Source;
end;
end;

end.
