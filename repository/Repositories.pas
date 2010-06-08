unit Repositories;

interface

uses
  Generics.collections,
  Strategies,
  BO;

type
  IRepository<T: class> = interface
    ['{BD04B34F-ECC7-4E38-8013-2B72840DF67D}']
    function Get(id: integer): T;
    function Save(AObject: T): T;
    function GetAll: TObjectList<T>;
    procedure Remove(AObject: T);
  end;

  IPersonaRepository = interface(IRepository<TPersona>)
    ['{AF0FD1B8-CE8E-4719-9128-ACB89EF8CD6E}']
    function FindUltraQuarantenni: TObjectList<TPersona>;
    function FindMaggiorenni: TObjectList<TPersona>;
  end;

  TPersonaRepository = class(TInterfacedObject, IPersonaRepository)
  protected
    _strategy: TRepositoryPersonaStrategy;
  public
    function Get(id: integer): TPersona;
    function Save(AObject: TPersona): TPersona;
    function GetAll: TObjectList<TPersona>;
    function FindUltraQuarantenni: TObjectList<TPersona>;
    function FindMaggiorenni: TObjectList<TPersona>;
    procedure Remove(AObject: TPersona);
    constructor Create(AStrategy: TRepositoryPersonaStrategy);
    destructor Destroy; override;
  end;

implementation

uses
  func;

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

function TPersonaRepository.FindMaggiorenni: TObjectList<TPersona>;
begin
  Result := _strategy.FindWhereEtaGreaterThan(17);
end;

function TPersonaRepository.FindUltraQuarantenni: TObjectList<TPersona>;
begin
  Result := _strategy.FindUltraQuarantenni;
end;

function TPersonaRepository.Get(id: integer): TPersona;
begin
  Result := _strategy.Get(id);
end;

function TPersonaRepository.GetAll: TObjectList<TPersona>;
begin
  Result := _strategy.GetAll;
end;

procedure TPersonaRepository.Remove(AObject: TPersona);
begin
  _strategy.Remove(AObject);
end;

function TPersonaRepository.Save(AObject: TPersona): TPersona;
begin
  Result := _strategy.Save(AObject);
end;

end.
