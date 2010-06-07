unit MemoryStrategy;

interface

uses
  Strategies,
  BO,
  Generics.collections, func;

type
  TRepositoryMemoryStrategyPersona = class(TRepositoryPersonaStrategy)
  public
    function Get(id: integer): TPersona; override;
    function Save(AObject: TPersona): TPersona; override;
    function GetAll: TObjectList<TPersona>; override;
    function Remove(AObject: TPersona): TPersona; override;
    class constructor Create;
    class destructor Destroy;
  private
    class var MemoryData: TArray<TPersona>;
  end;

implementation

{ TRepositoryMemoryStrategyPersona }

class constructor TRepositoryMemoryStrategyPersona.Create;
begin
  SetLength(MemoryData, 5);
  MemoryData[0] := TPersona.CreateNew(1, 'Daniele Teti', 30);
  MemoryData[1] := TPersona.CreateNew(2, 'Scott Summer', 35);
  MemoryData[2] := TPersona.CreateNew(3, 'Bruce Banner', 45);
  MemoryData[3] := TPersona.CreateNew(4, 'Peter Parker', 30);
  MemoryData[4] := TPersona.CreateNew(5, 'Clark Kent', 60);
end;

class destructor TRepositoryMemoryStrategyPersona.Destroy;
var
  persona: TPersona;
begin
  Functional.Map<TPersona>(MemoryData,
    function (item: TPersona): TPersona
    begin
      persona.Free;
    end);
  SetLength(MemoryData, 0);
end;

function TRepositoryMemoryStrategyPersona.Get(id: integer): TPersona;
var
  list: TArray<TPersona>;
begin
  list := Functional.Filter<TPersona>(MemoryData,
  function (item: TPersona): boolean
  begin
    Result := id = item.ID;
  end);
  if Length(list) = 1 then
    Result := list[0];
end;

function TRepositoryMemoryStrategyPersona.GetAll: TObjectList<TPersona>;
var
  all: TObjectList<TPersona>;
begin
  all := TObjectList<TPersona>.Create(false);
  Functional.Map<TPersona>(MemoryData,
  function (item: TPersona): TPersona
  begin
    all.Add(item);
  end);
  Result := all;
end;

function TRepositoryMemoryStrategyPersona.Remove(AObject: TPersona): TPersona;
begin
  //
end;

function TRepositoryMemoryStrategyPersona.Save(AObject: TPersona): TPersona;
var
  obj: TPersona;
begin
  if AObject.ID = 0 then
  begin
    SetLength(MemoryData, Length(MemoryData) + 1);
    obj := TPersona.Create;
    obj.ID := Length(MemoryData);
    MemoryData[Length(MemoryData)-1] := obj;
    obj.Nome := AObject.Nome;
    obj.Eta := AObject.Eta;
    Result := obj;
  end
  else
    Result := AObject;
end;

end.
