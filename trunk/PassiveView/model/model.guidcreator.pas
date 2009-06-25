unit model.guidcreator;

interface

type
  TGenerator = class
    class function NewGUID: string;
  end;

implementation

{ TGenerator }

uses
  SysUtils;

class function TGenerator.NewGUID: string;
var
  Uid: TGUID;
  guid: HRESULT;
begin
  guid := CreateGuid(Uid);
  if guid = S_OK then
    Result := GuidToString(Uid)
  else
    raise Exception.Create('Cannot create a GUID');
end;

end.

