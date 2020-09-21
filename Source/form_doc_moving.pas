unit form_doc_moving;

interface

uses Winapi.Windows, Winapi.Messages, Classes, System.UITypes, SysUtils, Vcl.Controls, Vcl.StdCtrls, Grids.Helper, Form.Helper,
  form_doc_consumption, form_dm, appconfig;

type
  Tfrm_doc_moving = class(Tfrm_doc_consumption)
    fld_newwarehouse: TComboBox;
    fld_newplace: TComboBox;
    procedure act_dict_query_newplaceExecute(Sender: TObject);
    procedure dict_warehouseOnChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction); override;
    procedure act_doc_createExecute(Sender: TObject); override;
    procedure SetConfig(AConfig: TAppConfig); override;
  protected
    function help_info: string; override;
    function DoExecuteDoc(DocGoods: Cardinal; DocGoodsCount: integer; DocShipment, DocWarehouse, DocPlace: Cardinal): integer; override;
    function GetDocType: Cardinal; override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure DoInit; override;
  end;

implementation

constructor Tfrm_doc_moving.Create(AOwner: TComponent);
var obj: TWinControl;
begin
inherited Create(AOwner);
Caption := 'ѕеремещение товара';
DocName := 'ѕеремещение товара є';
obj := TFormHelper.CreatePanel(pnl_main, alBottom, Width,30);
with TFormHelper.CreateLabel(obj, alLeft, lbl_place.Width,30, 'Ќовый склад/место хранени€') do begin
  WordWrap := true;
  Font.Size := 8;
end;
TFormHelper.CreateButton(obj, alRight, obj.Height, obj.Height, '*').OnClick := act_dict_query_newplaceExecute;
fld_newwarehouse := TFormHelper.CreateComboBox(obj, alLeft, csOwnerDrawFixed, fld_warehouse.ItemHeight);
fld_newwarehouse.Width := fld_warehouse.Width;
fld_newwarehouse.AlignWithMargins := fld_warehouse.AlignWithMargins;
fld_newwarehouse.Margins.Assign(fld_warehouse.Margins);
fld_newwarehouse.OnChange := dict_warehouseOnChange;
TFormHelper.CreateSplitter(obj, fld_newwarehouse.Width+10);
fld_newplace := TFormHelper.CreateComboBox(obj, alClient, csOwnerDrawFixed, fld_place.ItemHeight);
fld_newplace.AlignWithMargins := fld_place.AlignWithMargins;
fld_newplace.Margins.Assign(fld_place.Margins);
end;

procedure Tfrm_doc_moving.FormClose(Sender: TObject; var Action: TCloseAction);
begin
inherited;
if Assigned(Config) then begin
  Config.Write(ClassName, 'w2', fld_newwarehouse.Width);
  Config.Close;
end;
end;

procedure Tfrm_doc_moving.SetConfig(AConfig: TAppConfig);
begin
inherited SetConfig(AConfig);
if Assigned(Config) then begin
  fld_newwarehouse.Width := Config.Read(ClassName, 'w2', fld_newwarehouse.Width);
  Config.Close;
end;
end;

procedure Tfrm_doc_moving.DoInit;
begin
inherited DoInit;
act_dict_query_newplaceExecute(Self);
fld_newwarehouse.ItemIndex := -1;
fld_newplace.ItemIndex := -1;
end;

procedure Tfrm_doc_moving.dict_warehouseOnChange(Sender: TObject);
begin
dictQuery(fld_newplace, 'Place', Format('WarehouseId = %d', [get_key_dict(fld_newwarehouse)]));
end;

procedure Tfrm_doc_moving.act_dict_query_newplaceExecute(Sender: TObject);
begin
dictQuery(fld_newwarehouse, 'Warehouse', '');
dictQuery(fld_newplace, 'Place', Format('WarehouseId = %d', [get_key_dict(fld_newwarehouse)]));
end;

function Tfrm_doc_moving.help_info: string;
begin
Result := 'формируетс€ два одинаковых документа'#13#10+
  'с отрицательным количеством дл€ текужего склада'#13#10+
  'с положительным количеством дл€ нового склада'#13#10+
  #13#10+
  inherited edithelp_info;
end;

procedure Tfrm_doc_moving.act_doc_createExecute(Sender: TObject);
begin
if (get_key_dict(fld_newwarehouse)>0) and (get_key_dict(fld_newplace)>0) then begin
  inherited act_doc_createExecute(Sender);
end
else begin
  MessageBox('Ќеобходимо выбрать место назначени€', MB_ICONINFORMATION + MB_OK);
end;
end;

function Tfrm_doc_moving.GetDocType: Cardinal;
begin
Result := 2;
end;

function Tfrm_doc_moving.DoExecuteDoc(DocGoods: Cardinal; DocGoodsCount: integer; DocShipment, DocWarehouse, DocPlace: Cardinal): integer;
var DocId: Cardinal;
  newDocWarehouse, newDocPlace: Cardinal;
begin
Result := 0;
DocGoodsCount := abs(DocGoodsCount);
if DocGoodsCount>0 then begin
  newDocPlace := FDM.find_value2('Place', get_key_dict(fld_newplace).ToString, fld_newplace.Text);
  newDocWarehouse := FDM.find_value2('Warehouse', get_key_dict(fld_newwarehouse).ToString, fld_newwarehouse.Text);
  if (newDocPlace>0) or (newDocPlace>0) then begin
    DocId := FDM.insert_doc(DocType, DocName, DocDate, DocShipment, DocWarehouse, DocPlace);
    if DocId>0 then begin
      Result := 1;
      if FDM.insert_doclink(DocId, DocGoods, -DocGoodsCount)>0 then begin
        Inc(Result);
      end;
    end;
    DocId := FDM.insert_doc(DocType, DocName, DocDate, DocShipment, newDocWarehouse, newDocPlace);
    if DocId>0 then begin
      Result := 1;
      if FDM.insert_doclink(DocId, DocGoods, DocGoodsCount)>0 then begin
        Inc(Result);
      end;
    end;
  end;
end;
end;

end.
