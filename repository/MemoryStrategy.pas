unit MemoryStrategy;

interface

uses
  Strategies,
  BO,
  Generics.collections,
  func;

type
  TRepositoryMemoryStrategyPersona = class(TRepositoryPersonaStrategy)
  protected
    function GetIndexByID(id: Integer): Integer;
  public
    function Get(id: Integer): TPersona; override;
    function Save(AObject: TPersona): TPersona; override;
    function GetAll: TObjectList<TPersona>; override;
    function FindUltraQuarantenni: TObjectList<TPersona>; override;
    function FindWhereEtaGreaterThan(const Eta: Integer): TObjectList<TPersona>; override;
    procedure Remove(AObject: TPersona); override;
    constructor Create; virtual;
    destructor Destroy; override;
  private
    MemoryData: TArray<TPersona>;
  end;

implementation

{ TRepositoryMemoryStrategyPersona }

function TRepositoryMemoryStrategyPersona.FindUltraQuarantenni: TObjectList<TPersona>;
var
  List: TObjectList<TPersona>;
begin
  List := TObjectList<TPersona>.Create(false);
  Functional.Map<TPersona>(MemoryData,
    procedure(var Item: TPersona)
    begin
      if Item.Eta > 40 then
        List.Add(Item);
    end);
  Result := List;
end;

function TRepositoryMemoryStrategyPersona.FindWhereEtaGreaterThan(const Eta: Integer)
  : TObjectList<TPersona>;
var
  List: TObjectList<TPersona>;
begin
  List := TObjectList<TPersona>.Create(false);
  Functional.Map<TPersona>(MemoryData,
    procedure(var Item: TPersona)
    begin
      if Item.Eta > Eta then
        List.Add(Item);
    end);
  Result := List;
end;

constructor TRepositoryMemoryStrategyPersona.Create;
begin
  inherited;
  SetLength(MemoryData, 5);
  MemoryData[0] := TPersona.CreateNew(1, 'Daniele Teti', 30);
  MemoryData[1] := TPersona.CreateNew(2, 'Scott Summer', 35);
  MemoryData[2] := TPersona.CreateNew(3, 'Bruce Banner', 45);
  MemoryData[3] := TPersona.CreateNew(4, 'Peter Parker', 30);
  MemoryData[4] := TPersona.CreateNew(5, 'Clark Kent', 60);
end;

destructor TRepositoryMemoryStrategyPersona.Destroy;
var
  persona: TPersona;
  I: Integer;
begin
  Functional.Map<TPersona>(MemoryData,
    procedure(var Item: TPersona)
    begin
      persona.Free;
    end);
  SetLength(MemoryData, 0);
  inherited;
end;

function TRepositoryMemoryStrategyPersona.Get(id: Integer): TPersona;
var
  List: TArray<TPersona>;
  P: TPersona;
begin
  if not Functional.FindFirst<TPersona>(MemoryData, Result,
    function(Item: TPersona): boolean
    begin
      Result := id = Item.id;
    end) then
    Result := nil;
end;

function TRepositoryMemoryStrategyPersona.GetAll: TObjectList<TPersona>;
var
  all: TObjectList<TPersona>;
begin
  all := TObjectList<TPersona>.Create(false);
  Functional.Map<TPersona>(MemoryData,
    procedure(var Item: TPersona)
    begin
      all.Add(Item);
    end);
  Result := all;
end;

function TRepositoryMemoryStrategyPersona.GetIndexByID(id: Integer): Integer;
var
  P: TPersona;
  index: Integer;
begin
  index := - 1;
  Functional.FindFirst<TPersona>(MemoryData, P,
    function(Item: TPersona): boolean
    begin
      Result := id = Item.id;
      inc(index);
    end);
  Result := index;
end;

procedure TRepositoryMemoryStrategyPersona.Remove(AObject: TPersona);
var
  idx: Integer;
  MemoryDataCopy: TArray<TPersona>;
  I: Integer;
begin
  idx := GetIndexByID(AObject.id);
  SetLength(MemoryDataCopy, Length(MemoryData) - 1);
  for I := 0 to Length(MemoryData) - 1 do
  begin
    if I < idx then
      MemoryDataCopy[I] := MemoryData[I]
    else if I = idx then
      MemoryData[I].Free
    else if I > idx then
      MemoryDataCopy[I - 1] := MemoryData[I];
  end;
  MemoryData := MemoryDataCopy;
end;

function TRepositoryMemoryStrategyPersona.Save(AObject: TPersona): TPersona;
var
  obj: TPersona;
begin
  if AObject.id = 0 then
  begin
    SetLength(MemoryData, Length(MemoryData) + 1);
    obj := TPersona.Create;
    obj.id := Length(MemoryData);
    MemoryData[Length(MemoryData) - 1] := obj;
    obj.Nome := AObject.Nome;
    obj.Eta := AObject.Eta;
    Result := obj;
  end
  else
    Result := AObject;
end;

end.
