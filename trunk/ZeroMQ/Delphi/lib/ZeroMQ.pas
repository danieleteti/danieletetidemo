unit ZeroMQ;

interface

uses
  ZMQ, SysUtils;



type
  TZeroMQScope = (
    zmqScopeLocal = 1,
    zmqScopeProcess = 2,
    zmqScopeGlobal = 3
    );
  TZeroMQStyle = (zmqStyleDataDistribution = 1, zmqStyleLoadBalancing = 2);
  TZeroExchange = Integer;
  TZeroQueueID = Cardinal;
  TZeroBlockingMode = (zmqBlocking = 1, zmqNoBlocking = 0);
  EZeroMQException = class(Exception)
  end;

  TZeroMQ = class(TInterfacedObject)
  protected
    FConnection: Pointer;
    FHost: AnsiString;
  public
    procedure Open(const Host: AnsiString);
    procedure Close;
    function CreateExchange(
      Exchange: ansistring;
      Scope: TZeroMQScope;
      Location: ansistring;
      Style: TZeroMQStyle): Integer;
    function CreateQueue(
      QueueName: ansistring;
      Scope: TZeroMQScope;
      Location: ansistring = ''): Integer;
    function CreateLocalQueue(QueueName: ansistring): Integer;
    procedure Bind(ExchangeName: ansistring;
                  QueueName: ansistring;
                  ExchangeOptions: ansistring = '';
                  QueueOptions: ansistring = '');
    function Send(Exchange: Integer;
                  Message: AnsiString;
                  Blocking: TZeroBlockingMode = zmqBlocking): Integer;
    function Receive(var Message: AnsiString;
                     var MessageType: Cardinal;
                     var MessageSize: Int64;
                     Blocking: TZeroBlockingMode = zmqBlocking): TZeroQueueID;
  end;

implementation

const
  ZMQ_NO_LIMIT = -1;
const
  ZMQ_NO_SWAP = 0;

{ TZeroMQ }

procedure TZeroMQ.Bind(ExchangeName: ansistring; QueueName: AnsiString;
                       ExchangeOptions: ansistring = ''; QueueOptions: ansistring = '');
begin
  zmq_bind(FConnection, PAnsiChar(ExchangeName), PAnsiChar(QueueName), PAnsiChar(ExchangeOptions), PAnsiChar(QueueOptions))
end;

procedure TZeroMQ.Close;
begin
  zmq_free(FConnection);
  FConnection := nil;
end;

function TZeroMQ.CreateExchange(Exchange: ansistring; Scope: TZeroMQScope;
  Location: ansistring; Style: TZeroMQStyle): Integer;
begin
  Result := zmq_create_exchange(
    FConnection, PAnsiChar(Exchange), Integer(Scope), PAnsiChar(Location), Integer(Style));
end;

function TZeroMQ.CreateLocalQueue(QueueName: ansistring): Integer;
begin
  Result := CreateQueue(QueueName, zmqScopeLocal,'');
end;

function TZeroMQ.CreateQueue(QueueName: ansistring; Scope: TZeroMQScope;
  Location: ansistring = ''): Integer;
begin
  Result := zmq_create_queue(FConnection, PAnsiChar(QueueName), Integer(Scope), PAnsiChar(Location), ZMQ_NO_LIMIT, ZMQ_NO_LIMIT, ZMQ_NO_SWAP);
end;

procedure TZeroMQ.Open(const Host: AnsiString);
begin
  FConnection := nil;
  FConnection := zmq_create(PAnsiChar(FHost));
  if FConnection = nil then
    raise EZeroMQException.Create('Cannot connect to ZeroMQ server');
end;

function TZeroMQ.Receive(var Message: AnsiString; var MessageType: Cardinal; var MessageSize: Int64; Blocking: TZeroBlockingMode = zmqBlocking): TZeroQueueID;
var
  res: Int64;
  data: PAnsiChar;
begin
  Message := '';
  data := nil;
  MessageSize := 0;
  res := zmq_receive(FConnection, data, MessageSize, MessageType, Integer(Blocking));
  if (res > 0) and (MessageSize > 0) then
    Message := data;
  zmq_free(data);
  Result := res;
end;

function TZeroMQ.Send(Exchange: Integer; Message: AnsiString;
  Blocking: TZeroBlockingMode = zmqBlocking): Integer;
var
  data_size: Int64;
begin
  data_size := length(Message);
  Result := zmq_send(
    FConnection,
    Exchange,
    PAnsiChar(Message + #0),
    data_size + SizeOf(ansichar),
    Integer(Blocking)
    );
end;

end.
