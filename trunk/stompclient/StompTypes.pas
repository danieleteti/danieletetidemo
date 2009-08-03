unit StompTypes;

interface

uses
  Windows, Messages, SysUtils, Classes, ExtCtrls;

const
  LINE_END: char = #10;
  COMMAND_END: char = #0;

type
  TAckMode = (amAuto, amClient);
  EStomp = class(Exception)
  end;

  TKeyValue = record
    Key: string;
    Value: string;
  end;
  PKeyValue = ^TKeyValue;

  IStompHeaders = interface
    ['{BD087D9D-0576-4C35-88F9-F5D6348E3894}']
    function Add(Key, Value: string): IStompHeaders;
    function Value(Key: string): string;
    function Remove(Key: string): IStompHeaders;
    function IndexOf(Key: string): Integer;
    function Count: Cardinal;
    function GetAt(const Index: Integer): TKeyValue;
    function Output: string;
  end;

  TStompHeaders = class(TInterfacedObject, IStompHeaders)
  private
    FList: TList;
    function GetItems(index: Cardinal): TKeyValue;
    procedure SetItems(index: Cardinal; const Value: TKeyValue);
  public
    function Add(Key, Value: string): IStompHeaders;
    function Value(Key: string): string;
    function Remove(Key: string): IStompHeaders;
    function IndexOf(Key: string): Integer;
    function Count: Cardinal;
    function GetAt(const Index: Integer): TKeyValue;
    constructor Create;
    destructor Destroy; override;
    function Output: string;
    property Items[index: Cardinal]: TKeyValue read GetItems write SetItems;
    default;
  end;

  //Frame class
  TStompFrame = class(TInterfacedObject)
  private
    FCommand: string;
    FBody: string;
    FHeaders: IStompHeaders;
    procedure SetHeaders(const Value: IStompHeaders);
  public
    constructor Create;
    destructor Destroy; override;
    property Command: string read FCommand write FCommand;
    property Body: string read FBody write FBody;
    //return '', when Key doesn't exist or Value of Key is ''
    //otherwise, return Value;
    function Output: string;
    property Headers: IStompHeaders read FHeaders write SetHeaders;
  end;

  TAddress = record
    Host: string;
    Port: Integer;
    UserName: string;
    Password: string;
  end;

  TAddresses = array of TAddress;

  //process message in the buffer
  //return TFrame, when there is no complete frame in the buffer, return nil.
  //buf contains what left after processing.
function CreateFrame(Buf: string): TStompFrame;
function AckModeToStr(AckMode: TAckMode): String;

function StompHeaders: IStompHeaders;

implementation

function StompHeaders: IStompHeaders;
begin
  Result := TStompHeaders.Create;
end;

function AckModeToStr(AckMode: TAckMode): String;
begin
  case AckMode of
    amAuto : Result := 'auto';
    amClient: Result := 'client';
    else
      raise EStomp.Create('Unknown AckMode');
  end;
end;

constructor TStompFrame.Create;
begin
  FHeaders := TStompHeaders.Create;
  self.FCommand := '';
  self.FBody := '';
end;

destructor TStompFrame.Destroy;
begin
  inherited;
end;

function TStompFrame.output: string;
begin
  Result := FCommand + LINE_END + FHeaders.Output + LINE_END + FBody + LINE_END + COMMAND_END;
end;


procedure TStompFrame.SetHeaders(const Value: IStompHeaders);
begin
  FHeaders := Value;
end;

function GetLine(Buf: string; var From: Integer): string;
var
  i: Integer;
begin
  if (From > Length(Buf)) then
    raise EStomp.Create('From out of bound.');

  i := From;

  while (i <= Length(Buf)) do
  begin
    if (Buf[i] <> LINE_END) then
      inc(i)
    else
      break;
  end;

  if (Buf[i] = LINE_END) then
  begin
    result := Copy(Buf, From, i - From);
    From := i + 1;
    exit;
  end
  else
    raise EStomp.Create('End of Line not found.');
end;

function CreateFrame(Buf: string): TStompFrame;
var
  line: string;
  i: Integer;
  p: Integer;
  key, value: string;
  other: string;
  contLen: Integer;
  sContLen: string;
begin
  result := TStompFrame.Create;
  i := 1;
  try
    result.Command := GetLine(Buf, i);
    while (true) do
    begin
      line := GetLine(Buf, i);
      if (line = '') then
        break;
      p := Pos(':', line);
      if (p = 0) then
        raise Exception.Create('header line error');
      key := Copy(line, 1, p - 1);
      value := Copy(line, p + 1, Length(Line) - p);
      result.Headers.Add(key, value);
    end;
    other := Copy(Buf, i, High(Integer));
    sContLen := result.Headers.Value('content-length');
    if (sContLen <> '') then
    begin
      contLen := StrToInt(sContLen);
      if Length(other) < contLen + 2 then
        raise EStomp.Create('frame too short');
      if Copy(other, contLen + 1, 2) <> COMMAND_END + LINE_END then
        raise Exception.Create('frame ending error');
      result.Body := Copy(other, 1, contLen);
      //Buf := Copy(other, contLen + 3, High(Integer));
    end
    else
    begin
      p := Pos(COMMAND_END, other);
      if (p = 0) then
        raise EStomp.Create('frame no ending');
      result.Body := Copy(other, 1, p - 2);
      //Buf := Copy(other, p + 2, High(Integer));
    end;
  except
    on EStomp do
    begin
      //ignore
      result.Free;
      result := nil;
    end;
    on e: Exception do
    begin
      result.Free;
      raise EStomp.Create(e.Message);
    end;
  end;
end;

{ TStompHeaders }

function TStompHeaders.Add(Key, Value: string): IStompHeaders;
var
  p: PKeyValue;
begin
  New(p);
  p^.Key := Key;
  p^.Value := Value;
  FList.Add(p);
  Result := Self;
end;

function TStompHeaders.Count: Cardinal;
begin
  Result := FList.Count;
end;

constructor TStompHeaders.Create;
begin
  inherited;
  FList := TList.Create;
end;

destructor TStompHeaders.Destroy;
var
  I: Integer;
begin
  if FList.Count > 0 then
    for I := 0 to FList.Count - 1 do
      FreeMem(PKeyValue(FList[i]));
  FList.Free;
  inherited;
end;

function TStompHeaders.GetAt(const Index: Integer): TKeyValue;
begin
  Result := GetItems(Index)
end;

function TStompHeaders.GetItems(index: Cardinal): TKeyValue;
begin
  Result := PKeyValue(FList[index])^;
end;

function TStompHeaders.IndexOf(Key: string): Integer;
var
  I: Integer;
begin
  Result := -1;
  for I := 0 to FList.Count - 1 do
  begin
    if GetItems(i).Key = Key then
    begin
      Result := i;
      Break;
    end;
  end;
end;

function TStompHeaders.Output: string;
var
  i: Integer;
  kv: TKeyValue;
begin
  Result := '';
  if FList.Count > 0 then
    for i := 0 to FList.Count - 1 do
    begin
      kv := Items[i];
      Result := Result + kv.Key + ':' + kv.Value + LINE_END;
    end
  else
    Result := LINE_END;
end;

function TStompHeaders.Remove(Key: string): IStompHeaders;
var
  p: Integer;
begin
  p := IndexOf(key);
  FreeMem(PKeyValue(FList[p]));
  FList.Delete(p);
  result := self;
end;

procedure TStompHeaders.SetItems(index: Cardinal; const Value: TKeyValue);
var
  p: Integer;
begin
  p := IndexOf(Value.Key);
  if p > -1 then
  begin
    PKeyValue(FList[p])^.Key := Value.Key;
    PKeyValue(FList[p])^.Value := Value.Value;
  end
  else
    raise EStomp.Create('Error SetItems');
end;

function TStompHeaders.Value(Key: string): string;
var
  i: Integer;
begin
  Result := '';
  i := IndexOf(Key);
  if i > -1 then
    Result := GetItems(i).Value;
end;

end.

