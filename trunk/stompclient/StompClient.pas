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
    procedure Send(AFrame: TStompFrame);
    function Receive: TStompFrame;
  public
    procedure Connect(Host: String; Port: Integer = 61613);
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
  Send(Frame);
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
  FTimeout := 500;
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
  s := tcp.IOHandler.ReadLn(COMMAND_END, FTimeout);
  if s <> '' then
    Result := CreateFrame(s)
  else
    Result := nil;
end;

procedure TStompClient.Send(AFrame: TStompFrame);
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

end.

