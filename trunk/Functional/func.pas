unit func;

interface

uses
  sysutils, Generics.Collections, classes;

type
  TFunctionalProc<T> = reference to procedure (var Item: T);
  Functional = class
    class procedure Map<T>(var Values: TArray<T>; Proc: TFunctionalProc<T>); overload;
    class procedure Map<T>(var Values: TList<T>; Proc: TFunctionalProc<T>); overload;
    class procedure Map<T: class>(var Values: TObjectList<T>; Proc: TFunctionalProc<T>); overload;
    class function Filter<T>(Values: TArray<T>; Func: TFunc<T, boolean>): TArray<T>;
    class function FindFirst<T>(Values: TArray<T>; var Output: T; Func: TFunc<T, boolean>): boolean;
  end;


  LineEnumerator = class
  private
    FStreamReader: TStreamReader;
    FCurLine: String;
    FHasBeenCalledMoveNext: Boolean;
  protected
    function GetCurrent: string;
    constructor Create(AStreamReader: TStreamReader);
    destructor Destroy; override;
  public
    function MoveNext: boolean;
    property Current: string read GetCurrent;
  end;

  IFileOperation = interface
    ['{A607F81A-3C99-40AE-9999-A221346F3152}']
    procedure ForEachLine(Proc: TProc<string>);
    function GetEnumerator: LineEnumerator;
  end;


  ListEnumerator<T> = class
  private
    FList: TList<T>;
    idx: Integer;
  protected
    function GetCurrent: T;
    constructor Create(AList: TList<T>);
    destructor Destroy; override;
  public
    function MoveNext: boolean;
    property Current: T read GetCurrent;
  end;


  IListOperation<T> = interface
    ['{438C2DD1-7240-4D90-968B-5BB3862D8166}']
    procedure ForEach(Proc: TProc<T>);
    function GetEnumerator: ListEnumerator<T>;
  end;

  List<T> = class(TInterfacedObject, IListOperation<T>)
  protected
    FList: array of T;
    constructor Create(AList: array of T);
    destructor Destroy; override;
    procedure ForEach(Proc: TProc<T>);
    function GetEnumerator: ListEnumerator<T>;
    function ArrayToList(AList: array of T): TList<T>;
  public
    class function From(AList: array of T): IListOperation<T>;
  end;

  F = class(TInterfacedObject, IFileOperation)
  protected
    FFileName: string;
    constructor Create(AFileName: String);
    destructor Destroy; override;
    procedure ForEachLine(Proc: TProc<string>);
    function GetEnumerator: LineEnumerator;
  public
    class function Open(AFileName: String): IFileOperation;
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

{ f }

constructor f.Create(AFileName: String);
begin
  inherited Create;
  FFileName:= AFileName;
end;

destructor f.Destroy;
begin
  inherited;
end;

procedure F.ForEachLine(Proc: TProc<string>);
var
  sw: TStreamReader;
begin
  sw := TStreamReader.Create(FFileName, true);
  try
    while not sw.EndOfStream do
      Proc(sw.ReadLine);
  finally
    sw.Free;
  end;
  _Release;
end;


function F.GetEnumerator: LineEnumerator;
begin
  Result := LineEnumerator.Create(TStreamReader.Create(FFileName, true));
end;

class function F.Open(AFileName: String): IFileOperation;
begin
  Result := f.Create(AFileName);
end;

{ List<T> }

constructor List<T>.Create(AList: array of T);
var
  item: T;
  i: Integer;
begin
  inherited Create;
  SetLength(FList, Length(AList));
  i := 0;
  for item in AList do
  begin
    FList[i] := AList[i];
    inc(i);
  end;
end;

destructor List<T>.Destroy;
begin

  inherited;
end;

procedure List<T>.ForEach(Proc: TProc<T>);
var
  item: T;
begin
  for item in FList do
    Proc(item);
end;

function List<T>.GetEnumerator: ListEnumerator<T>;
begin
  Result := ListEnumerator<T>.Create(ArrayToList(FList));
end;

function List<T>.ArrayToList(AList: array of T): TList<T>;
var
  item: T;
begin
  Result := TList<T>.Create;
  Result.AddRange(AList);
end;

class function List<T>.From(AList: array of T): IListOperation<T>;
begin
  Result := List<T>.Create(AList);
end;

{ ListEnumerator<T> }

constructor ListEnumerator<T>.Create(AList: TList<T>);
var
  i: Integer;
  item: T;
begin
  inherited Create;
  FList := AList;
  idx := -1;
end;

destructor ListEnumerator<T>.Destroy;
begin
  FList.Free;
  inherited;
end;

function ListEnumerator<T>.GetCurrent: T;
begin
  Result := FList[idx];
end;

function ListEnumerator<T>.MoveNext: boolean;
begin
  Result := idx < FList.Count - 1;
  if Result then
    inc(idx);
end;

{ LineEnumerator }

constructor LineEnumerator.Create(AStreamReader: TStreamReader);
begin
  inherited Create;
  FHasBeenCalledMoveNext := False;
  FStreamReader := AStreamReader;
end;

destructor LineEnumerator.Destroy;
begin
  FStreamReader.Close;
  FStreamReader.Free;
  inherited;
end;

function LineEnumerator.GetCurrent: string;
begin
  if FHasBeenCalledMoveNext then
    Result := FCurLine
  else
    Result := '';
end;

function LineEnumerator.MoveNext: boolean;
begin
  Result := not FStreamReader.EndOfStream;
  if Result then
    FCurLine := FStreamReader.ReadLine;
  FHasBeenCalledMoveNext := True;
end;

end.
