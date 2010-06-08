unit Strategies;

interface

uses
  Generics.collections, BO, func;

type
  TRepositoryStrategy<T: class> = class abstract
    function Get(id: integer): T; virtual; abstract;
    function Save(AObject: T): T; virtual; abstract;
    procedure Remove(AObject: TPersona); virtual; abstract;
    function GetAll: TObjectList<T>; virtual; abstract;
  end;

  TRepositoryPersonaStrategy = class(TRepositoryStrategy<TPersona>)
    function FindUltraQuarantenni: TObjectList<TPersona>; virtual; abstract;
    function FindWhereEtaGreaterThan(const Eta: Integer): TObjectList<TPersona>; virtual; abstract;
  end;

implementation

end.
