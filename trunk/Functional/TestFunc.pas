unit TestFunc;

interface

uses
  TestFramework, func;

type
  TTestFunc = class(TTestCase)
  protected
    function GetData: TArray<string>;
  published
    procedure TestFilter;
    procedure TestFilterNoResult;
    procedure TestFilterAllResult;
    procedure TestMap;
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

procedure TTestFunc.TestFilterNoResult;
var
  d: TArray<string>;
begin
  d := Functional.Filter<string>(GetData, function (item: string): boolean begin
    Result := false;
  end);
  CheckEquals(0, Length(d));
end;

procedure TTestFunc.TestMap;
var
  d: TArray<string>;
begin
  d := GetData;
  Functional.Map<string>(d,
    function (item: string): string
    begin
      Result := '*' + item;
    end);
  CheckEquals(6, Length(d));
  CheckEquals('*Daniele Teti', d[0]);
  CheckEquals('*Bruce Banner', d[1]);
  CheckEquals('*Scott Summer', d[2]);
end;

procedure TTestFunc.TestFilterAllResult;
var
  d: TArray<string>;
begin
  d := Functional.Filter<string>(GetData, function (item: string): boolean begin
    Result := True;
  end);
  CheckEquals(6, Length(d));
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

initialization
  RegisterTest(TTestFunc.Suite);

end.
