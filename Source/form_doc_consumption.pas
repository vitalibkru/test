unit form_doc_consumption;

interface

uses Classes, Windows, SysUtils, Vcl.StdCtrls, Grids.Helper, form_doccreate, form_dm, strtools
  , form_findleftovers, appconfig, docparam;

type
  Tfrm_doc_consumption = class(Tfrm_doccreate)
  protected
    FDM: TFDM;
    function help_info: string; override;
    function DoQueryDoc(Values: TStrings): Cardinal; override;
    procedure GetData(Index: integer; Goods: TGoods); override;
    procedure DoExecute(ProgressEvent: TNotifyProgress; CompliteEvent: TNotifyEvent); override;
    function DoExecuteDoc(DocGoods: Cardinal; DocGoodsCount: integer; DocShipment, DocWarehouse, DocPlace: Cardinal): integer; virtual;
    function GetDocType: Cardinal; override;
    procedure act_ds_consumptionExecute(Sender: TObject);
  public
    constructor Create(AOwner: TComponent); override;
    property DM: TFDM read FDM write FDM;
  end;

implementation

constructor Tfrm_doc_consumption.Create(AOwner: TComponent);
begin
inherited Create(AOwner);
Caption := 'Расход товара';
DocName := 'Расход товара №';
fld_shipment.Style := csOwnerDrawFixed;
AppendAction('Поиск остатков', -1, act_ds_consumptionExecute, 'Ctrl+N');
btn_doc_create.Hint := act_doc_create.Hint+#13#10'Ctrl+N показать таблицу поиска';
end;

function Tfrm_doc_consumption.help_info: string;
begin
Result := 'параметры (склад/место хранения/партия) применяются'#13#10+
  'к строкам таблицы если в таблице параметр не задан'#13#10+
  #13#10+
  'остатки сортируются по дате'#13#10+
  'если партия задана, то товар выбирается из этой поставки'#13#10+
  #13#10+
  inherited edithelp_info;
end;

function Tfrm_doc_consumption.DoQueryDoc(Values: TStrings): Cardinal;
var ro: word;
begin
ro := $00;
if get_key_dict(fld_shipment)>0 then ro := ro or $01;
if get_key_dict(fld_warehouse)>0 then ro := ro or $02;
if get_key_dict(fld_place)>0 then ro := ro or $04;
Values.Values['ReadOnly'] := ro.ToString;
Result := inherited DoQueryDoc(Values);
end;

function Tfrm_doc_consumption.GetDocType: Cardinal;
begin
Result := 3;
end;

function Tfrm_doc_consumption.DoExecuteDoc(DocGoods: Cardinal; DocGoodsCount: integer; DocShipment, DocWarehouse, DocPlace: Cardinal): integer;
var DocId: Cardinal;
begin
Result := 0;
DocGoodsCount := abs(DocGoodsCount);
if DocGoodsCount>0 then begin
  DocId := FDM.insert_doc(DocType, DocName, DocDate, DocShipment, DocWarehouse, DocPlace);
  if DocId>0 then begin
    Result := 1;
    if FDM.insert_doclink(DocId, DocGoods, -DocGoodsCount)>0 then begin
      Inc(Result);
    end;
  end;
end;
end;

procedure Tfrm_doc_consumption.GetData(Index: integer; Goods: TGoods);
begin
inherited GetData(Index, Goods);
if Index<0 then begin
  with Goods.Header.Warehouse do Id := FDM.find_value2('Warehouse', Id.ToString, Name);
  with Goods.Header.Place do Id := FDM.find_value2('Place', Id.ToString, Name);
  with Goods.Header.Shipment do Id := FDM.find_value2('Shipment', Id.ToString, Name);
end
else begin
  with Goods.Dictionary.Warehouse do Id := FDM.find_value2('Warehouse', '', Name);
  with Goods.Dictionary.Place do Id := FDM.find_value2('Place', '', Name);
  with Goods.Dictionary.Shipment do Id := FDM.find_value2('Shipment', '', Name);
end;
end;

procedure Tfrm_doc_consumption.DoExecute(ProgressEvent: TNotifyProgress; CompliteEvent: TNotifyEvent);
var conn: boolean;
  Goods: TGoods;
  Index,FindCount: integer;
begin
if (not FDM.Connected) or (DocCount<1) then exit;
Goods := TGoods.Create;
try
  with FDM do begin
    GetData(-1, Goods);
    conn := FDTable_Goods.Active;
    if not conn then FDTable_Goods.Open;
    ProgressEvent(0);
    for Index := 0 to DocCount-1 do begin
      ProgressEvent(Index/DocCount);
      GetData(Index, Goods);
      if Goods.Count>0 then begin
        FindCount := FDM.find_leftovers(DocDate, Goods);
        while (Goods.Id>0) and (Goods.Count>0) do begin
          if FindCount>Goods.Count then FindCount := Goods.Count;
          FindCount := DoExecuteDoc(Goods.Id, FindCount, Goods.ShipmentId, Goods.WarehouseId, Goods.PlaceId);
          Goods.Count := Goods.Count-FindCount;
          if Goods.Count>0 then begin
            FindCount := FDM.find_leftovers(DocDate, Goods);
          end;
        end;
      end;
      if Goods.Count>0 then begin
          MessageBox(Format('Невозможно расходовать %d единиц'#13#10'наименование "%s"'#13#10'артикул "%s"', [Goods.Count, Goods.Name, Goods.Article]), MB_ICONINFORMATION + MB_OK);
      end;
    end;
    ProgressEvent(1);
    if not conn then FDTable_Goods.Close;
  end;
finally
  Goods.Free;
end;
CompliteEvent(Self);
end;

procedure Tfrm_doc_consumption.act_ds_consumptionExecute(Sender: TObject);
var Goods: TGoods;
begin
with FDM.FDQuery_findleftovers do begin
  if Active then Close;
  Goods := TGoods.Create;
  try
    GetData(-1, Goods);
    GetData(fld_grid.Row-1, Goods);
    with TDbForm_findleftovers(OpenChildForm(TDbForm_findleftovers)) do begin
      Config := Self.Config;
      DataSet := FDM.FDQuery_findleftovers;
      SetParams(Goods);
    end;
  finally
    Goods.Free;
  end;
end;
end;

end.
