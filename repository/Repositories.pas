unit Repositories;

interface

uses
  Generics.collections, Strategies, func, BO;

type
  IRepository<T: class> = interface
    ['{BD04B34F-ECC7-4E38-8013-2B72840DF67D}']
    function Get(id: integer): T;
    function Save(AObject: T): T;
    function GetAll: TObjectList<T>;
  end;

  TPersonaRepository = class(TInterfacedObject, IRepository<TPersona>)
  protected
    _strategy: TRepositoryPersonaStrategy;
  public
    function Get(id: integer): TPersona;
    function Save(AObject: TPersona): TPersona;
    function GetAll: TObjectList<TPersona>;
    constructor Create(AStrategy: TRepositoryPersonaStrategy);
    destructor Destroy; override;
  end;


implementation

{ TPersonaRepository }

constructor TPersonaRepository.Create(AStrategy: TRepositoryPersonaStrategy);
begin
  inherited Create;
  _strategy := AStrategy;
end;

destructor TPersonaRepository.Destroy;
begin
  _strategy.Free;
  inherited;
end;

function TPersonaRepository.Get(id: integer): TPersona;
begin
  Result := _strategy.Get(id);
end;

function TPersonaRepository.GetAll: TObjectList<TPersona>;
begin
  Result := _strategy.GetAll;
end;

function TPersonaRepository.Save(AObject: TPersona): TPersona;
begin
  Result := _strategy.Save(AObject);
end;

end.
