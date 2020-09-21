unit strtools;

interface

uses SysUtils;

  function datetime2sql(const Source: TDateTime): string;
  function datetime2str(const Source: TDateTime; Fmt: string): string;
  function str2bool(Source: string; def: boolean): boolean;
  function str2digits(const Source: string): string;
  function str2int(const Source: string): int64;
  function str2uint(const Source: string): uint64;
  function expand4int(Source: string; Value: PInteger; Count: integer): integer;
  function str2float(const Source: string): double;
  function str2barcode(const Source: string; Count:word): string;
  function str2ean13(const src: string): UInt64;
  function getname(const src: string): string;

implementation

function datetime2sql(const Source: TDateTime): string;
begin
if Source<4000 then begin
  Result := 'NULL';
end
else begin
  DateTimeToString(Result, 'YYYY-MM-DD HH:MM:SS', Source, FormatSettings);
  Result := Format('CONVERT(datetime, ''%s'', 20)', [Result]);
end;
end;

function datetime2str(const Source: TDateTime; Fmt: string): string;
begin
if Source<4000 then begin
  Result := '';
end
else begin
  DateTimeToString(Result, Fmt, Source, FormatSettings);
end;
end;

function str2digits(const Source: string): string;
var j: integer;
begin
Result := '';
j := 1;
while j<=Length(Source) do begin
  case Source[j] of
    '-': if Result='' then Result := '-' else j := Length(Source);
    '0'..'9': Result := Result+Source[j];
    #9,#32,#160:;
    else if Result<>'' then j := Length(Source);
  end;
  Inc(j);
end;
if (Result='') or (Result='-') then Result := '0';
end;

function str2int(const Source: string): int64;
var s: string;
begin
if Source='' then begin
  Result := 0;
end
else begin
  s := str2digits(Source);
  if Length(s)<19 then Result := StrToInt64(s)
  else Result := StrToInt64(copy(s,1,18));
end;
end;

function str2uint(const Source: string): uint64;
begin
Result := abs(str2int(Source));
end;

function expand4int(Source: string; Value: PInteger; Count: integer): integer;
var j: integer;
begin
Result := 0;
while (Source<>'') and (Result<Count) do begin
  j := pos(':', Source);
  if j>0 then begin
    PInteger(PByte(value)+SizeOf(Integer)*Result)^ := str2int(copy(Source, 1, j-1));
    Source := copy(Source, j+1);
  end
  else begin
    PInteger(PByte(value)+SizeOf(Integer)*Result)^ := str2int(Source);
    Source := '';
  end;
  Inc(Result);
end;
end;

function str2bool(Source: string; def: boolean): boolean;
begin
Result := def;
Source := Trim(Source);
if Source<>'' then begin
  if pos(Source[1], 'tTeE1+yYäÄïÏ')>0 then Result := true
  else if pos(Source[1], 'fFdD0-nNíÍëË')>0 then Result := false;
end;
end;

function str2float(const Source: string): double;
var j: integer;
  s: string;
begin
s := '';
for j := 1 to Length(Source) do
case Source[j] of
  '0'..'9': s := s+Source[j];
  '.',',': if s='' then s := '0.' else s := s+FormatSettings.DecimalSeparator;
  '-': if s='' then s := '-';
end;
if (s='') or (s='-') then Result := 0
else begin
  if s[Length(s)]='.' then s := s+'0';
  Result := StrToFloat(s);
end;
end;

function str2barcode(const Source: string; Count:word): string;
begin
Result := str2digits(Source);
if Length(Result)>Count then Result := copy(Result,1,Count)
else begin
  while Length(Result)<Count do Result := '0'+Result;
end;
end;

function str2ean13(const src: string): UInt64;
const nn: array[1..12]of byte = (1,3,1,3,1,3,1,3,1,3,1,3);
var s,ss: integer;
  buff: string;
begin
buff := str2digits(src);
if Length(buff)<2 then begin
  Result := 0;
  Exit;
  end;
if Length(buff)>13 then buff := copy(buff,Length(buff)-12)
else while Length(buff)<13 do buff := '0'+buff;
ss := 0;
for s := 1 to 12 do
Inc(ss,StrToInt(buff[s])*nn[s]);
s := round(int(ss/10));
if ss>(10*s) then Inc(s);
buff[13] := IntToStr((10*s)-ss)[1];
Result := StrToUInt64(copy(buff,1,13));
end;

function getname(const src: string): string;
var j: integer;
begin
if src='' then Result := ''
else begin
  j := pos('=', src);
  if j>0 then Result := Trim(copy(src,1,j-1))
  else Result := Trim(src);
end;
end;

end.
