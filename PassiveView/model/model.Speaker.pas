unit model.Speaker;

interface
uses model.common;

type
  TSpeaker = class(TBaseObject, ISpeaker)
  protected
    FFirstName, FLastName: String;
  public
    function GetFirstName: String;
    procedure SetFirstName(const Value: String);
    function GetLastName: String;
    procedure SetLastName(const Value: String);
    //Properties
    property FirstName: String read GetFirstName Write SetFirstName;
    property LastName: String read GetLastName Write SetLastName;
  end;

implementation

function TSpeaker.GetFirstName: string;
begin
  Result := FFirstName;
end;

function TSpeaker.GetLastName: string;
begin
  Result := FLastName;
end;

procedure TSpeaker.SetFirstName(const Value: string);
begin
  FFirstName := Value;
end;

procedure TSpeaker.SetLastName(const Value: string);
begin
  FLastName := Value;
end;
end.
