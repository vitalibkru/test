unit Grids.Helper;

interface

uses Classes, Windows, Graphics, SysUtils, Vcl.Grids, Vcl.DBGrids, Data.DB;

type
  TGetParams = procedure(Index: integer; Values: TStrings) of object;
  TQueryDocExecute = procedure(Sender: TObject; Date: TDateTime; Name: string; GetData: TGetParams; Count: integer) of object;
  TQueryDocFind = function(Sender: TObject; Date: TDateTime; Param: integer): Cardinal of object;

  TGridFields = class;

  TGridField = class
  private
    FList: TGridFields;
    FName: string;
    FTitle: string;
    FColumn: integer;
    FWidth: integer;
    FOnChanged: TNotifyEvent;
    procedure SetTitle(const Value: string);
    procedure SetColumn(Value: integer);
    procedure SetWidth(Value: integer);
    procedure DoChanged;
  public
    property List: TGridFields read FList;
    property Name: string read FName;
    property Title: string read FTitle write SetTitle;
    property Column: integer read FColumn write SetColumn;
    property Width: integer read FWidth write SetWidth;
    property OnChanged: TNotifyEvent read FOnChanged write FOnChanged;
  end;

  TStringGrid = class;

  TGridFields = class(TList)
  private
    FGrid: TStringGrid;
    FOnChanged: TNotifyEvent;
    FDisabledControls: boolean;
    FChanged: boolean;
  protected
    function Get(Index: integer): TGridField; reintroduce;
    function GetColumn(Name: string): integer;
    procedure DoChanged;
    procedure OnFieldChanged(Sender: TObject);
    procedure UpdateColumn(Sender: TGridField; NewColumn: integer);
  public
    constructor Create; reintroduce;
    destructor Destroy; override;
    procedure DisableControls;
    procedure EnableControls;
    function IndexOf(Name: string): integer; reintroduce;
    function Find(Name: string): TGridField;
    function Add(Name: string; Title: string; Column: integer): TGridField; reintroduce; overload;
    function Add(Name: string; Title: string): TGridField; reintroduce; overload;
    procedure Clear; override;
    procedure Delete(Index: integer); reintroduce; overload;
    procedure Delete(Name: string); reintroduce; overload;
    procedure Reindex;
    procedure Realign;
    property Items[Index: integer]: TGridField read Get; default;
    property Column[Name: string]: integer read GetColumn;
    property OnChanged: TNotifyEvent read FOnChanged write FOnChanged;
    property Grid: TStringGrid read FGrid;
  end;

  TStringGrid = class(Vcl.Grids.TStringGrid)
  private
    FFields: TGridFields;
  protected
    procedure OnChangeField(Sender: TObject);
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    function GetCount: integer;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function GetExists(ARow: integer): boolean;
    procedure DoDeleteRow(ARow: integer);
    procedure DoInsertRow(ARow: integer);
    function GetValue(Index: integer; ValueName: string): string;
    procedure GetValues(Index: integer; Values: TStrings);
    procedure SetValues(Index: integer; Values: TStrings);
    property Count: integer read GetCount;
    property Fields: TGridFields read FFields;
    procedure LoadFromFile(FileName: string);
    procedure SaveToFile(FileName: string);
  end;

  TDBGrid = class(Vcl.DBGrids.TDBGrid)
  private
    FOnChangeReadOnly: TNotifyEvent;
    function DoGetReadOnly: boolean;
    procedure DoSetReadOnly(const AValue: boolean);
  public
    function GetDataName: string;
    procedure UpdateColumnStyle;
  published
    property OnChangeReadOnly: TNotifyEvent read FOnChangeReadOnly write FOnChangeReadOnly;
    property ReadOnly: boolean read DoGetReadOnly write DoSetReadOnly;
  end;

  TCsv = class
  private
    FHeader: array of record Name: string;
    Column: integer;
  end;

function GetValue(var source: string; var Value: string): boolean;
procedure sethead(source: string);
procedure setdata(Grid: Vcl.Grids.TStringGrid; row: integer; source: string);
public
  procedure LoadFromFile(Destination: Vcl.Grids.TStringGrid; Fields: TGridFields; FileName: string);
  procedure SaveToFile(source: Vcl.Grids.TStringGrid; Fields: TGridFields; FileName: string);
  end;

implementation

// TGridField

procedure TGridField.SetTitle(const Value: string);
begin
  if FTitle <> Value then
    begin
      FTitle := Value;
      DoChanged;
    end;
end;

procedure TGridField.SetColumn(Value: integer);
begin
  if FColumn <> Value then
    begin
      FList.UpdateColumn(Self, Value);
      FColumn := Value;
      DoChanged;
    end;
end;

procedure TGridField.SetWidth(Value: integer);
begin
  if FWidth <> Value then
    begin
      FWidth := Value;
      DoChanged;
    end;
end;

procedure TGridField.DoChanged;
begin
  if Assigned(FOnChanged) then
    FOnChanged(Self);
end;

// TGridFields

constructor TGridFields.Create;
begin
  inherited Create;
  FGrid := nil;
  FChanged := false;
  EnableControls;
end;

destructor TGridFields.Destroy;
begin
  DisableControls;
  inherited Destroy;
end;

procedure TGridFields.DisableControls;
begin
  FDisabledControls := true;
end;

procedure TGridFields.EnableControls;
begin
  FDisabledControls := false;
  if FChanged then
    DoChanged;
end;

procedure TGridFields.DoChanged;
begin
  FChanged := true;
  if not FDisabledControls then
    begin
      if Assigned(FOnChanged) then
        FOnChanged(Self);
      FChanged := false;
    end;
end;

procedure TGridFields.OnFieldChanged(Sender: TObject);
begin
  DoChanged;
end;

procedure TGridFields.UpdateColumn(Sender: TGridField; NewColumn: integer);
var
  Index: integer;
  LItem: TGridField;
begin
  for Index := 0 to Count - 1 do
    begin
      LItem := Items[Index];
      if not LItem.Equals(Sender) then
        begin
          if LItem.Column = NewColumn then
            begin
              LItem.FColumn := Sender.Column;
            end;
        end;
    end;
end;

function TGridFields.Get(Index: integer): TGridField;
begin
  Result := TGridField(inherited Get(Index));
end;

function TGridFields.GetColumn(Name: string): integer;
var
  LItem: TGridField;
begin
  LItem := Find(Name);
  if Assigned(LItem) then
    Result := LItem.Column
  else
    Result := -1;
end;

function TGridFields.Find(Name: string): TGridField;
var
  Index: integer;
begin
  Index := IndexOf(Name);
  if Index < 0 then
    Result := nil
  else
    Result := Items[Index];
end;

function TGridFields.IndexOf(Name: string): integer;
var
  LItem: TGridField;
  Index: integer;
begin
  Result := -1;
  Name := AnsiLowerCase(Name);
  for Index := 0 to Count - 1 do
    begin
      LItem := Items[Index];
      if LItem.Name = Name then
        begin
          Result := Index;
          exit;
        end;
    end;
end;

function TGridFields.Add(Name: string; Title: string; Column: integer): TGridField;
begin
  Result := TGridField.Create;
  Result.FList := Self;
  Result.FName := AnsiLowerCase(Name);
  Result.FTitle := Title;
  Result.FColumn := Column;
  Result.FWidth := 0;
  Result.FOnChanged := OnFieldChanged;
  inherited Add(Result);
  DoChanged;
end;

function TGridFields.Add(Name: string; Title: string): TGridField;
begin
  if Count > 0 then
    Result := Add(Name, Title, Items[Count - 1].Column + 1)
  else
    Result := Add(Name, Title, 0);
end;

procedure TGridFields.Clear;
var
  Index: integer;
begin
  for Index := 0 to Count - 1 do
    Items[Index].Free;
  inherited Clear;
  DoChanged;
end;

procedure TGridFields.Delete(Index: integer);
begin
  Items[Index].Free;
  inherited Delete(Index);
  DoChanged;
end;

procedure TGridFields.Delete(Name: string);
var
  Index: integer;
begin
  Index := IndexOf(Name);
  if Index >= 0 then
    Delete(Index);
end;

procedure TGridFields.Reindex;
var
  Index: integer;
begin
  for Index := 0 to Count - 1 do
    Items[Index].Column := Index;
end;

procedure TGridFields.Realign;
var
  Index, LWidth: integer;
  LItem: TGridField;
begin
  if Assigned(FGrid) then
    for Index := 0 to Count - 1 do
      begin
        LItem := Items[Index];
        LWidth := FGrid.ColWidths[LItem.Column];
        if LWidth < 20 then
          LWidth := 20;
        LItem.FWidth := LWidth;
      end;
end;

// TDBGrid

procedure TDBGrid.UpdateColumnStyle;
const
  ccolor: array [boolean] of TColor = (clWindowText, clGreen);
var
  Index: integer;
  Field: TField;
begin
  for Index := 0 to Columns.Count - 1 do
    begin
      Field := Columns[Index].Field;
      if Assigned(Field) then
        begin
          Columns[Index].Font.Color := ccolor[Field.ReadOnly];
        end;
    end;
end;

function TDBGrid.GetDataName: string;
var
  ds: TDataSet;
begin
  Result := '';
  if Assigned(DataSource) then
    begin
      ds := DataSource.DataSet;
      if Assigned(ds) then
        if ds.Active then
          begin
            Result := ds.Name;
          end;
    end;
end;

function TDBGrid.DoGetReadOnly: boolean;
begin
  Result := inherited ReadOnly;
end;

procedure TDBGrid.DoSetReadOnly(const AValue: boolean);
begin
  inherited ReadOnly := AValue;
  if Assigned(FOnChangeReadOnly) then
    FOnChangeReadOnly(Self);
end;

// TStringGrid

constructor TStringGrid.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FFields := TGridFields.Create;
  FFields.FGrid := Self;
  FFields.OnChanged := OnChangeField;
end;

destructor TStringGrid.Destroy;
begin
  FFields.Free;
  inherited Destroy;
end;

procedure TStringGrid.OnChangeField(Sender: TObject);
var
  Index: integer;
  LField: TGridField;
begin
  ColCount := FFields.Count;
  for Index := 0 to FFields.Count - 1 do
    begin
      LField := FFields[Index];
      if ColCount <= LField.Column then
        ColCount := LField.Column + 1;
      Cells[LField.Column, 0] := LField.Title;
      if LField.Width > 0 then
        ColWidths[LField.Column] := LField.Width;
    end;
  if ColCount > 1 then
    FixedCols := 1;
  if RowCount > 1 then
    FixedRows := 1;
end;

function TStringGrid.GetCount: integer;
begin
  Result := 0;
  if RowCount = 2 then
    begin
      if GetExists(1) then
        Result := 1;
    end else if RowCount > 2 then
    begin
      Result := RowCount - 1;
      if not GetExists(Result) then
        Dec(Result);
    end;
end;

function TStringGrid.GetValue(Index: integer; ValueName: string): string;
var
  Field: TGridField;
begin
  Result := '';
  Field := FFields.Find(ValueName);
  if Assigned(Field) then
    if (Field.Column >= 0) and (Field.Column < ColCount) then
      if (Index >= 0) and (Index < (RowCount - 1)) then
        begin
          Result := Trim(Cells[Field.Column, Index + 1]);
        end;
end;

procedure TStringGrid.GetValues(Index: integer; Values: TStrings);
var
  n: integer;
begin
  if (Index >= 0) and (Index < (RowCount - 1)) then
    begin
      Inc(Index);
      for n := 0 to FFields.Count - 1 do
        begin
          Values.Values[FFields[n].Name] := Trim(Cells[FFields[n].Column, Index]);
        end;
    end;
end;

procedure TStringGrid.SetValues(Index: integer; Values: TStrings);
var
  n: integer;
begin
  if (Index >= 0) and (Index < RowCount) then
    begin
      Inc(Index);
      if RowCount < (Index + 1) then
        RowCount := Index + 1;
      for n := 0 to FFields.Count - 1 do
        begin
          Cells[FFields[n].Column, Index] := Trim(Values.Values[FFields[n].Name]);
        end;
    end;
end;

procedure TStringGrid.KeyDown(var Key: Word; Shift: TShiftState);
begin
  case Key of
    40:
      if (Shift = []) and (row = (RowCount - 1)) then
        begin // Down
          if GetExists(RowCount - 1) then
            begin
              RowCount := RowCount + 1;
              Rows[RowCount - 1].Clear;
              row := RowCount - 1;
              exit;
            end;
        end;
    38:
      if (Shift = []) and ((RowCount > 2) and (row = (RowCount - 1))) then
        begin // Up
          if not GetExists(RowCount - 1) then
            begin
              RowCount := RowCount - 1;
              row := RowCount - 1;
              exit;
            end;
        end;
    46:
      if (Shift = [ssCtrl]) and (row > 0) then
        begin // Del
          DoDeleteRow(row);
        end;
    45:
      if (Shift = [ssCtrl]) and (row > 0) then
        begin // Insert
          DoInsertRow(row);
        end;
  end;
  inherited KeyDown(Key, Shift);
end;

function TStringGrid.GetExists(ARow: integer): boolean;
begin
  Result := false;
  if pos(#13#10, Trim(Rows[RowCount - 1].Text)) > 0 then
    begin
      Result := true;
    end;
end;

procedure TStringGrid.DoDeleteRow(ARow: integer);
var
  n: integer;
begin
  if (ARow = 1) and (RowCount = 2) then
    begin
      Rows[1].Clear;
    end else if (ARow > 0) and (RowCount > 2) then
    begin
      if (ARow < (RowCount - 1)) then
        for n := ARow to RowCount - 2 do
          begin
            Rows[n].Assign(Rows[n + 1]);
          end;
      RowCount := RowCount - 1;
    end;
end;

procedure TStringGrid.DoInsertRow(ARow: integer);
var
  n: integer;
begin
  if (ARow > 0) then
    if GetExists(ARow) then
      begin
        RowCount := RowCount + 1;
        for n := RowCount - 1 downto ARow + 1 do
          begin
            Rows[n].Assign(Rows[n - 1]);
          end;
        Rows[ARow].Clear;
      end;
end;

procedure TStringGrid.LoadFromFile(FileName: string);
var
  f: TCsv;
begin
  f := TCsv.Create;
  try
    f.LoadFromFile(Self, FFields, FileName);
  finally
    f.Free;
  end;
end;

procedure TStringGrid.SaveToFile(FileName: string);
var
  f: TCsv;
begin
  f := TCsv.Create;
  try
    f.SaveToFile(Self, FFields, FileName);
  finally
    f.Free;
  end;
end;

// TCsv

function TCsv.GetValue(var source: string; var Value: string): boolean;
var
  j: integer;
begin
  j := pos(';', source);
  if j > 0 then
    begin
      Value := Trim(copy(source, 1, j - 1));
      source := copy(source, j + 1);
      Result := true;
    end
  else begin
      Value := Trim(source);
      source := '';
      Result := Value <> '';
    end;
end;

procedure TCsv.sethead(source: string);
var
  buff: string;
  n: integer;
begin
  SetLength(FHeader, 0);
  while source <> '' do
    begin
      if GetValue(source, buff) then
        begin
          n := Length(FHeader);
          SetLength(FHeader, n + 1);
          FHeader[n].Name := buff;
          FHeader[n].Column := -1;
        end;
    end;
end;

procedure TCsv.setdata(Grid: Vcl.Grids.TStringGrid; row: integer; source: string);
var
  lcol: integer;
  buff: string;
begin
  lcol := 0;
  if Grid.RowCount <= row then
    Grid.RowCount := row + 1;
  Grid.Rows[row].Clear;
  while (lcol < Length(FHeader)) and (source <> '') do
    begin
      if GetValue(source, buff) then
        begin
          with FHeader[lcol] do
            if Column >= 0 then
              Grid.Cells[Column, row] := buff;
        end;
      Inc(lcol);
    end;
end;

procedure TCsv.LoadFromFile(Destination: Vcl.Grids.TStringGrid; Fields: TGridFields; FileName: string);
var
  f: TextFile;
  buff: string;
  row: integer;
begin
  AssignFile(f, FileName);
  Reset(f);
  try
    if not eof(f) then
      begin
        ReadLn(f, buff);
        sethead(buff);
        for row := 0 to Length(FHeader) - 1 do
          FHeader[row].Column := Fields.IndexOf(FHeader[row].Name);
        row := 0;
        while not eof(f) do
          begin
            ReadLn(f, buff);
            Inc(row);
            setdata(Destination, row, buff);
          end;
      end;
  finally
    CloseFile(f);
  end;
end;

procedure TCsv.SaveToFile(source: Vcl.Grids.TStringGrid; Fields: TGridFields; FileName: string);
var
  f: TextFile;
  lrow: integer;
  n: integer;
  fld: TGridField;
begin
  AssignFile(f, FileName);
  Rewrite(f);
  try
    for n := 0 to Fields.Count - 1 do
      begin
        fld := Fields[n];
        Write(f, fld.Name + ';');
      end;
    WriteLn(f, '');
    for lrow := 1 to source.RowCount - 1 do
      begin
        for n := 0 to Fields.Count - 1 do
          begin
            fld := Fields[n];
            Write(f, source.Cells[fld.Column, lrow] + ';');
          end;
        WriteLn(f, '');
      end;
  finally
    CloseFile(f);
  end;

end;

end.
