unit model.persistence.factory;

interface

uses
  model.common, SQLiteTable3;

type
  TDBFactory = class
  private
    class var SQLiteDatabase: TSQLiteDatabase;
  public
    class var ConnectionString: String;
    class function Instance: TSQLiteDatabase;
  end;

implementation

uses
  SysUtils;

class function TDBFactory.Instance: TSQLiteDatabase;
begin
  if SQLiteDatabase = nil then
    SQLiteDatabase := TSQLiteDatabase.Create('C:\tests\danieletetidemo\PassiveView\bin\data.db');
  Result := SQLiteDatabase;
end;

end.
