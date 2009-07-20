program chatroom;

{$APPTYPE CONSOLE}

uses
  SysUtils,
  ZeroMQ in '..\..\lib\ZeroMQ.pas',
  ZMQ in '..\..\lib\ZMQ.PAS';

var
  zmq: TZeroMQ;
  msg: AnsiString;
  msgtype: Cardinal;
  msgsize: Int64;
  ex: integer;
begin
  try
    zmq := TZeroMQ.Create;
    try
      zmq.Open('localhost');
      ex := zmq.CreateExchange('E_chat', zmqScopeGlobal, '*', zmqStyleDataDistribution);
      zmq.CreateQueue('Q_chat', zmqScopeGlobal, '*');
      WriteLn('ChatRoom running...');
      while true do
      begin
        ZMQ.Receive(msg, msgtype, msgsize);
        WriteLn('--> ',msg);
        ZMQ.Send(ex,msg);
      end;
    finally
      zmq.Free;
    end;
  except
    on E:Exception do
      Writeln(E.Classname, ': ', E.Message);
  end;
end.
