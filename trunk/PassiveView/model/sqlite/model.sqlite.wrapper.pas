unit model.sqlite.wrapper;

interface

uses
  model.common, ContNrs, SQLiteTable3;

type
  TSQLLiteWrapper = class(TInterfacedObject, IDatabase)
  private
    FDatabaseFileName: string;
  protected
    db: TSQLiteDatabase;
    procedure Connect(const DatabaseFileName: String); virtual;
  public
    constructor Create(const DatabaseFileName: String); overload; virtual;
    procedure ExecuteCommand(const AStatement: string);
    function ExecuteQuery(const AStatement: string): TObjectList;
  end;

  TSQLLiteTableWrapper = class(TInterfacedObject, IResultSet)
  protected
    FSQLIteTable: TSQLiteTable;
    FCurrentIndex: Integer;
    procedure CheckCurrentIndex;
  public
    constructor Create(ASQLIteTable: TSQLiteTable); overload; virtual;
    destructor Destroy; override;
    function GetFieldAsString(FieldName: String): String;
    function GetFieldAsInteger(FieldName: String): Integer;
    function GetFieldAsDateTime(FieldName: String): TDateTime;
    function Next: Boolean;
  end;

implementation

uses
  SysUtils;

{ TSQLLiteWrapper }

procedure TSQLLiteWrapper.Connect(const DatabaseFileName: String);
begin
  db := TSQLiteDatabase.Create(FDatabaseFileName);
  FDatabaseFileName:= DatabaseFileName;
end;

constructor TSQLLiteWrapper.Create(const DatabaseFileName: String);
begin
  inherited Create;
  Connect(DatabaseFileName);
end;

procedure TSQLLiteWrapper.ExecuteCommand(const AStatement: string);
begin
  db.ExecSQL(AStatement);
end;

function TSQLLiteWrapper.ExecuteQuery(const AStatement: string): TObjectList;
var
  table: TSQLiteTable;
begin
  table := db.GetTable(AStatement);
  try

  finally
    table.Free;
  end;
end;

{ TSQLLiteTableWrapper }

procedure TSQLLiteTableWrapper.CheckCurrentIndex;
begin
  if FCurrentIndex = -1 then
    raise Exception.Create('ResultSet at BOF');
end;

constructor TSQLLiteTableWrapper.Create(ASQLIteTable: TSQLiteTable);
begin
  inherited Create;
  FCurrentIndex := -1;
  FSQLIteTable := ASQLIteTable;
end;

destructor TSQLLiteTableWrapper.Destroy;
begin
  FSQLIteTable.Free;
  inherited;
end;

function TSQLLiteTableWrapper.GetFieldAsDateTime(FieldName: String): TDateTime;
begin
  raise Exception.Create('DateTime not supported by SQLite');
end;

function TSQLLiteTableWrapper.GetFieldAsInteger(FieldName: String): Integer;
begin
  Result := FSQLIteTable.FieldAsInteger(FSQLIteTable.FieldIndex[FieldName]);
end;

function TSQLLiteTableWrapper.GetFieldAsString(FieldName: String): String;
begin
  Result := FSQLIteTable.FieldAsString(FSQLIteTable.FieldIndex[FieldName]);
end;

function TSQLLiteTableWrapper.Next: Boolean;
begin
  Result := not FSQLIteTable.EOF;
  if result then
    if FCurrentIndex = -1 then
    begin
      FCurrentIndex := 0
    end
    else
    begin
      inc(FCurrentIndex);
      FSQLIteTable.Next;
    end;
end;

end.
