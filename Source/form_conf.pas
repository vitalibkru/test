unit form_conf;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, System.Actions, Vcl.ActnList,
  System.ImageList, Vcl.ImgList, Vcl.ExtCtrls, Vcl.Buttons, Vcl.StdCtrls,
  Vcl.CheckLst, Vcl.DbGrids, Grids.Helper, appconfig, deploy;

type
  TCheckListBox = class(Vcl.CheckLst.TCheckListBox)
  protected
    procedure KeyPress(var Key: Char); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
  end;

  Tfrm_conf = class(TForm)
    Panel1: TPanel;
    SpeedButton1: TSpeedButton;
    Panel2: TPanel;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    SpeedButton5: TSpeedButton;
    Bevel2: TBevel;
    SpeedButton7: TSpeedButton;
    FImages: TImageList;
    FActions: TActionList;
    act_file_close: TAction;
    act_conf_refresh: TAction;
    act_conf_apply: TAction;
    act_conf_save: TAction;
    act_conf_open: TAction;
    act_conf_deploy: TAction;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Edit1: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    CheckListBox1: TCheckListBox;
    GroupBox1: TGroupBox;
    pnl_check: TGroupBox;
    Panel3: TPanel;
    Panel4: TPanel;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    Edit2: TComboBox;
    SpeedButton6: TSpeedButton;
    act_get_dblist: TAction;
    pnl_deploy: TPanel;
    btn_deploy: TSpeedButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure act_file_closeExecute(Sender: TObject);
    procedure act_conf_openExecute(Sender: TObject);
    procedure act_conf_saveExecute(Sender: TObject);
    procedure act_conf_applyExecute(Sender: TObject);
    procedure act_conf_refreshExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure act_conf_deployExecute(Sender: TObject);
    procedure act_get_dblistExecute(Sender: TObject);
  private
    FOnParamsApply: TNotifyEvent;
    FConfig: TAppConfig;
    function do_deploy(Conf: TStrings): integer;
    function do_deploy_execute: integer;
    procedure do_conf_apply();
    procedure do_conf_save(FileName: string);
    procedure do_conf_load(FileName: string);
    procedure SetConfig(AConfig: TAppConfig);
    function MessageBox(const Text: string; Flag: Cardinal): Cardinal;
  public
    property Config: TAppConfig read FConfig write SetConfig;
    procedure conf_set(Values: TStrings);
    procedure conf_get(Values: TStrings);
    property OnParamsApply: TNotifyEvent read FOnParamsApply write FOnParamsApply;
    procedure UpdateState;
  end;

implementation

{$R *.dfm}

const
  cerr_deploy_ok = 'Проверка подключения пройдена успешно';
  cerr_deploy: array[0..4]of string = (
    'Не заданы параметры подключения',
    'Ошибка подключения к серверу',
    'Не найдена база данных на сервере',
    'Ошибка подключения к базе данных',
    'Ошибка создания таблиц'
  );

//TCheckListBox

procedure TCheckListBox.KeyPress(var Key: Char);
begin
Abort;
end;

procedure TCheckListBox.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
Abort;
end;

//Tfrm_conf

procedure Tfrm_conf.FormCreate(Sender: TObject);
var j: integer;
begin
FConfig := nil;
CheckListBox1.Items.Clear;
for j := 0 to Length(ctables)-1 do begin
  CheckListBox1.Items.Append(ctables[j]);
end;
CheckListBox1.Items.Append('@proc');
CheckListBox1.Items.Append('@trigger');
UpdateState;
end;

procedure Tfrm_conf.SetConfig(AConfig: TAppConfig);
begin
FConfig := AConfig;
if Assigned(FConfig) then begin
  UpdateState;
end;
end;

procedure Tfrm_conf.UpdateState;
var conn: boolean;
begin
conn := DeployValidate(FConfig);
pnl_deploy.Visible := not conn;
pnl_check.Visible := conn;
if pnl_check.Visible then ClientHeight := 340
else ClientHeight := 240;
end;

procedure Tfrm_conf.FormClose(Sender: TObject; var Action: TCloseAction);
begin
Action := caFree;
end;

procedure Tfrm_conf.act_file_closeExecute(Sender: TObject);
begin
Close;
end;

procedure Tfrm_conf.act_get_dblistExecute(Sender: TObject);
var st: TStrings;
  j: integer;
begin
st := TStringList.Create;
try
  conf_get(st);
  with TDeployConnection.Create(Self) do begin
    if Connect(st) then begin
      st.Clear;
      GetCatalogNames('', st);
      for j := 0 to st.Count-1 do begin
        st[j] := sname2name(st[j]);
      end;
      Edit2.Items.Assign(st);
    end;
    Free;
  end;
finally
  st.Free;
end;
end;

function Tfrm_conf.MessageBox(const Text: string; Flag: Cardinal): Cardinal;
begin
Result := MessageBoxW(0, PWideChar(Text), PWideChar(Caption), Flag);
end;

procedure Tfrm_conf.conf_get(Values: TStrings);
begin
Values.Values['Database\Server'] := Edit1.Text;
Values.Values['Database\Name'] := Edit2.Text;
Values.Values['Database\Account'] := Edit3.Text;
Values.Values['Database\Password'] := Edit4.Text;
end;

procedure Tfrm_conf.conf_set(Values: TStrings);
begin
Edit1.Text := Values.Values['Database\Server'];
Edit2.Text := Values.Values['Database\Name'];
Edit3.Text := Values.Values['Database\Account'];
Edit4.Text := Values.Values['Database\Password'];
end;

procedure Tfrm_conf.act_conf_applyExecute(Sender: TObject);
begin
do_conf_apply();
Close;
end;

procedure Tfrm_conf.act_conf_openExecute(Sender: TObject);
begin
with OpenDialog1 do begin
  InitialDir := ExtractFilePath(Paramstr(0));
  Filename := ExtractFilename(FConfig.DefFilename);
  if Execute then begin
    do_conf_load(FileName);
  end;
end;
end;

procedure Tfrm_conf.act_conf_saveExecute(Sender: TObject);
begin
with SaveDialog1 do begin
  InitialDir := ExtractFilePath(Paramstr(0));
  Filename := ExtractFilename(FConfig.DefFilename);
  if Execute then begin
    do_conf_save(FileName);
  end;
end;
end;

procedure Tfrm_conf.act_conf_refreshExecute(Sender: TObject);
var st: TStrings;
  j: integer;
  lname: string;
begin
for j := 0 to CheckListBox1.Count-1 do begin
  CheckListBox1.Checked[j] := false;
end;
st := TStringList.Create;
try
  conf_get(st);
  with TDeployConnection.Create(Self) do begin
    if Connect(st) then begin
      for j := 0 to CheckListBox1.Count-1 do begin
        lname := CheckListBox1.Items[j];
        if lname='@proc' then CheckListBox1.Checked[j] := ExistsObjects(cproc, 'FN')
        else if lname='@trigger' then CheckListBox1.Checked[j] := ExistsObjects(ctrigger, 'TR')
        else CheckListBox1.Checked[j] := ExistsTable(lname);
      end;
    end;
    Free;
  end;
finally
  st.Free;
end;
end;

procedure Tfrm_conf.act_conf_deployExecute(Sender: TObject);
begin
do_deploy_execute();
UpdateState;
end;

procedure Tfrm_conf.do_conf_load(FileName: string);
var st: TStrings;
begin
st := TStringList.Create;
try
  conf_get(st);
  with TDeploy.Create(FConfig) do begin
    conf_load(st);
    Free;
  end;
  conf_set(st);
finally
  st.Free;
end;
end;

procedure Tfrm_conf.do_conf_save(FileName: string);
var st: TStrings;
begin
st := TStringList.Create;
try
  conf_get(st);
  with TDeploy.Create(FConfig) do begin
    conf_save(st);
    Free;
  end;
finally
  st.Free;
end;
end;

procedure Tfrm_conf.do_conf_apply();
var st: TStrings;
begin
if Assigned(FOnParamsApply) then begin
  st := TStringList.Create;
  try
    conf_get(st);
    FOnParamsApply(st);
  finally
    st.Free;
  end;
end;
end;

function Tfrm_conf.do_deploy_execute: integer;
var st: TStrings;
  ret: integer;
begin
st := TStringList.Create;
try
  conf_get(st);
  ret := do_deploy(st);
  if ret<Length(cerr_deploy) then begin
    MessageBox(cerr_deploy[ret], MB_ICONERROR + MB_OK);
    Result := -1;
  end
  else begin
    MessageBox(cerr_deploy_ok, MB_ICONINFORMATION + MB_OK);
    do_conf_apply();
    do_conf_save(FConfig.DefFilename);
    Result := 1;
  end;
finally
  st.Free;
end;
end;

procedure LoadResource(Resource: TStrings; ResName: string);
var ResStream: TResourceStream;
begin
Resource.Clear;
ResStream := TResourceStream.Create(Hinstance, ResName, 'CUSTOM');
try
  Resource.LoadFromStream(ResStream);
finally
  ResStream.Free;
end;
end;

function Tfrm_conf.do_deploy(Conf: TStrings): integer;
var j,dbnew: integer;
  sql: TStrings;
  dbname: string;
  conn: TDeployConnection;
begin
Result := 0;
conn := TDeployConnection.Create(Self);
sql := TStringList.Create;
try
  dbname := Trim(Conf.Values['Database\Name']);
  if dbname<>'' then begin
    Result := 1;
    if conn.Connect(Conf, 'master') then begin
      Result := 2;
      LoadResource(sql, 'sql_create_db');
      dbnew := conn.CreateDatabase(dbname, sql);
      if dbnew>=0 then begin
        Result := 3;
        if conn.Connect(Conf) then begin
          Result := 4;
          j := 0;
          while j<Length(ctables) do begin
            LoadResource(sql, Format('sql_create_%s', [ctables[j]]));
            sql[0] := Format('USE [%s]', [dbname]);
            if conn.CreateTable(ctables[j], sql)<0 then begin
              j := Length(ctables);
            end;
            Inc(j);
          end;
          if j=Length(ctables) then begin
            Result := 5;
            if dbnew>0 then begin
              LoadResource(sql, 'sql_create_proc');
              conn.Execute(sql);
              LoadResource(sql, 'sql_insert_data');
              conn.Execute(sql);
            end;
          end;
        end;
      end;
    end;
  end;
finally
  sql.Free;
  conn.Free;
end;
end;

end.
