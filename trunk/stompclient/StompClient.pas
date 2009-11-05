{ ******************************************************* }
{ }
{ Stomp Client for Embarcadero Delphi }
{ Tested With ApacheMQ 5.2 }
{ Copyright (c) 2009-2009 Daniele Teti }
{ }
{ }
{ WebSite: www.danieleteti.it }
{ email:d.teti@bittime.it }
{ ******************************************************* }

unit StompClient;

interface

uses
  StompTypes,
  IdTCPClient,
  SysUtils,
  IdException,
  IdExceptionCore,
  Classes;

type
  TStompClient = class
  private
    tcp: TIdTCPClient;
    FHeaders: IStompHeaders;
    FPassword: string;
    FUserName: string;
    FTimeout: Integer;
    FSession: string;
    FInTransaction: Boolean;
    FTransactions: TStringList;
    FClientID: string;
    FReceiptTimeout: Integer;
    procedure SetPassword(const Value: string);
    procedure SetUserName(const Value: string);
    procedure SetTimeout(const Value: Integer);
    procedure SetClientID(const Value: string);
    procedure SetReceiptTimeout(const Value: Integer);

  protected
    procedure MergeHeaders(var AFrame: TStompFrame; var AHeaders: IStompHeaders);
    procedure SendFrame(AFrame: TStompFrame);
//    procedure CheckReceipt(Frame: TStompFrame);

  public
    function Receive: TStompFrame; overload;
    function Receive(ATimeout: Integer): TStompFrame; overload;
    procedure Receipt(const ReceiptID: string);
    procedure Connect(Host: string; Port: Integer = 61613);
    procedure Disconnect;
    procedure Subscribe(QueueOrTopicName: string; Ack: TAckMode = amAuto; Headers: IStompHeaders = nil);
    procedure Unsubscribe(Queue: string);
    procedure Send(QueueOrTopicName: string; TextMessage: string; Headers: IStompHeaders = nil); overload;
    procedure Send(QueueOrTopicName: string; TextMessage: string; TransactionIdentifier: string; Headers: IStompHeaders = nil);
      overload;
    procedure Ack(const MessageID: string; const TransactionIdentifier: string = '');
    procedure BeginTransaction(const TransactionIdentifier: string);
    procedure CommitTransaction(const TransactionIdentifier: string);
    procedure AbortTransaction(const TransactionIdentifier: string);
    /// ////////////
    function InTransaction: Boolean;
    constructor Create;
    destructor Destroy; override;
    function Connected: Boolean;
    property UserName: string read FUserName write SetUserName;
    property Password: string read FPassword write SetPassword;
    property ClientID: string read FClientID write SetClientID;
    property Timeout: Integer read FTimeout write SetTimeout;
    property Session: string read FSession;
    property ReceiptTimeout: Integer read FReceiptTimeout write SetReceiptTimeout;
    property Transactions: TStringList read FTransactions;
  end;

implementation

uses
  Windows,
  IdGlobal,
  Character;

{ TStompClient }

procedure TStompClient.AbortTransaction(const TransactionIdentifier: string);
var
  Frame: TStompFrame;
begin
  if FTransactions.IndexOf(TransactionIdentifier) > -1 then
  begin
    Frame := TStompFrame.Create;
    try
      Frame.Command := 'ABORT';
      Frame.Headers.Add('transaction', TransactionIdentifier);
      SendFrame(Frame);
      FInTransaction := False;
    finally
      Frame.Free;
    end;
    FTransactions.Delete(FTransactions.IndexOf(TransactionIdentifier));
  end
  else
    raise EStomp.CreateFmt('Abort Transaction Error. Transaction [%s] not found', [TransactionIdentifier]);
end;

procedure TStompClient.Ack(const MessageID: string; const TransactionIdentifier: string);
var
  Frame: TStompFrame;
begin
  Frame := TStompFrame.Create;
  try
    Frame.Command := 'ACK';
    Frame.Headers.Add('message-id', MessageID);
    if TransactionIdentifier <> '' then
      Frame.Headers.Add('transaction', TransactionIdentifier);
    //CheckReceipt(Frame);
    SendFrame(Frame);
  finally
    Frame.Free;
  end;
end;

procedure TStompClient.BeginTransaction(const TransactionIdentifier: string);
var
  Frame: TStompFrame;
begin
  if FTransactions.IndexOf(TransactionIdentifier) = -1 then
  begin
    Frame := TStompFrame.Create;
    try
      Frame.Command := 'BEGIN';
      Frame.Headers.Add('transaction', TransactionIdentifier);
      SendFrame(Frame);
      //CheckReceipt(Frame);
      FInTransaction := True;
    finally
      Frame.Free;
    end;
    FTransactions.Add(TransactionIdentifier);
  end
  else
    raise EStomp.CreateFmt('Begin Transaction Error. Transaction [%s] still open', [TransactionIdentifier]);
end;

//procedure TStompClient.CheckReceipt(Frame: TStompFrame);
//var
//  ReceiptID: string;
//begin
//  if FEnableReceipts then
//  begin
//    ReceiptID := inttostr(GetTickCount);
//    Frame.Headers.Add('receipt', ReceiptID);
//    SendFrame(Frame);
//    Receipt(ReceiptID);
//  end
//  else
//    SendFrame(Frame);
//end;

procedure TStompClient.CommitTransaction(const TransactionIdentifier: string);
var
  Frame: TStompFrame;
begin
  if FTransactions.IndexOf(TransactionIdentifier) > -1 then
  begin
    Frame := TStompFrame.Create;
    try
      Frame.Command := 'COMMIT';
      Frame.Headers.Add('transaction', TransactionIdentifier);
      SendFrame(Frame);
      //CheckReceipt(Frame);
      FInTransaction := False;
    finally
      Frame.Free;
    end;
    FTransactions.Delete(FTransactions.IndexOf(TransactionIdentifier));
  end
  else
    raise EStomp.CreateFmt('Commit Transaction Error. Transaction [%s] not found', [TransactionIdentifier]);
end;

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
    if FClientID <> '' then
      Frame.Headers.Add('client-id', FClientID);
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
      FSession := Frame.Headers.Value('session');
    end;
    { todo: 'Call event?' }
  except
    on E: Exception do
    begin
      raise EStomp.Create(E.Message);
    end;
  end;
end;

function TStompClient.Connected: Boolean;
begin
  Result := tcp.Connected;
end;

constructor TStompClient.Create;
begin
  inherited;
  FTransactions := TStringList.Create;
//  FEnableReceipts := False;
  FInTransaction := False;
  FSession := '';
  FUserName := 'guest';
  FPassword := 'guest';
  FHeaders := TStompHeaders.Create;
  tcp := TIdTCPClient.Create(nil);
  FTimeout := 200;
  FReceiptTimeout := FTimeout;
end;

destructor TStompClient.Destroy;
begin
  tcp.Free;
  FTransactions.Free;
  inherited;
end;

procedure TStompClient.Disconnect;
var
  Frame: TStompFrame;
begin
  if Connected then
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
end;

function TStompClient.InTransaction: Boolean;
begin
  Result := FInTransaction;
end;

procedure TStompClient.MergeHeaders(var AFrame: TStompFrame; var AHeaders: IStompHeaders);
var
  i: Integer;
  h: TKeyValue;
begin
  if Assigned(AHeaders) then
    if AHeaders.Count > 0 then
      for i := 0 to AHeaders.Count - 1 do
      begin
        h := AHeaders.GetAt(i);
        AFrame.Headers.Add(h.Key, h.Value);
      end;
end;

procedure TStompClient.Receipt(const ReceiptID: string);
var
  Frame: TStompFrame;
begin
  Frame := Receive(FReceiptTimeout);
  try
    if Assigned(Frame) then
    begin
      if Frame.Command <> 'RECEIPT' then
        raise EStomp.Create('Receipt command error');
      if Frame.Headers.Value('receipt-id') <> ReceiptID then
        raise EStomp.Create('Receipt receipt-id error');
    end;
  finally
    if Assigned(Frame) then
      Frame.Free;
  end;
end;

function TStompClient.Receive(ATimeout: Integer): TStompFrame;
var
  s: string;
  c: Char;
  sb: TStringBuilder;
  tout: Boolean;
begin
  tout := False;
  Result := nil;
  try
    sb := TStringBuilder.Create(1024);
    try
      tcp.ReadTimeout := ATimeout;
      try
        tcp.IOHandler.CheckForDataOnSource(1);
        while True do
        begin
          c := tcp.IOHandler.ReadChar;
          if c <> CHAR0 then
            sb.Append(c)
          else
          begin
            tcp.IOHandler.ReadChar;
            Break;
          end;
        end;
      except
        on E: EIdReadTimeout do
        begin
          tout := True;
        end;
        on E: Exception do
        begin
          raise ;
        end;
      end;
      if not tout then
        Result := StompUtils.CreateFrame(sb.ToString + #0);
    finally
      sb.Free;
    end;
  except
    on E: Exception do
    begin
      raise ;
    end;
  end;
end;

function TStompClient.Receive: TStompFrame;
begin
  Result := Receive(FTimeout);
end;

procedure TStompClient.Send(QueueOrTopicName: string; TextMessage: string; Headers: IStompHeaders);
var
  Frame: TStompFrame;
begin
  Frame := TStompFrame.Create;
  try
    Frame.Command := 'SEND';
    Frame.Headers.Add('destination', QueueOrTopicName);
    Frame.Body := TextMessage;
    MergeHeaders(Frame, Headers);
    SendFrame(Frame);
    //CheckReceipt(Frame);
  finally
    Frame.Free;
  end;
end;

procedure TStompClient.Send(QueueOrTopicName: string; TextMessage: string; TransactionIdentifier: string; Headers: IStompHeaders);
var
  Frame: TStompFrame;
begin
  Frame := TStompFrame.Create;
  try
    Frame.Command := 'SEND';
    Frame.Headers.Add('destination', QueueOrTopicName);
    Frame.Headers.Add('transaction', TransactionIdentifier);
    Frame.Body := TextMessage;
    MergeHeaders(Frame, Headers);
    SendFrame(Frame);
    //CheckReceipt(Frame);
  finally
    Frame.Free;
  end;
end;

procedure TStompClient.SendFrame(AFrame: TStompFrame);
begin
  tcp.IOHandler.Write(TEncoding.ASCII.GetBytes(AFrame.output));
end;

procedure TStompClient.SetClientID(const Value: string);
begin
  FClientID := Value;
end;

procedure TStompClient.SetPassword(const Value: string);
begin
  FPassword := Value;
end;

procedure TStompClient.SetReceiptTimeout(const Value: Integer);
begin
  FReceiptTimeout := Value;
end;

procedure TStompClient.SetTimeout(const Value: Integer);
begin
  FTimeout := Value;
end;

procedure TStompClient.SetUserName(const Value: string);
begin
  FUserName := Value;
end;

procedure TStompClient.Subscribe(QueueOrTopicName: string; Ack: TAckMode = amAuto; Headers: IStompHeaders = nil);
var
  Frame: TStompFrame;
begin
  Frame := TStompFrame.Create;
  try
    Frame.Command := 'SUBSCRIBE';
    Frame.Headers.Add('destination', QueueOrTopicName);
    Frame.Headers.Add('ack', StompUtils.AckModeToStr(Ack));
    if Headers <> nil then
      MergeHeaders(Frame, Headers);
    SendFrame(Frame);
    //CheckReceipt(Frame);
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
