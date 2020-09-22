unit appconfig;

interface

uses Classes, Windows, SysUtils, Forms, IniFiles, Registry, Vcl.DBGrids, Grids.Helper, strtools;

type
  TAppParams = class
  public
    class function Exists(ParamNames: array of string): boolean;
  end;

  TAppConfig = class(TComponent)
  private
    F: TObject;
    FActive: boolean;
    FAutoOpen: boolean;
    FFilename: string;
    FOnChangeState: TNotifyEvent;
  protected
    procedure SetActive(AActive: boolean);
    procedure SetFilename(const AFilename: string);
    procedure DoOnChangeState;
    procedure DoOpen; virtual; abstract;
    procedure DoClose; virtual;
    function GetDefFilename: string; virtual; abstract;
    function DoReadString(const Section, Ident: string; const Def: string): string; virtual; abstract;
    procedure DoWriteString(const Section, Ident: string; const Value: string); virtual; abstract;
    function Check(const Section, Ident: string): boolean;
    function CheckObject(const Def: Vcl.DBGrids.TDBGrid): boolean;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function Open(const AFilename: string): boolean; overload;
    function Open: boolean; overload;
    procedure Close;
    procedure Write(const Section, Ident: string; const Value: string); overload;
    procedure Write(const Section, Ident: string; const Value: Longint); overload; virtual; abstract;
    procedure Write(const Section, Ident: string; const Value: TDateTime); overload; virtual; abstract;
    procedure Write(const Section, Ident: string; const Value: TForm); overload;
    procedure Write(const Section, Ident: string; const Value: TGridFields); overload;
    procedure Write(const Section, Ident: string; const Value: Vcl.DBGrids.TDBGrid); overload;
    function Read(const Section, Ident: string; const Def: string): string; overload;
    function Read(const Section, Ident: string; const Def: Longint): Longint; overload; virtual; abstract;
    function Read(const Section, Ident: string; const Def: TDateTime): TDateTime; overload; virtual; abstract;
    function Read(const Section, Ident: string; const Def: TForm): TForm; overload;
    function Read(const Section, Ident: string; const Def: TGridFields): TGridFields overload;
    function Read(const Section, Ident: string; const Def: Vcl.DBGrids.TDBGrid): Vcl.DBGrids.TDBGrid; overload;
  published
    property Active: boolean read FActive write SetActive;
    property AutoOpen: boolean read FAutoOpen write FAutoOpen;
    property Filename: string read FFilename write SetFilename;
    property DefFilename: string read GetDefFilename;
    property OnChangeState: TNotifyEvent read FOnChangeState write FOnChangeState;
  end;

  TFileConfig = class(TAppConfig)
  private
    F: TIniFile;
  protected
    procedure DoOpen; override;
    function GetDefFilename: string; override;
    function DoReadString(const Section, Ident: string; const Def: string): string; override;
    procedure DoWriteString(const Section, Ident: string; const Value: string); override;
  public
    procedure Write(const Section, Ident: string; const Value: Longint); overload; override;
    procedure Write(const Section, Ident: string; const Value: TDateTime); overload; override;
    function Read(const Section, Ident: string; const Def: Longint): Longint; overload; override;
    function Read(const Section, Ident: string; const Def: TDateTime): TDateTime; overload; override;
  end;

  TRegIniFile = class(Registry.TRegIniFile)
  public
    procedure DoWriteBuffer(const Section, Ident: string; Buffer: Pointer; BufSize: Integer; RegData: TRegDataType);
    procedure DoReadBuffer(const Section, Ident: string; Buffer: Pointer; BufSize: Integer; RegData: TRegDataType);
  end;

  TRegConfig = class(TAppConfig)
  private
    F: TRegIniFile;
  protected
    procedure DoOpen; override;
    function GetDefFilename: string; override;
    function DoReadString(const Section, Ident: string; const Def: string): string; override;
    procedure DoWriteString(const Section, Ident: string; const Value: string); override;
  public
    procedure Write(const Section, Ident: string; const Value: Longint); overload; override;
    procedure Write(const Section, Ident: string; const Value: TDateTime); overload; override;
    function Read(const Section, Ident: string; const Def: Longint): Longint; overload; override;
    function Read(const Section, Ident: string; const Def: TDateTime): TDateTime; overload; override;
  end;

implementation

// TAppParams

class function TAppParams.Exists(ParamNames: array of string): boolean;
var
  j, n: Integer;
  lparam: string;
begin
  Result := false;
  for j := 1 to ParamCount do
    begin
      lparam := AnsiLowerCase(getname(Paramstr(j)));
      if lparam <> '' then
        begin
          if CharInSet(lparam[1], ['-', '\', '/']) then
            lparam := copy(lparam, 2);
          for n := 0 to Length(ParamNames) - 1 do
            if lparam = AnsiLowerCase(ParamNames[n]) then
              begin
                Result := true;
                exit;
              end;
        end;
    end;
end;

// TAppConfig

constructor TAppConfig.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FAutoOpen := true;
  FActive := false;
  FFilename := DefFilename;
  F := nil;
  FOnChangeState := nil;
end;

destructor TAppConfig.Destroy;
begin
  FOnChangeState := nil;
  Close;
  inherited Destroy;
end;

procedure TAppConfig.SetActive(AActive: boolean);
begin
  if AActive then
    Open
  else
    Close;
end;

procedure TAppConfig.SetFilename(const AFilename: string);
begin
  if AnsiLowerCase(FFilename) <> AnsiLowerCase(AFilename) then
    begin
      Close;
      FFilename := AFilename;
    end;
end;

procedure TAppConfig.DoOnChangeState;
begin
  if Assigned(FOnChangeState) then
    FOnChangeState(Self);
end;

function TAppConfig.Open(const AFilename: string): boolean;
begin
  SetFilename(AFilename);
  Result := Open;
end;

function TAppConfig.Open: boolean;
begin
  if not FActive then
    begin
      DoOpen;
    end;
  Result := FActive;
end;

procedure TAppConfig.Close;
begin
  if not FActive then
    begin
      DoClose;
    end;
end;

procedure TAppConfig.DoClose;
begin
  if Assigned(F) then
    begin
      F.Free;
      F := nil;
      FActive := false;
      DoOnChangeState;
    end;
end;

function TAppConfig.Check(const Section, Ident: string): boolean;
begin
  Result := false;
  if FActive then
    begin
      Result := (Section <> '') and (Ident <> '');
    end else if FAutoOpen then
    if Open then
      begin
        Result := (Section <> '') and (Ident <> '');
      end;
end;

function TAppConfig.CheckObject(const Def: Vcl.DBGrids.TDBGrid): boolean;
begin
  Result := false;
  if Assigned(Def) then
    if Assigned(Def.DataSource) then
      if Assigned(Def.DataSource.DataSet) then
        if Def.DataSource.DataSet.Active then
          Result := true;
end;

// read

function TAppConfig.Read(const Section, Ident: string; const Def: string): string;
begin
  if Check(Section, Ident) then
    begin
      Result := DoReadString(Section, Ident, Def);
    end
  else begin
      Result := Def;
    end;
end;

function TAppConfig.Read(const Section, Ident: string; const Def: TForm): TForm;
var
  buff: string;
  fpos: array [0 .. 4] of Integer;
begin
  if Check(Section, Ident) then
    begin
      buff := DoReadString(Section, Ident, '');
      fpos[0] := Def.Left;
      fpos[1] := Def.Top;
      fpos[2] := Def.Width;
      fpos[3] := Def.Height;
      fpos[4] := Integer(Def.WindowState);
      if expand4int(buff, @fpos[0], 4) > 3 then
        begin
          Def.Left := fpos[0];
          Def.Top := fpos[1];
          Def.Width := fpos[2];
          Def.Height := fpos[3];
          Def.WindowState := TWindowState(fpos[4]);
        end;
    end;
  Result := Def;
end;

function TAppConfig.Read(const Section, Ident: string; const Def: TGridFields): TGridFields;
var
  fld: TGridField;
  buff: string;
  fpos: array [0 .. 1] of Integer;
  j: Integer;
begin
  Result := Def;
  if Check(Section, Ident) then
    begin
      Def.DisableControls;
      for j := 0 to Def.Count - 1 do
        begin
          fld := Def[j];
          buff := DoReadString(Section + '\' + Ident, fld.Name, '');
          fpos[0] := fld.Column;
          fpos[1] := fld.Width;
          if expand4int(buff, @fpos[0], 2) > 1 then
            begin
              fld.Column := fpos[0];
              fld.Width := fpos[1];
            end;
        end;
      Def.EnableControls;
    end;
end;

function TAppConfig.Read(const Section, Ident: string; const Def: Vcl.DBGrids.TDBGrid): Vcl.DBGrids.TDBGrid;
var
  col: TColumn;
  j, w: Integer;
begin
  Result := Def;
  if CheckObject(Def) then
    if Check(Section, Ident) then
      begin
        for j := 0 to Def.Columns.Count - 1 do
          begin
            col := Def.Columns[j];
            w := Read(Section + '\' + Ident, col.FieldName, col.Width);
            if w > (Def.Width - 40) then
              w := (Def.Width - 40);
            col.Width := w;
          end;
      end;
end;

// write

procedure TAppConfig.Write(const Section, Ident: string; const Value: string);
begin
  if Check(Section, Ident) then
    begin
      DoWriteString(Section, Ident, Value);
    end;
end;

procedure TAppConfig.Write(const Section, Ident: string; const Value: TForm);
var
  buff: string;
  fpos: array [0 .. 4] of Integer;
begin
  if Check(Section, Ident) then
    begin
      if Value.WindowState = wsNormal then
        begin
          buff := Format('%d:%d:%d:%d:%d', [Value.Left, Value.Top, Value.Width, Value.Height, Integer(Value.WindowState)]);
          DoWriteString(Section, Ident, buff);
        end
      else begin
          buff := TIniFile(F).ReadString(Section, Ident, '');
          if expand4int(buff, @fpos[0], 5) > 3 then
            begin
              buff := Format('%d:%d:%d:%d:%d', [fpos[0], fpos[1], fpos[2], fpos[3], Integer(Value.WindowState)]);
              DoWriteString(Section, Ident, buff);
            end;
        end;
    end;
end;

procedure TAppConfig.Write(const Section, Ident: string; const Value: TGridFields);
var
  fld: TGridField;
  j: Integer;
begin
  if Check(Section, Ident) then
    begin
      Value.Realign;
      for j := 0 to Value.Count - 1 do
        begin
          fld := Value[j];
          Write(Section + '\' + Ident, fld.Name, Format('%d:%d', [fld.Column, fld.Width]));
        end;
    end;
end;

procedure TAppConfig.Write(const Section, Ident: string; const Value: Vcl.DBGrids.TDBGrid);
var
  col: TColumn;
  j: Integer;
begin
  if CheckObject(Value) then
    if Check(Section, Ident) then
      begin
        for j := 0 to Value.Columns.Count - 1 do
          begin
            col := Value.Columns[j];
            Write(Section + '\' + Ident, col.FieldName, col.Width);
          end;
      end;
end;

// TFileConfig

procedure TFileConfig.DoOpen;
begin
  DoClose;
  if FFilename <> '' then
    begin
      F := TIniFile.Create(FFilename);
      FActive := true;
      DoOnChangeState;
    end;
end;

function TFileConfig.GetDefFilename: string;
begin
  Result := ChangeFileExt(Paramstr(0), '.conf');
end;

function TFileConfig.DoReadString(const Section, Ident: string; const Def: string): string;
begin
  Result := TIniFile(F).ReadString(Section, Ident, Def);
end;

procedure TFileConfig.DoWriteString(const Section, Ident: string; const Value: string);
begin
  TIniFile(F).WriteString(Section, Ident, Value);
end;

procedure TFileConfig.Write(const Section, Ident: string; const Value: Longint);
begin
  if Check(Section, Ident) then
    begin
      TIniFile(F).WriteInteger(Section, Ident, Value);
    end;
end;

procedure TFileConfig.Write(const Section, Ident: string; const Value: TDateTime);
begin
  if Check(Section, Ident) then
    begin
      TIniFile(F).WriteDateTime(Section, Ident, Value);
    end;
end;

function TFileConfig.Read(const Section, Ident: string; const Def: Longint): Longint;
begin
  if Check(Section, Ident) then
    begin
      Result := TIniFile(F).ReadInteger(Section, Ident, Def);
    end
  else begin
      Result := Def;
    end;
end;

function TFileConfig.Read(const Section, Ident: string; const Def: TDateTime): TDateTime;
begin
  if Check(Section, Ident) then
    begin
      Result := TIniFile(F).ReadDateTime(Section, Ident, Def);
    end
  else begin
      Result := Def;
    end;
end;

// TRegIniFile

procedure TRegIniFile.DoWriteBuffer(const Section, Ident: string; Buffer: Pointer; BufSize: Integer; RegData: TRegDataType);
var
  Key, OldKey: HKEY;
begin
  CreateKey(Section);
  Key := GetKey(Section);
  if Key <> 0 then
    try
      OldKey := CurrentKey;
      SetCurrentKey(Key);
      try
        PutData(Ident, Buffer, BufSize, RegData);
      finally
        SetCurrentKey(OldKey);
      end;
    finally
      RegCloseKey(Key);
    end;
end;

procedure TRegIniFile.DoReadBuffer(const Section, Ident: string; Buffer: Pointer; BufSize: Integer; RegData: TRegDataType);
var
  Key, OldKey: HKEY;
begin
  CreateKey(Section);
  Key := GetKey(Section);
  if Key <> 0 then
    try
      OldKey := CurrentKey;
      SetCurrentKey(Key);
      try
        GetData(Ident, Buffer, BufSize, RegData);
      finally
        SetCurrentKey(OldKey);
      end;
    finally
      RegCloseKey(Key);
    end;
end;

// TRegConfig

procedure TRegConfig.DoOpen;
begin
  DoClose;
  if FFilename <> '' then
    begin
      F := TRegIniFile.Create(FFilename);
      FActive := true;
      DoOnChangeState;
    end;
end;

function TRegConfig.GetDefFilename: string;
begin
  Result := 'Software\' + ChangeFileExt(ExtractFilename(Paramstr(0)), '');
end;

function TRegConfig.DoReadString(const Section, Ident: string; const Def: string): string;
begin
  Result := TRegIniFile(F).ReadString(Section, Ident, Def);
end;

procedure TRegConfig.DoWriteString(const Section, Ident: string; const Value: string);
begin
  TRegIniFile(F).WriteString(Section, Ident, Value);
end;

procedure TRegConfig.Write(const Section, Ident: string; const Value: Longint);
begin
  if Check(Section, Ident) then
    begin
      TRegIniFile(F).WriteInteger(Section, Ident, Value);
    end;
end;

procedure TRegConfig.Write(const Section, Ident: string; const Value: TDateTime);
begin
  if Check(Section, Ident) then
    begin
      TRegIniFile(F).DoWriteBuffer(Section, Ident, @Value, SizeOf(TDateTime), rdBinary);
    end;
end;

function TRegConfig.Read(const Section, Ident: string; const Def: Longint): Longint;
begin
  if Check(Section, Ident) then
    begin
      Result := TRegIniFile(F).ReadInteger(Section, Ident, Def);
    end
  else begin
      Result := Def;
    end;
end;

function TRegConfig.Read(const Section, Ident: string; const Def: TDateTime): TDateTime;
begin
  Result := Def;
  if Check(Section, Ident) then
    begin
      TRegIniFile(F).DoReadBuffer(Section, Ident, @Result, SizeOf(TDateTime), rdBinary);
    end;
end;

end.
