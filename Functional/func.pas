unit func;

interface

uses
  sysutils;

type
  Functional = class
    class function Map<T>(var Values: TArray<T>; Func: TFunc<T, T>): T;
    class function Filter<T>(Values: TArray<T>; Func: TFunc<T, boolean>): TArray<T>;
  end;

implementation

{ Functional }

class function Functional.Filter<T>(Values: TArray<T>;
  Func: TFunc<T, boolean>): TArray<T>;
var
  item: T;
begin
  SetLength(Result, 0);
  for item in Values do
    if Func(item) then
    begin
      SetLength(Result, length(Result) + 1);
      Result[length(Result)-1] := item;
    end;
end;

class function Functional.Map<T>(var Values: TArray<T>; Func: TFunc<T, T>): T;
var
  item: T;
  I: Integer;
begin
  if Length(Values) > 0 then
    for I := 0 to Length(Values) - 1 do
      Values[I] := Func(Values[I]);
end;

end.
