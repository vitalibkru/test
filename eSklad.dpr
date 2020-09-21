program eSklad;

{$R 'sql.res' 'Source\sql\sql.rc'}

uses
  Vcl.Forms,
  form_main in 'Source\form_main.pas' {frm_main},
  form_dm in 'Source\form_dm.pas' {FDM: TDataModule},
  form_conf in 'Source\form_conf.pas' {frm_conf},
  DCPbase64 in 'Source\DCPbase64.pas',
  deploy in 'Source\deploy.pas',
  form_docview in 'Source\form_docview.pas' {frm_docview},
  strtools in 'Source\strtools.pas',
  Grids.Helper in 'Source\Grids.Helper.pas',
  form_doc_consumption in 'Source\form_doc_consumption.pas',
  form_doc_moving in 'Source\form_doc_moving.pas',
  form_doc_arrival in 'Source\form_doc_arrival.pas',
  form_find_goods in 'Source\form_find_goods.pas' {frm_find_goods},
  form_leftovers in 'Source\form_leftovers.pas' {frm_leftovers},
  Form.Helper in 'Source\Form.Helper.pas',
  form_doccreate in 'Source\form_doccreate.pas' {frm_doccreate},
  form_dbtable in 'Source\form_dbtable.pas',
  form_findleftovers in 'Source\form_findleftovers.pas',
  form_splash in 'Source\form_splash.pas' {frm_splash},
  appconfig in 'Source\appconfig.pas',
  sysmenu in 'Source\sysmenu.pas',
  docparam in 'Source\docparam.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'eSklad';
  Application.MainFormOnTaskbar := False;
  Application.CreateForm(Tfrm_splash, frm_splash);
  Application.Run;
end.
