unit StompClient;

interface

uses
  StompTypes, IdTCPClient;

type
  TStompClient = class
  private
    tcp: TIdTCPClient;
    FHeaders: TStompHeaders;
    FPassword: String;
    FUserName: String;
    FTimeout: Integer;
    procedure SetPassword(const Value: String);
    procedure SetUserName(const Value: String);
    procedure SetTimeout(const Value: Integer);
  protected
    procedure SendFrame(AFrame: TStompFrame);
  public
    function Receive: TStompFrame;
    procedure Connect(Host: String; Port: Integer = 61613);
    procedure Subscribe(Queue: String; Ack: TAckMode = amAuto);
    procedure Unsubscribe(Queue: String);
    procedure Send(Queue: String; TextMessage: String);
    constructor Create;
    destructor Destroy; override;
    property UserName: String read FUserName write SetUserName;
    property Password: String read FPassword write SetPassword;
    property Timeout: Integer read FTimeout write SetTimeout;
  end;

implementation

{ TStompClient }

procedure TStompClient.Connect(Host: String; Port: Integer = 61613);
var
  Frame: TStompFrame;
begin
  tcp.Connect(Host, Port);
  Frame := TStompFrame.Create;
  Frame.Command := 'CONNECT';
  Frame.Headers.Add('login', FUserName);
  Frame.Headers.Add('passcode', FPassword);
  SendFrame(Frame);
  Frame.Free;
  Frame := Receive;
  if Assigned(Frame) then
    WriteLn(Frame.Output);
end;

constructor TStompClient.Create;
begin
  inherited;
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

function TStompClient.Receive: TStompFrame;
var
  s: string;
begin
  s := tcp.IOHandler.ReadLn(COMMAND_END + LINE_END, FTimeout);
  if s <> '' then
    Result := CreateFrame(s + #0)
  else
    Result := nil;
end;

procedure TStompClient.Send(Queue, TextMessage: String);
var
  Frame: TStompFrame;
begin
  Frame := TStompFrame.Create;
  Frame.Command := 'SEND';
  Frame.Headers.Add('destination', Queue);
  Frame.Body := TextMessage;
  SendFrame(Frame);
  Frame.Free;
end;

procedure TStompClient.SendFrame(AFrame: TStompFrame);
begin
  tcp.IOHandler.Write(AFrame.Output);
end;

procedure TStompClient.SetPassword(const Value: String);
begin
  FPassword := Value;
end;

procedure TStompClient.SetTimeout(const Value: Integer);
begin
  FTimeout := Value;
end;

procedure TStompClient.SetUserName(const Value: String);
begin
  FUserName := Value;
end;

procedure TStompClient.Subscribe(Queue: String; Ack: TAckMode = amAuto);
var
  Frame: TStompFrame;
begin
  Frame := TStompFrame.Create;
  Frame.Command := 'SUBSCRIBE';
  Frame.Headers.Add('destination', Queue);
  Frame.Headers.Add('ack', AckModeToStr(Ack));
  SendFrame(Frame);
  Frame.Free;
end;

procedure TStompClient.Unsubscribe(Queue: String);
var
  Frame: TStompFrame;
begin
  Frame := TStompFrame.Create;
  Frame.Command := 'UNSUBSCRIBE';
  Frame.Headers.Add('destination', Queue);
  SendFrame(Frame);
  Frame.Free;
end;

end.

