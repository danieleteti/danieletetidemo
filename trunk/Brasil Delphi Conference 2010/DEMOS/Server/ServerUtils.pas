unit ServerUtils;

interface

function ISODateToStr(Date: TDate): string;
function StrISOToDate(Value: string): TDate;

implementation

uses
  SysUtils;

function ISODateToStr(Date: TDate): string;
begin
  Result := FormatDateTime('yyyy-mm-dd hh:nn:ss', Date);
end;

function StrISOToDate(Value: string): TDate;
begin
  Result := EncodeDate(StrToInt(Copy(Value, 1, 4)), StrToInt(Copy(Value, 6, 2)),
    StrToInt(Copy(Value, 9, 2)));
end;

end.
