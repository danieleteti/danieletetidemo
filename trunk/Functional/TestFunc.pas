unit TestFunc;

interface

uses
  TestFramework, func, Generics.Collections;

type
  TMyObject = class
    FirstName: String;
    LastName: String;
    constructor Create(FirstName, LastName: String);
  end;

  TTestFunc = class(TTestCase)
  protected
    function GetData: TArray<string>;
    function GetDataAsObjectList: TObjectList<TMyObject>;
  published
    procedure TestFilter;
    procedure TestFilterNoResult;
    procedure TestFilterAllResult;
    procedure TestMap;
    procedure TestMapObjectList;
    procedure TestFindFirstNoData;
    procedure TestFindFirstWithData;
    procedure TestYield;
    procedure TestFileForEach;
    procedure TestListForEach;
    procedure TestListForEachString;
    procedure TestIterator;
    procedure TestFileIterator;
  end;

implementation

{ TTestFunc }

function TTestFunc.GetData: TArray<string>;
begin
  SetLength(Result, 6);
  Result[0] := 'Daniele Teti';
  Result[1] := 'Bruce Banner';
  Result[2] := 'Scott Summer';
  Result[3] := 'Sue Storm';
  Result[4] := 'Peter Parker';
  Result[5] := 'Bruce Wine';
end;

function TTestFunc.GetDataAsObjectList: TObjectList<TMyObject>;
begin
  Result := TObjectList<TMyObject>.Create(true);
  Result.Add(TMyObject.Create('Daniele','Teti'));
  Result.Add(TMyObject.Create('Bruce','Banner'));
  Result.Add(TMyObject.Create('Scott','Summer'));
  Result.Add(TMyObject.Create('Sue','Storm'));
  Result.Add(TMyObject.Create('Peter','Parker'));
  Result.Add(TMyObject.Create('Bruce','Wine'));
end;


procedure TTestFunc.TestFilterNoResult;
var
  d: TArray<string>;
begin
  d := Functional.Filter<string>(GetData, function (item: string): boolean begin
    Result := false;
  end);
  CheckEquals(0, Length(d));
end;

procedure TTestFunc.TestFindFirstNoData;
var
  d: TArray<string>;
  s: string;
  r: boolean;
begin
  d := GetData;
  r := Functional.FindFirst<string>(d, s,
    function (item: string): boolean
    begin
      result := Pos('no exists', item) > 0;
    end);
  CheckFalse(r);
end;

procedure TTestFunc.TestFindFirstWithData;
var
  d: TArray<string>;
  s: string;
  r: boolean;
begin
  d := GetData;
  r := Functional.FindFirst<string>(d, s,
    function (item: string): boolean
    begin
      result := Pos('Daniele', item) > 0;
    end);
  CheckTrue(r);
end;

procedure TTestFunc.TestIterator;
var
  i, x: integer;
begin
  x := 0;
  for i in List<integer>.From([1,3,5,7,9]) do
    x := x + i;
  CheckEquals(25, x);

  x := 0;
  for i in List<integer>.From([]) do
    x := x + i;
  CheckEquals(0, x);
end;

procedure TTestFunc.TestListForEach;
var
  sum: PInteger;
begin
  sum := New(PInteger);
  try
    sum^ := 0;
    List<integer>.From([10,20,30]).ForEach(
      procedure (item: integer)
      begin
        sum^ := sum^ + item;
      end
    );
    CheckEquals(60, sum^);
  finally
    Dispose(sum);
  end;
end;

procedure TTestFunc.TestListForEachString;
var
  sum: string;
begin
  sum := '';
  List<string>.From(['Daniele','Teti','and','Peter','Parker']).ForEach(
    procedure (item: string)
    begin
      sum := sum + ',' + item
    end
  );
  CheckEquals(',Daniele,Teti,and,Peter,Parker', sum);
end;

procedure TTestFunc.TestMap;
var
  d: TArray<string>;
begin
  d := GetData;
  Functional.Map<string>(d,
    procedure (var item: string)
    begin
      item := '*' + item;
    end);
  CheckEquals(6, Length(d));
  CheckEquals('*Daniele Teti', d[0]);
  CheckEquals('*Bruce Banner', d[1]);
  CheckEquals('*Scott Summer', d[2]);
end;

procedure TTestFunc.TestMapObjectList;
var
  d: TObjectList<TMyObject>;
begin
  d := GetDataAsObjectList;
  try
    Functional.Map<TMyObject>(d,
      procedure (var item: TMyObject)
      begin
        item.FirstName := '*' + item.FirstName;
      end);
    CheckEquals(6, d.Count);
    CheckEquals('*Daniele', d[0].FirstName);
    CheckEquals('*Bruce', d[1].FirstName);
    CheckEquals('*Scott', d[2].FirstName);
  finally
    d.Free;
  end;
end;

procedure TTestFunc.TestYield;
begin
  CheckTrue(true);
end;

procedure TTestFunc.TestFilterAllResult;
var
  d: TArray<string>;
begin
  d := Functional.Filter<string>(GetData,
    function (item: string): boolean
    begin
      Result := True;
    end);
  CheckEquals(6, Length(d));
end;

procedure TTestFunc.TestFileForEach;
var
  s: string;
begin
  s := '';
  F.Open('file.txt').ForEachLine(
    procedure (value: string)
    begin
      s := s + value;
    end
  );
  CheckEquals('onetwothreefourfive', s);
end;

procedure TTestFunc.TestFileIterator;
var
  s, x: string;
  i: IFileOperation;
begin
  s := '';
  for x in F.Open('file.txt') do s := s + x;
  CheckEquals('onetwothreefourfive', s);
end;

procedure TTestFunc.TestFilter;
var
  d: TArray<string>;
begin
  d := Functional.Filter<string>(GetData,
    function (item: string): boolean
    begin
      Result := item[1] = 'S';
    end);
  CheckEquals(2, Length(d));
  CheckEquals('Scott Summer', d[0]);
  CheckEquals('Sue Storm', d[1]);
end;

{ TMyObject }

constructor TMyObject.Create(FirstName, LastName: String);
begin
  inherited Create;
  Self.FirstName := FirstName;
  Self.LastName := LastName;
end;

initialization
  RegisterTest(TTestFunc.Suite);

end.
