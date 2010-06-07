unit Strategies;

interface

uses
  Generics.collections, BO;

type
  TRepositoryStrategy<T: class> = class abstract
    function Get(id: integer): T; virtual; abstract;
    function Save(AObject: T): T; virtual; abstract;
    function Remove(AObject: T): T; virtual; abstract;
    function GetAll: TObjectList<T>; virtual; abstract;
  end;

  TRepositoryPersonaStrategy = class(TRepositoryStrategy<TPersona>)
  end;

implementation

end.
