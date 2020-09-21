unit deploy;

interface

uses Classes, System.WideStrUtils, SysUtils, DCPbase64, FireDAC.Comp.Client, appconfig;

type
  TDeploy = class
  private
    FConfig: TAppConfig;
  public
    function Decode(const Source: string): string;
    function Encode(const Source: string): string;
    procedure conf_save(Values: TStrings);
    procedure conf_load(Values: TStrings);
    function Validate(Params: TStrings): boolean;
  public
    constructor Create(AConfig: TAppConfig); reintroduce;
  end;

  TDeployConnection = class(TFDConnection)
  private
    procedure _connect;
    procedure _disconnect;
  public
    function Connect(Conf: TStrings): boolean; overload;
    function Connect(Conf: TStrings; DatabaseName: string): boolean; overload;
    function DeployTables(): boolean;
    function QueryDatabasePath(): string;
    function CreateTable(TableName: string; SQL: TStrings): integer;
    function ExistsTable(TableName: string): boolean;
    function ExistsObjects(const Names: array of string; const Ident: string): boolean;
    function ExistsDatabase(DatabaseName: string): boolean; overload;
    function ExistsDatabase: boolean; overload;
    function CreateDatabase(DatabaseName: string; SQL: TStrings): integer;
    function Execute(SQL: TStrings): integer;
  end;

  function DeployValidate(AConfig: TAppConfig): boolean;
  function sname2name(const Name: string): string;

const
  ctables: array[0..5]of string = (
'Warehouse',
'Place',
'Shipment',
'Goods',
'Doc',
'DocLink'
  );

  cproc: array[0..3]of string = (
'date2int',
'time2int',
'dateOver',
'datetimeOver'
  );

  ctrigger: array[0..1]of string = (
'PlaceIdUPDATE',
'WarehouseIdUPDATE'
  );

implementation

function DeployValidate(AConfig: TAppConfig): boolean;
var st: TStrings;
  dp: TDeploy;
begin
Result := false;
if not Assigned(AConfig) then exit;
st := TStringList.Create;
dp := TDeploy.Create(AConfig);
try
  dp.conf_load(st);
  Result := dp.Validate(st);
finally
  dp.Free;
  st.Free;
end;
end;

function sqlstr(const Source: string): string;
var n: integer;
begin
  Result := Trim(Source);
  n := pos('/*', Result);
  if n>0 then Result := Trim(copy(Result,1,n-1));
end;

//TDeploy

constructor TDeploy.Create(AConfig: TAppConfig);
begin
inherited Create;
FConfig := AConfig;
end;

function TDeploy.Decode(const Source: string): string;
begin
Result := String(Base64DecodeStr(RawByteString(Source)));
end;

function TDeploy.Encode(const Source: string): string;
begin
Result := String(Base64EncodeStr(RawByteString(Source)));
end;

procedure TDeploy.conf_load(Values: TStrings);
begin
if Assigned(FConfig) then
if FConfig.Open then begin
  Values.Values['Database\Server'] := FConfig.Read('Database', 'Server', Values.Values['Database\Server']);
  Values.Values['Database\Name'] := FConfig.Read('Database', 'Name', Values.Values['Database\Name']);
  Values.Values['Database\Account'] := FConfig.Read('Database', 'Account', Values.Values['Database\Account']);
  Values.Values['Database\Password'] := Decode(FConfig.Read('Database', 'Password', Encode(Values.Values['Database\Password'])));
  FConfig.Close;
end;
end;

procedure TDeploy.conf_save(Values: TStrings);
begin
if Assigned(FConfig) then
if FConfig.Open then begin
  FConfig.Write('Database', 'Server', Values.Values['Database\Server']);
  FConfig.Write('Database', 'Name', Values.Values['Database\Name']);
  FConfig.Write('Database', 'Account', Values.Values['Database\Account']);
  FConfig.Write('Database', 'Password', Encode(Values.Values['Database\Password']));
  FConfig.Close;
end;
end;

function TDeploy.Validate(Params: TStrings): boolean;
var conn: TDeployConnection;
begin
Result := false;
conn := TDeployConnection.Create(nil);
try
  if conn.Connect(Params) then
  if conn.DeployTables() then begin
    Result := true;
  end;
finally
  conn.Free;
end;
end;

//TDeployConnection

procedure TDeployConnection._connect;
begin
try
  LoginPrompt := false;
  Connected := true;
except

end;
end;

procedure TDeployConnection._disconnect;
begin
try
  Connected := false;
except

end;
end;

function TDeployConnection.Connect(Conf: TStrings): boolean;
var dbname: string;
begin
Result := false;
dbname := Trim(Conf.Values['Database\Name']);
if dbname<>'master' then begin
  Result := Connect(Conf, dbname);
end;
end;

function TDeployConnection.Connect(Conf: TStrings; DatabaseName: string): boolean;
begin
Result := false;
_disconnect;
if DatabaseName<>'' then
if Trim(Conf.Values['Database\Server'])<>'' then
if Trim(Conf.Values['Database\Account'])<>'' then
if Trim(Conf.Values['Database\Password'])<>'' then begin
  DriverName := 'MSSQL';
  Params.DriverID := 'MSSQL';
  Params.Values['Server'] := Trim(Conf.Values['Database\Server']);
  Params.Values['Database'] := Trim(DatabaseName);
  Params.Values['User_Name'] := Trim(Conf.Values['Database\Account']);
  Params.Values['Password'] := Trim(Conf.Values['Database\Password']);
  if ExistsDatabase then begin
    _connect;
  end;
  Result := Connected;
end;
end;

function sname2name(const Name: string): string;
var j: integer;
begin
Result := Name;
j := pos('.', Result);
while j>0 do begin
  Result := copy(Result, j+1);
  j := pos('.', Result);
end;
j := pos('[', Result);
if j>0 then begin
  Result := copy(Result, j+1);
  j := pos(']', Result);
  if j>0 then begin
    Result := copy(Result, 1, j-1);
  end;
end;
Result := AnsiLowerCase(Trim(Result));
end;

function TDeployConnection.Execute(SQL: TStrings): integer;
var q: TFDQuery;
  j: integer;
  s: string;
begin
Result := -1;
if (not Connected) then exit;
Result := 0;
q := TFDQuery.Create(Self);
try
  q.Connection := Self;
  for j := 0 to SQL.Count-1 do begin
    s := sqlstr(SQL[j]);
    if s<>'' then begin
      if s='GO' then begin
        if q.SQL.Count>0 then begin
          q.ExecSQL;
          Inc(Result);
          q.SQL.Clear;
        end;
      end
      else if copy(s,1,4)<>'USE ' then begin
        q.SQL.Add(s);
      end;
    end;
  end;
  if q.SQL.Count>0 then begin
    q.ExecSQL;
    Inc(Result);
  end;
finally
  q.Free;
end;
end;

function TDeployConnection.CreateTable(TableName: string; SQL: TStrings): integer;
var q: TFDQuery;
  j: integer;
  s: string;
begin
Result := -1;
if ExistsTable(TableName) then Result := 0;
if (Result>=0) or (not Connected) then exit;
q := TFDQuery.Create(Self);
try
  q.Connection := Self;
  for j := 0 to SQL.Count-1 do begin
    s := sqlstr(SQL[j]);
    if s<>'' then begin
      if s='GO' then begin
        if q.SQL.Count>0 then q.ExecSQL;
        q.SQL.Clear;
      end
      else if copy(s,1,4)<>'USE ' then begin
        s := WideStringReplace(s, '%name%', TableName, [rfReplaceAll]);
        q.SQL.Add(s);
      end;
    end;
  end;
  if q.SQL.Count>0 then q.ExecSQL;
  if ExistsTable(TableName) then Result := 1;
finally
  q.Free;
end;
end;

function TDeployConnection.ExistsTable(TableName: string): boolean;
var list: TStrings;
  j: integer;
begin
Result := false;
list := TStringList.Create;
try
  GetTableNames('', '', '', list);
  TableName := sname2name(TableName);
  j := 0;
  while j<list.Count do begin
    if sname2name(list[j])=TableName then begin
      Result := true;
      j := list.Count;
    end;
    Inc(j);
  end;
finally
  list.Free;
end;
end;

function TDeployConnection.ExistsObjects(const Names: array of string; const Ident: string): boolean;
var q: TFDQuery;
  j: integer;
  lname: string;
begin
Result := true;
q := TFDQuery.Create(Self);
try
  q.Connection := Self;
  j := 0;
  while j<Length(Names) do begin
    lname := Names[j];
    q.SQL.Text := Format('select OBJECT_ID (N''dbo.%s'', N''%s'') as n', [lname, Ident]);
    q.Open;
    if q.Fields[0].IsNull then begin
      j := Length(Names);
      Result := false;
    end;
    q.Close;
    Inc(j);
  end;
finally
  q.Free;
end;
end;

function TDeployConnection.ExistsDatabase(DatabaseName: string): boolean;
var list: TStrings;
  j: integer;
begin
Result := false;
list := TStringList.Create;
try
  GetCatalogNames('', list);
  DatabaseName := sname2name(DatabaseName);
  j := 0;
  while j<list.Count do begin
    if sname2name(list[j])=DatabaseName then begin
      Result := true;
      j := list.Count;
    end;
    Inc(j);
  end;
finally
  list.Free;
end;
end;

function TDeployConnection.ExistsDatabase: boolean;
var dbname: string;
begin
Result := false;
if Connected then begin
  Result := true;
  exit;
end;
dbname := Trim(Params.Values['Database']);
if dbname<>'' then begin
  Params.Values['Database'] := 'master';
  _connect;
  if Connected then
  if ExistsDatabase(dbname) then begin
    Result := true;
  end;
end;
Params.Values['Database'] := dbname;
end;

function TDeployConnection.CreateDatabase(DatabaseName: string; SQL: TStrings): integer;
var q: TFDQuery;
  j: integer;
  dbpath,s: string;
begin
Result := -1;
if ExistsDatabase(DatabaseName) then Result := 0;
if (Result>=0) or (not Connected) then exit;
dbpath := QueryDatabasePath();
if dbpath='' then exit;
dbpath := copy(dbpath,1,Length(dbpath)-1);
q := TFDQuery.Create(Self);
try
  q.Connection := Self;
  q.SQL.Assign(SQL);
  for j := 0 to q.SQL.Count-1 do begin
    s := sqlstr(q.SQL[j]);
    if s='GO' then s := '';
    q.SQL[j] := WideStringReplace(WideStringReplace(s, '%dbname%', DatabaseName, [rfReplaceAll]), '%dbpath%', dbpath, [rfReplaceAll]);
  end;
  q.ExecSQL;
  if ExistsDatabase(DatabaseName) then Result := 1;
finally
  q.Free;
end;
end;

function TDeployConnection.QueryDatabasePath(): string;
var q: TFDQuery;
begin
Result := '';
if (not Connected) then exit;
q := TFDQuery.Create(Self);
try
  q.Connection := Self;
  q.SQL.Add('SELECT TOP(1) create_date, m.physical_name AS FileName');
  q.SQL.Add('FROM sys.databases d JOIN sys.master_files m ON d.database_id = m.database_id');
  q.SQL.Add('WHERE m.[type] = 0');
  q.SQL.Add('ORDER BY d.create_date DESC;');
  q.Open;
  Result := Trim(q.Fields[1].AsString);
  if Result<>'' then begin
    Result := ExtractFilePath(Result);
  end;
finally
  q.Free;
end;
end;

function TDeployConnection.DeployTables(): boolean;
var j: integer;
begin
Result := false;
for j := 0 to Length(ctables)-1 do begin
  if not ExistsTable(ctables[j]) then
    Exit;
end;
if ExistsObjects(cproc, 'FN') then
if ExistsObjects(ctrigger, 'TR') then begin
  Result := true;
end;
end;

end.
