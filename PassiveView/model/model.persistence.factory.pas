unit model.persistence.factory;

interface

uses
  model.common;

type
  TDBType = (dtSqlite);

  TPersistenceFactory = class
    class function GetSQLiteConnection: tqualcosa;
  end;

implementation

uses
  SysUtils, model.sqlite.wrapper, SQLiteTable3;

{ TPersistenceFactory }

class function TPersistenceFactory.GetConnection(dbtype: TDBType): IDatabase;
begin
  case dbtype of
    dtSqlite:
      Result := .Create;
    else
      raise Exception.Create('Unknown dbtype');    
  end;
end;

end.
