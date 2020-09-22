unit form_doc_arrival;

interface

uses Windows, Classes, Vcl.Controls, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Buttons, SysUtils, Grids.Helper,
  form_doccreate, form_dm, strtools, docparam;

type
  Tfrm_doc_arrival = class(Tfrm_doccreate)
    procedure act_doc_createExecute(Sender: TObject); override;
  protected
    FDM: TFDM;
    function help_info: string; override;
    function DoQueryDoc(Values: TStrings): Cardinal; override;
    function GetDocType: Cardinal; override;
    procedure DoExecute(ProgressEvent: TNotifyProgress; CompliteEvent: TNotifyEvent); override;
  public
    constructor Create(AOwner: TComponent); override;
    property DM: TFDM read FDM write FDM;
  end;

implementation

constructor Tfrm_doc_arrival.Create(AOwner: TComponent);
begin
inherited Create(AOwner);
fld_grid.Fields.DisableControls;
fld_grid.Fields.Delete('shipment');
fld_grid.Fields.Delete('warehouse');
fld_grid.Fields.Delete('place');
fld_grid.Fields.Reindex;
fld_grid.Fields.EnableControls;
Caption := 'Приход товара';
DocName := 'Приход товара №';
end;

function Tfrm_doc_arrival.help_info: string;
begin
Result := inherited edithelp_info;
end;

function Tfrm_doc_arrival.DoQueryDoc(Values: TStrings): Cardinal;
begin
Result := 0;
if Assigned(FOnQueryDoc) then Result := FOnQueryDoc(Self, 0, Values);
end;

function Tfrm_doc_arrival.GetDocType: Cardinal;
begin
Result := 1;
end;

procedure Tfrm_doc_arrival.act_doc_createExecute(Sender: TObject);
begin
if (get_key_dict(fld_warehouse)>0) and (Trim(fld_shipment.Text)<>'') then begin
  inherited act_doc_createExecute(Sender);
end
else begin
  MessageBox('Необходимо указать склад и партию товара', MB_ICONINFORMATION + MB_OK);
end;
end;

procedure Tfrm_doc_arrival.DoExecute(ProgressEvent: TNotifyProgress; CompliteEvent: TNotifyEvent);
var conn: boolean;
  Goods: TGoods;
  Index: integer;
  DocId: Cardinal;
  lvalues: TStrings;
begin
if (not FDM.Connected) and (DocCount<1) then exit;
Goods := TGoods.Create;
lvalues := TStringList.Create;
try
  with FDM do begin
    GetData(-1, Goods);
    with Goods.Header do DocId := FDM.insert_doc(DocType, DocName, DocDate, Shipment.Id, Warehouse.Id, Place.Id);
    conn := FDTable_Goods.Active;
    if not conn then FDTable_Goods.Open;
    ProgressEvent(0);
    for Index := 0 to DocCount-1 do begin
      ProgressEvent(Index/DocCount);
      GetData(Index, Goods);
      if Goods.Count>0 then begin
        lvalues.Clear;
        Goods.AssignTo(lvalues);
        FDM.insert_doclink(DocId, FDM.insert_goods(Goods.Article, lvalues), Goods.Count);
      end;
    end;
    ProgressEvent(1);
    if not conn then FDTable_Goods.Close;
  end;
finally
  lvalues.Free;
  Goods.Free;
end;
CompliteEvent(Self);
end;

end.
