unit form_splash;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, form_main, Vcl.StdCtrls;

type
  Tfrm_splash = class(TForm)
    FTimer: TTimer;
    FImage: TImage;
    FPanel: TPanel;
    FLabel: TLabel;
    procedure FTimerTimer(Sender: TObject);
  private
    FForm: TForm;
    procedure FormShow(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  public
    procedure DoSetTitle(const ACaption: string);
  end;

var
  frm_splash: Tfrm_splash;

implementation

{$R *.dfm}

procedure Tfrm_splash.FormDestroy(Sender: TObject);
begin
FForm := nil;
TThread.Queue(nil, procedure begin
  DoSetTitle('Завершение');
  Close;
  end);
end;

procedure Tfrm_splash.FormShow(Sender: TObject);
begin
TThread.Queue(nil, procedure begin
  DoSetTitle('');
  Hide;
  end);
end;

procedure Tfrm_splash.DoSetTitle(const ACaption: string);
begin
Caption := Application.Title+' - '+ACaption;
FLabel.Caption := ACaption;
Application.ProcessMessages;
end;

procedure Tfrm_splash.FTimerTimer(Sender: TObject);
begin
FTimer.Enabled := false;
if not Assigned(FForm) then begin
  DoSetTitle('Запуск');
  FForm := Tfrm_main.Create(Self);
  InsertComponent(FForm);
  FForm.OnDestroy := FormDestroy;
  FForm.OnShow := FormShow;
  FForm.Show;
end;
end;

end.
