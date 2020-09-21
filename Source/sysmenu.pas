unit sysmenu;

interface

uses Winapi.Windows, Winapi.Messages, Classes, Graphics, Vcl.Controls, Vcl.ImgList, Vcl.Menus;

type
  THelperBitmap = class Helper for TBitmap
  public
    procedure LoadIconFromResource(Instance: THandle; ResName: string);
    function MaskedColor: TColor;
  end;

  THelperImageList = class Helper for TImageList
  public
    function LoadFromResource(Instance: THandle; ResName: string): integer;
  end;

  TSystemMenu = class(TPopupMenu)
  private
    FSysHandle: HMENU;
    procedure AttachItem(Item: TMenuItem);
    procedure SetMenuImage(Item: TMenuItem); overload;
    procedure SetMenuImage(hMenu: HMENU; idMenu: Cardinal; hBitmap: HBITMAP); overload;
  public
    function Add(Caption: string; ImageIndex: integer; OnEvent: TNotifyEvent): TMenuItem;
    procedure Attach(hSysMenu: HMENU);
    function OnCommand(var Msg: TWMSysCommand): boolean;
  end;

implementation

//THelperBitmap

function THelperBitmap.MaskedColor: TColor;
begin
Result := Canvas.Pixels[0,0];
end;

procedure THelperBitmap.LoadIconFromResource(Instance: THandle; ResName: string);
var buff: TBitmap;
  buffrect: TRect;
begin
buff := TBitmap.Create;
try
  buff.LoadFromResourceName(Instance, ResName);
  buffrect := buff.Canvas.ClipRect;
  if buffrect.Height > buffrect.Width then buffrect.Height := buffrect.Width
  else buffrect.Width := buffrect.Height;
  Canvas.Brush.Color := buff.MaskedColor;
  Canvas.FillRect(Canvas.ClipRect);
  Canvas.CopyRect(Canvas.ClipRect, buff.Canvas, buffrect);
finally
  buff.Free;
end;
end;

//THelperImageList

function THelperImageList.LoadFromResource(Instance: THandle; ResName: string): integer;
var icon: TBitmap;
begin
icon := TBitmap.Create;
try
  icon.SetSize(Width, Height);
  icon.LoadIconFromResource(Instance, ResName);
  Result := AddMasked(icon, icon.MaskedColor);
finally
  icon.Free;
end;
end;

//TSystemMenu

function TSystemMenu.Add(Caption: string; ImageIndex: integer; OnEvent: TNotifyEvent): TMenuItem;
begin
Result := TMenuItem.Create(Self);
Result.ImageIndex := ImageIndex;
Result.Caption := Caption;
Result.OnClick := OnEvent;
InsertComponent(Result);
Items.Add(Result);
end;

procedure TSystemMenu.Attach(hSysMenu: HMENU);
var Index: integer;
  Item: TMenuItem;
begin
FSysHandle := hSysMenu;
AttachItem(nil);
for Index := 0 to Items.Count-1 do begin
  Item := Items[Index];
  if Item.Tag=0 then Item.Tag := Index+1;
  AttachItem(Item);
end;
end;

procedure TSystemMenu.SetMenuImage(Item: TMenuItem);
begin
if not Assigned(Images) then Exit;
Item.Bitmap.PixelFormat := pf24bit;
Item.Bitmap.SetSize(Images.Width, Images.Height);
Item.Bitmap.Canvas.Brush.Color := clMenu;
Item.Bitmap.Canvas.FillRect(Item.Bitmap.Canvas.ClipRect);
Images.Draw(Item.Bitmap.Canvas, 0, 0, Item.ImageIndex, Vcl.ImgList.dsTransparent, Vcl.ImgList.itImage, true);
end;

procedure TSystemMenu.SetMenuImage(hMenu: HMENU; idMenu: Cardinal; hBitmap: HBITMAP);
var mInfo: MENUITEMINFO;
begin
mInfo.cbSize := sizeof(MENUITEMINFO);
mInfo.fMask := MIIM_BITMAP;
mInfo.hbmpItem := hBitmap;
SetMenuItemInfo(hMenu, idMenu, false, &mInfo);
end;

procedure TSystemMenu.AttachItem(Item: TMenuItem);
var j: integer;
begin
if (FSysHandle = 0) then Exit;
if not Assigned(Item) then begin
  Winapi.Windows.AppendMenu(FSysHandle, MF_SEPARATOR, 0, '');
end
else
if Item.Enabled then
if Item.IsLine then begin
  Winapi.Windows.AppendMenu(FSysHandle, MF_SEPARATOR, 0, '');
  end
  else begin
  if Item.Count=0 then begin
    Winapi.Windows.AppendMenu(FSysHandle, MF_STRING, WM_USER + Item.Tag, PWideChar(Item.Caption));
    if Assigned(Images)and(Item.ImageIndex>=0) then begin
      SetMenuImage(Item);
      SetMenuImage(FSysHandle, WM_USER + Item.Tag, Item.Bitmap.Handle);
    end;
  end
  else begin
    Winapi.Windows.AppendMenu(FSysHandle, MF_SEPARATOR, 0, '');
    for j := 0 to Item.Count-1 do
    AttachItem(Item[j]);
  end;
end;
end;

function TSystemMenu.OnCommand(var Msg: TWMSysCommand): boolean;
var N,j: integer;
  obj: TComponent;
begin
Result := false;
N := Msg.CmdType - WM_USER;
for j := 0 to ComponentCount-1 do begin
  obj := Components[j];
  if obj is TMenuItem then
  if TMenuItem(obj).Tag=N then begin
    if Assigned(TMenuItem(obj)) then begin
      TMenuItem(obj).OnClick(Self);
    end;
    Result := true;
    exit;
  end;
end;
end;

end.
