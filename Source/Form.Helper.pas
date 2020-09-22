unit Form.Helper;

interface

uses Classes, Controls, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Buttons;

type
  TFormHelper = class
  public
    class function CreateDict(AParent: TWinControl; AAlign: TAlign; AStyle: TComboBoxStyle; AWidth, AHeight: integer; ACaption: string;
      OnExecute: TNotifyEvent): TComboBox;
    class function CreatePanel(AParent: TWinControl; AAlign: TAlign; AWidth, AHeight: integer): TPanel;
    class function CreateLabel(AParent: TWinControl; AAlign: TAlign; AWidth, AHeight: integer; ACaption: string): TLabel;
    class function CreateComboBox(AParent: TWinControl; AAlign: TAlign; AStyle: TComboBoxStyle; AItemHeight: integer): TComboBox;
    class function CreateButton(AParent: TWinControl; AAlign: TAlign; AWidth, AHeight: integer; ACaption: string): TSpeedButton;
    class function CreateSplitter(AParent: TWinControl; ALeft: integer): TSplitter;
  end;

implementation

class function TFormHelper.CreateDict(AParent: TWinControl; AAlign: TAlign; AStyle: TComboBoxStyle; AWidth, AHeight: integer;
  ACaption: string; OnExecute: TNotifyEvent): TComboBox;
var
  obj: TWinControl;
begin
  obj := CreatePanel(AParent, AAlign, AWidth, AHeight);
  CreateLabel(obj, alLeft, 105, obj.Height, ACaption);
  CreateButton(obj, alRight, obj.Height, obj.Height, '*').OnClick := OnExecute;
  Result := CreateComboBox(obj, alClient, AStyle, AHeight - 6);
end;

class function TFormHelper.CreatePanel(AParent: TWinControl; AAlign: TAlign; AWidth, AHeight: integer): TPanel;
begin
  Result := TPanel.Create(AParent.Owner);
  Result.Caption := '';
  Result.ShowCaption := false;
  Result.BevelOuter := bvNone;
  Result.AlignWithMargins := true;
  Result.Align := AAlign;
  Result.Height := AHeight;
  Result.Width := AWidth;
  Result.Margins.Bottom := 0;
  Result.Parent := AParent;
end;

class function TFormHelper.CreateLabel(AParent: TWinControl; AAlign: TAlign; AWidth, AHeight: integer; ACaption: string): TLabel;
begin
  Result := TLabel.Create(AParent.Owner);
  Result.Caption := ACaption;
  Result.Layout := tlCenter;
  Result.AutoSize := false;
  Result.Align := AAlign;
  Result.Height := AHeight;
  Result.Width := AWidth;
  Result.Parent := AParent;
end;

class function TFormHelper.CreateComboBox(AParent: TWinControl; AAlign: TAlign; AStyle: TComboBoxStyle; AItemHeight: integer): TComboBox;
begin
  Result := TComboBox.Create(AParent.Owner);
  Result.Text := '';
  Result.Align := AAlign;
  Result.ItemHeight := AItemHeight;
  Result.Style := AStyle;
  Result.Parent := AParent;
end;

class function TFormHelper.CreateButton(AParent: TWinControl; AAlign: TAlign; AWidth, AHeight: integer; ACaption: string): TSpeedButton;
begin
  Result := TSpeedButton.Create(AParent.Owner);
  Result.Caption := ACaption;
  Result.Align := AAlign;
  Result.Height := AHeight;
  Result.Width := AWidth;
  Result.Flat := true;
  Result.Parent := AParent;
end;

class function TFormHelper.CreateSplitter(AParent: TWinControl; ALeft: integer): TSplitter;
begin
  Result := TSplitter.Create(AParent.Owner);
  Result.Left := ALeft;
  Result.Parent := AParent;
end;

end.
