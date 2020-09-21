unit form_findleftovers;

interface

uses Classes, Windows, SysUtils, DBCtrls, Forms, appconfig, form_dbtable, strtools, docparam;

type
  TDbForm_findleftovers = class(TDbForm)
  private
    FConfig: TAppConfig;
  protected
    procedure FormClose(Sender: TObject; var Action: TCloseAction); override;
    procedure SetConfig(AConfig: TAppConfig);
  public
    constructor Create(AOwner: TComponent); override;
    procedure SetParams(Sender: TGoods); reintroduce;
    procedure DataSetOpen(Sender: TObject); override;
    procedure DataSetClose(Sender: TObject); override;
    property Config: TAppConfig read FConfig write SetConfig;
  end;

implementation

constructor TDbForm_findleftovers.Create(AOwner: TComponent);
begin
inherited Create(AOwner);
Position := poDesigned;
Caption := 'Поиск товаров для списания';
Grid.ReadOnly := true;
Navigator.VisibleButtons := [nbFirst,nbPrior,nbNext,nbLast,nbRefresh];
FConfig := nil;
end;

procedure TDbForm_findleftovers.FormClose(Sender: TObject; var Action: TCloseAction);
begin
if Assigned(FConfig) then begin
  FConfig.Write(ClassName, 'position', Self);
  if DataSetActive then begin
    FConfig.Write(ClassName, 'grid', Grid);
  end;
  FConfig.Close;
end;
inherited;
end;

procedure TDbForm_findleftovers.SetConfig(AConfig: TAppConfig);
begin
FConfig := AConfig;
if Assigned(FConfig) then begin
  FConfig.Read(ClassName, 'position', Self);
  if DataSetActive then begin
    FConfig.Read(ClassName, 'grid', Grid);
  end;
  FConfig.Close;
end;
end;

procedure TDbForm_findleftovers.DataSetOpen(Sender: TObject);
begin
inherited;
if Assigned(FConfig) then begin
  FConfig.Read(ClassName, 'grid', Grid);
  FConfig.Close;
end;
end;

procedure TDbForm_findleftovers.DataSetClose(Sender: TObject);
begin
if Assigned(FConfig) then
if DataSetActive then begin
  FConfig.Write(ClassName, 'grid', Grid);
  FConfig.Close;
end;
inherited;
end;

procedure TDbForm_findleftovers.SetParams(Sender: TGoods);
var conn: boolean;
begin
if Assigned(DataSet) then begin
  conn := DataSet.Active;
  DataSetClose(Self);
  with DataSet do begin
    Params.ParamValues['PLIMIT'] := 200;
    Params.ParamValues['PGOODS'] := Sender.Id;
    Params.ParamValues['PARTICLE'] := Sender.Article;
    Params.ParamValues['PNAME'] := Sender.Name;
    Params.ParamValues['PDATE'] := round(int(Now()));
    Params.ParamValues['PPLACE'] := Sender.PlaceId;
    Params.ParamValues['PWAREHOUSE'] := Sender.WarehouseId;
    Params.ParamValues['PSHIPMENT'] := Sender.ShipmentId;
  end;
  if conn then DataSetOpen(Self);
end;
end;

end.
