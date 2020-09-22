unit docparam;

interface

uses Classes, SysUtils;

const
  cname_goods_id = 'GoodsId';
  cname_goods_name = 'GoodsName';
  cname_goods_article = 'GoodsArticle';
  cname_goods_count = 'GoodsCount';
  cname_goods_cost = 'GoodsCost';
  cname_goods_size = 'GoodsSize';
  cname_shipment_id = 'ShipmentId';
  cname_shipment_name = 'ShipmentName';
  cname_place_id = 'PlaceId';
  cname_place_name = 'PlaceName';
  cname_warehouse_id = 'WarehouseId';
  cname_warehouse_name = 'WarehouseName';

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
    function GetShipmentName: string;
    function GetPlaceName: string;
    function GetWarehouseName: string;
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
    property ShipmentName: string read GetShipmentName;
    property PlaceName: string read GetPlaceName;
    property WarehouseName: string read GetWarehouseName;
  end;

implementation

// TStringIndex

procedure TStringIndex.Clear;
begin
  FId := 0;
  FName := '';
end;

// TDictionary

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

// TGoods

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
  if FDictionary.Shipment.Id > 0 then
    Result := FDictionary.Shipment.Id
  else
    Result := FHeader.Shipment.Id;
end;

function TGoods.GetPlaceId: Cardinal;
begin
  if FDictionary.Place.Id > 0 then
    Result := FDictionary.Place.Id
  else
    Result := FHeader.Place.Id;
end;

function TGoods.GetWarehouseId: Cardinal;
begin
  if FDictionary.Warehouse.Id > 0 then
    Result := FDictionary.Warehouse.Id
  else
    Result := FHeader.Warehouse.Id;
end;

function TGoods.GetShipmentName: string;
begin
  if FDictionary.Shipment.Id > 0 then
    Result := FDictionary.Shipment.Name
  else
    Result := FHeader.Shipment.Name;
end;

function TGoods.GetPlaceName: string;
begin
  if FDictionary.Place.Id > 0 then
    Result := FDictionary.Place.Name
  else
    Result := FHeader.Place.Name;
end;

function TGoods.GetWarehouseName: string;
begin
  if FDictionary.Warehouse.Id > 0 then
    Result := FDictionary.Warehouse.Name
  else
    Result := FHeader.Warehouse.Name;
end;

function float2str(const value: double): string;
var
  j: integer;
begin
  Result := FloatToStr(value);
  j := pos(',', Result);
  if j > 0 then
    Result[j] := '.';
end;

procedure TGoods.AssignTo(Destination: TStrings);
begin
  Destination.Values[cname_shipment_id] := ShipmentId.ToString;
  Destination.Values[cname_shipment_name] := ShipmentName;
  Destination.Values[cname_place_id] := PlaceId.ToString;
  Destination.Values[cname_place_name] := PlaceName;
  Destination.Values[cname_warehouse_id] := WarehouseId.ToString;
  Destination.Values[cname_warehouse_name] := WarehouseName;
  Destination.Values[cname_goods_id] := FId.ToString;
  Destination.Values[cname_goods_name] := FName;
  Destination.Values[cname_goods_article] := FArticle;
  Destination.Values[cname_goods_count] := FCount.ToString;
  Destination.Values[cname_goods_cost] := float2str(FCost);
  Destination.Values[cname_goods_size] := float2str(FSize);
end;

end.
