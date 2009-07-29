unit StompClient;

interface

uses
  StompTypes, IdTCPClient, SysUtils;

type
  TStompClient = class
  private
    tcp: TIdTCPClient;
    FHeaders: TStompHeaders;
    FPassword: string;
    FUserName: string;
    FTimeout: Integer;
    FSession: string;
    procedure SetPassword(const Value: string);
    procedure SetUserName(const Value: string);
    procedure SetTimeout(const Value: Integer);
  protected
    procedure SendFrame(AFrame: TStompFrame);
  public
    function Receive: TStompFrame;
    procedure Connect(Host: string; Port: Integer = 61613);
    procedure Disconnect;
    procedure Subscribe(Queue: string; Ack: TAckMode = amAuto);
    procedure Unsubscribe(Queue: string);
    procedure Send(Queue: string; TextMessage: string);
    constructor Create;
    destructor Destroy; override;
    property UserName: string read FUserName write SetUserName;
    property Password: string read FPassword write SetPassword;
    property Timeout: Integer read FTimeout write SetTimeout;
    property Session: string read FSession;
  end;

implementation

uses
  Classes;

{ TStompClient }

procedure TStompClient.Connect(Host: string; Port: Integer = 61613);
var
  Frame: TStompFrame;
begin
  try
    tcp.Connect(Host, Port);
    tcp.IOHandler.MaxLineLength := MaxInt;
    Frame := TStompFrame.Create;
    Frame.Command := 'CONNECT';
    Frame.Headers.Add('login', FUserName);
    Frame.Headers.Add('passcode', FPassword);
    SendFrame(Frame);
    FreeAndNil(Frame);
    while Frame = nil do
    begin
      Frame := Receive;
    end;
    if Frame.Command = 'ERROR' then
      raise EStomp.Create(Frame.output);
    if Frame.Command = 'CONNECTED' then
    begin
      FSession := Frame.headers.Value('session');
    end;
    {todo: 'Call event?'}
  except
    on E: Exception do
    begin
      raise EStomp.Create(E.Message);
    end;
  end;
end;

constructor TStompClient.Create;
begin
  inherited;
  FSession := '';
  FHeaders := TStompHeaders.Create;
  tcp := TIdTCPClient.Create(nil);
  FTimeout := 1000;
end;

destructor TStompClient.Destroy;
begin
  FHeaders.Free;
  tcp.Free;
  inherited;
end;

procedure TStompClient.Disconnect;
var
  Frame: TStompFrame;
begin
  Frame := TStompFrame.Create;
  try
    Frame.Command := 'DISCONNECT';
    SendFrame(Frame);
  finally
    Frame.Free;
  end;
  tcp.Disconnect;
end;

function TStompClient.Receive: TStompFrame;
var
  s: string;
begin
  Result := nil;
  s := tcp.IOHandler.ReadLn(COMMAND_END + LINE_END, FTimeout);
  if not tcp.IOHandler.ReadLnTimedout then
    Result := CreateFrame(s + #0)
end;

procedure TStompClient.Send(Queue, TextMessage: string);
var
  Frame: TStompFrame;
begin
  Frame := TStompFrame.Create;
  try
    Frame.Command := 'SEND';
    Frame.Headers.Add('destination', Queue);
    Frame.Body := TextMessage;
    SendFrame(Frame);
  finally
    Frame.Free;
  end;
end;

procedure TStompClient.SendFrame(AFrame: TStompFrame);
begin
  tcp.IOHandler.Write(AFrame.Output);
end;

procedure TStompClient.SetPassword(const Value: string);
begin
  FPassword := Value;
end;

procedure TStompClient.SetTimeout(const Value: Integer);
begin
  FTimeout := Value;
end;

procedure TStompClient.SetUserName(const Value: string);
begin
  FUserName := Value;
end;

procedure TStompClient.Subscribe(Queue: string; Ack: TAckMode = amAuto);
var
  Frame: TStompFrame;
begin
  Frame := TStompFrame.Create;
  try
    Frame.Command := 'SUBSCRIBE';
    Frame.Headers.Add('destination', Queue);
    Frame.Headers.Add('ack', AckModeToStr(Ack));
    SendFrame(Frame);
  finally
    Frame.Free;
  end;
end;

procedure TStompClient.Unsubscribe(Queue: string);
var
  Frame: TStompFrame;
begin
  Frame := TStompFrame.Create;
  try
    Frame.Command := 'UNSUBSCRIBE';
    Frame.Headers.Add('destination', Queue);
    SendFrame(Frame);
  finally
    Frame.Free;
  end;
end;

end.

