unit func;

interface

uses
  sysutils, Generics.Collections;

type
  TFunctionalProc<T> = reference to procedure (var Item: T);
  Functional = class
    class procedure Map<T>(var Values: TArray<T>; Proc: TFunctionalProc<T>); overload;
    class procedure Map<T>(var Values: TList<T>; Proc: TFunctionalProc<T>); overload;
    class procedure Map<T: class>(var Values: TObjectList<T>; Proc: TFunctionalProc<T>); overload;
    class function Filter<T>(Values: TArray<T>; Func: TFunc<T, boolean>): TArray<T>;
    class function FindFirst<T>(Values: TArray<T>; var Output: T; Func: TFunc<T, boolean>): boolean;
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

class procedure Functional.Map<T>(var Values: TArray<T>; Proc: TFunctionalProc<T>);
var
  item: T;
  I: Integer;
begin
  for I := 0 to Length(Values) - 1 do
    Proc(Values[I]);
end;

class procedure Functional.Map<T>(var Values: TList<T>; Proc: TFunctionalProc<T>);
var
  item: T;
  I: Integer;
begin
  for I := 0 to Values.Count - 1 do
  begin
    item := Values[I];
    Proc(item);
  end;
end;

class function Functional.FindFirst<T>(Values: TArray<T>; var Output: T;
  Func: TFunc<T, boolean>): boolean;
var
  item: T;
begin
  Result := False;
  for item in Values do
    if Func(item) then
    begin
      Result := true;
      Output := item;
      Break;
    end;
end;

class procedure Functional.Map<T>(var Values: TObjectList<T>;
  Proc: TFunctionalProc<T>);
var
  item: T;
  I: Integer;
begin
  for I := 0 to Values.Count - 1 do
  begin
    item := Values[I];
    Proc(item);
  end;
end;

end.
