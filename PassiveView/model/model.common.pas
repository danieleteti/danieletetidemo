unit model.common;

interface

uses
  ContNrs;

type
  IBase = interface
    ['{C4621F03-6FF3-419A-8464-23874C46EC42}']
    function GetGUID: String;
    procedure SetGUID(const Value: String);
    property GUID: String read GetGUID Write SetGUID;
  end;

  ISpeaker = interface(IBase)
    ['{5453BB86-4567-4FD2-9AF5-76A10C451F79}']
    function GetFirstName: String;
    procedure SetFirstName(const Value: String);
    property FirstName: String read GetFirstName Write SetFirstName;

    function GetLastName: String;
    procedure SetLastName(const Value: String);
    property LastName: String read GetLastName Write SetLastName;

  end;

  ISpeakerMapper = interface
    ['{7B67DCBD-6787-441A-8108-B5C5C6417B4B}']
    procedure Insert(ASpeaker: ISpeaker);
    procedure Update(ASpeaker: ISpeaker);
    procedure Delete(ASpeaker: ISpeaker);
    function GetByGUID(const GUID: string): ISpeaker;
    procedure DeleteAll;
    function Count: Cardinal;      
  end;

  IDatabase = interface
  ['{5127A1F5-BCEA-4D7E-A8A7-429E5FC14C05}']
    procedure ExecuteCommand(const AStatement: String);
    function ExecuteQuery(const AStatement: String): TObjectList;
  end;

  IResultSet = interface
  ['{E1D404CA-1B20-4279-A044-EA7ED81974B3}']
    function GetFieldAsString(FieldName: String): String;
    function GetFieldAsInteger(FieldName: String): Integer;
    function GetFieldAsDateTime(FieldName: String): TDateTime;
    function Next: Boolean;
  end;


  TBaseObject = class(TInterfacedObject, IBase)
  private
    FGUID: string;
  public
    function GetGUID: String;
    procedure SetGUID(const Value: String);
    property GUID: String read GetGUID Write SetGUID;
  end;

implementation

{ TBaseObject }
function TBaseObject.GetGUID: String;
begin
  Result := FGUID;
end;

procedure TBaseObject.SetGUID(const Value: String);
begin
  FGUID := Value;
end;

end.
