unit ChatRoomThread;

interface

uses
  Classes, ZeroMQ;

type
  IListener = interface
    procedure Trace(const AMessage: AnsiString);
  end;


  TChatRoomThread = class(TThread)
  private
    FActualMessage: AnsiString;
    FRoomName: AnsiString;
    FListener: IListener;
    procedure SetRoomName(const Value: AnsiString);
    procedure SetListener(const Value: IListener);
    { Private declarations }
  protected
    procedure Execute; override;
    procedure SendMessage; //syncronized
  public
    property RoomName: AnsiString read FRoomName write SetRoomName;
    property Listener: IListener read FListener write SetListener;
  end;

implementation

uses
  SysUtils;

{ Important: Methods and properties of objects in visual components can only be
  used in a method called using Synchronize, for example,

      Synchronize(UpdateCaption);

  and UpdateCaption could look like,

    procedure TChatRoomThread.UpdateCaption;
    begin
      Form1.Caption := 'Updated in a thread';
    end; }

{ TChatRoomThread }

procedure TChatRoomThread.Execute;
var
  zmq: TZeroMQ;
  ex: Integer;
  r: TZeroQueueID;
  mt: Cardinal;
  ms: Int64;
begin
  zmq := TZeroMQ.Create;
  zmq.Open('localhost');
  try
    ex := zmq.CreateExchange('E_' + FRoomName, zmqScopeGlobal, ALL_INTERFACES, zmqStyleDataDistribution);
    zmq.CreateQueue('Q_' + FRoomName, zmqScopeGlobal, ALL_INTERFACES);
    while not terminated do
    begin
      r := zmq.Receive(FActualMessage, mt, ms, zmqNoBlocking);
      if r > 0 then
      begin
        zmq.Send(ex,FActualMessage,zmqNoBlocking);
        if assigned(FListener) then
          Synchronize(SendMessage);
      end
      else
        Sleep(10);
    end;
  finally
    zmq.Free;
  end;
end;

procedure TChatRoomThread.SendMessage;
begin
  FListener.Trace(FActualMessage);
end;

procedure TChatRoomThread.SetListener(const Value: IListener);
begin
  FListener := Value;
end;

procedure TChatRoomThread.SetRoomName(const Value: AnsiString);
begin
  FRoomName := Value;
end;

end.
