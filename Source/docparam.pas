unit docparam;

interface

uses Classes, SysUtils;

type
  TStringIndex = class
  private
    FId: Cardinal;
    FName: string;
  public
    property Id: Cardinal read FId write FId;
    property Name: string read FName write FName;
    procedure Clear;
  end;

  TDictionary = class(TStringIndex)
  private
    FShipment: TStringIndex;
    FPlace: TStringIndex;
    FWarehouse: TStringIndex;
  public
    constructor Create; reintroduce;
    destructor Destroy; override;
    procedure Clear;
    property Shipment: TStringIndex read FShipment;
    property Place: TStringIndex read FPlace;
    property Warehouse: TStringIndex read FWarehouse;
  end;

  TGoods = class(TStringIndex)
  private
    FHeader: TDictionary;
    FDictionary: TDictionary;
  protected
    FArticle: string;
    FCount: integer;
    FSize: double;
    FCost: double;
  private
    function GetShipmentId: Cardinal;
    function GetPlaceId: Cardinal;
    function GetWarehouseId: Cardinal;
  public
    constructor Create; reintroduce;
    destructor Destroy; override;
    procedure Clear;
    procedure AssignTo(Destination: TStrings);
    property Header: TDictionary read FHeader;
    property Dictionary: TDictionary read FDictionary;
    property Article: string read FArticle write FArticle;
    property Count: integer read FCount write FCount;
    property Size: double read FSize write FSize;
    property Cost: double read FCost write FCost;
  public
    property ShipmentId: Cardinal read GetShipmentId;
    property PlaceId: Cardinal read GetPlaceId;
    property WarehouseId: Cardinal read GetWarehouseId;
  end;

implementation

//TStringIndex

procedure TStringIndex.Clear;
begin
FId := 0;
FName := '';
end;

//TDictionary

constructor TDictionary.Create;
begin
inherited Create;
FShipment := TStringIndex.Create;
FPlace := TStringIndex.Create;
FWarehouse := TStringIndex.Create;
end;

destructor TDictionary.Destroy;
begin
FShipment.Free;
FPlace.Free;
FWarehouse.Free;
inherited Destroy;
end;

procedure TDictionary.Clear;
begin
inherited Clear;
FShipment.Clear;
FPlace.Clear;
FWarehouse.Clear;
end;

//TGoods

constructor TGoods.Create;
begin
inherited Create;
FHeader := TDictionary.Create;
FDictionary := TDictionary.Create;
end;

destructor TGoods.Destroy;
begin
FHeader.Free;
FDictionary.Free;
inherited Destroy;
end;

procedure TGoods.Clear;
begin
inherited Clear;
FDictionary.Clear;
FArticle := '';
FCount := 0;
FSize := 0;
FCost := 0;
end;

function TGoods.GetShipmentId: Cardinal;
begin
if FDictionary.Shipment.Id>0 then Result := FDictionary.Shipment.Id
else Result := FHeader.Shipment.Id;
end;

function TGoods.GetPlaceId: Cardinal;
begin
if FDictionary.Place.Id>0 then Result := FDictionary.Place.Id
else Result := FHeader.Place.Id;
end;

function TGoods.GetWarehouseId: Cardinal;
begin
if FDictionary.Warehouse.Id>0 then Result := FDictionary.Warehouse.Id
else Result := FHeader.Warehouse.Id;
end;

function float2str(const value: double): string;
var j: integer;
begin
Result := FloatToStr(value);
j := pos(',', Result);
if j>0 then Result[j] := '.';
end;

procedure TGoods.AssignTo(Destination: TStrings);
begin
Destination.Values['ShipmentId'] := ShipmentId.ToString;
Destination.Values['PlaceId'] := PlaceId.ToString;
Destination.Values['WarehouseId'] := WarehouseId.ToString;
Destination.Values['GoodsId'] := FId.ToString;
Destination.Values['GoodsName'] := FName;
Destination.Values['GoodsArticle'] := FArticle;
Destination.Values['GoodsCost'] := float2str(FCost);
Destination.Values['GoodsSize'] := float2str(FSize);
end;

end.
