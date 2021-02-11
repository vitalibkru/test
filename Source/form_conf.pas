unit form_conf;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, appconfig, Vcl.Grids, Vcl.ValEdit, strtools,
  System.Actions, Vcl.ActnList, System.ImageList, Vcl.ImgList;

type
  Tfrm_conf = class(TForm)
    ValueListEditor1: TValueListEditor;
    ActionList1: TActionList;
    ImageList1: TImageList;
    act_result_ok: TAction;
    act_result_cancel: TAction;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ValueListEditor1GetPickList(Sender: TObject; const KeyName: string; Values: TStrings);
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure act_result_okExecute(Sender: TObject);
    procedure act_result_cancelExecute(Sender: TObject);
  private
    FOnParamsApply: TNotifyEvent;
    FGetPickListEvent: TGetPickListEvent;
    FConfig: TAppConfig;
    procedure SetConfig(AConfig: TAppConfig);
    function GetValue(ValueName: string): string;
    procedure SetValue(ValueName: string; const Source: string);
  public
    property OnParamsApply: TNotifyEvent read FOnParamsApply write FOnParamsApply;
    property GetPickListEvent: TGetPickListEvent read FGetPickListEvent write FGetPickListEvent;
    property Config: TAppConfig read FConfig write SetConfig;
    property Value[ValueName: string]: string read GetValue write SetValue;
    procedure ReadConfig(Section: string);
    procedure WriteConfig(Section: string);
  public
    class function AsBool(const Source: string): boolean;
    class function ToStr(const Source: boolean): string;
  end;

implementation

{$R *.dfm}

procedure Tfrm_conf.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure Tfrm_conf.SetConfig(AConfig: TAppConfig);
begin
  FConfig := AConfig;
  ReadConfig('');
end;

procedure Tfrm_conf.FormDestroy(Sender: TObject);
begin
WriteConfig('');
end;

procedure Tfrm_conf.FormKeyPress(Sender: TObject; var Key: Char);
begin
case Key of
  #13: begin
    act_result_okExecute(Sender);
    Key := #0;
  end;
  #27: begin
    act_result_cancelExecute(Sender);
    Key := #0;
  end;
end;
end;

function Tfrm_conf.GetValue(ValueName: string): string;
begin
if ValueName='' then Result := ''
else Result := ValueListEditor1.Values[ValueName];
end;

procedure Tfrm_conf.SetValue(ValueName: string; const Source: string);
begin
if ValueName<>'' then begin
  ValueListEditor1.Values[ValueName] := Trim(Source);
end;
end;

procedure Tfrm_conf.ValueListEditor1GetPickList(Sender: TObject; const KeyName: string; Values: TStrings);
begin
if Assigned(FGetPickListEvent) then begin
  FGetPickListEvent(Self, KeyName, Values);
end;
end;

procedure Tfrm_conf.ReadConfig(Section: string);
begin
if Assigned(FConfig) then begin
  if Section='' then Section := ClassName;
  FConfig.Read(Section, 'position', Self);
  ValueListEditor1.ColWidths[0] := FConfig.Read(Section, 'cname', ValueListEditor1.ColWidths[0]);
  FConfig.Close;
end;
end;

procedure Tfrm_conf.WriteConfig(Section: string);
begin
if Assigned(FConfig) then begin
  if Section='' then Section := ClassName;
  FConfig.Write(Section, 'position', Self);
  FConfig.Write(Section, 'cname', ValueListEditor1.ColWidths[0]);
  FConfig.Close;
end;
end;

procedure Tfrm_conf.act_result_cancelExecute(Sender: TObject);
begin
ModalResult := mrCancel;
if not (fsModal in FormState) then begin
  Close;
end;
end;

procedure Tfrm_conf.act_result_okExecute(Sender: TObject);
begin
ModalResult := mrOk;
if not (fsModal in FormState) then begin
  Close;
end;
end;

class function Tfrm_conf.AsBool(const Source: string): boolean;
begin
Result := str2bool(Source, false);
end;

class function Tfrm_conf.ToStr(const Source: boolean): string;
begin
Result := cname_bool[Source];
end;

end.
