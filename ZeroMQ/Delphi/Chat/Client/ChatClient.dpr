program ChatClient;

{$APPTYPE CONSOLE}

uses
  SysUtils,
  ZeroMQ in '..\..\lib\ZeroMQ.pas',
  ZMQ in '..\..\lib\ZMQ.PAS';

var
  zmq: TZeroMQ;
  ex: TZeroMQExchange;
  cmd, usr: string;
  x: Integer;
begin
  try
    zmq := TZeroMQ.Create;
    try
      usr := ParamStr(2);
      zmq.Open(ParamStr(1));
      ex := zmq.CreateExchange('Ex', zmqScopeLocal, '', zmqStyleDataDistribution);
      zmq.Bind('Ex', 'Q_chat');
      cmd := 'User ' + usr + ' connected';
      WriteLn('!quit to exit from chat');
      while cmd <> '!quit' do
      begin
        x := zmq.Send(ex, usr + ': ' + cmd);
        writeln('X=',x);
        Readln(cmd);
      end;
      zmq.Send(ex, 'User disconnected');
    finally
      zmq.Free;
    end;
  except
    on E:Exception do
      Writeln(E.Classname, ': ', E.Message);
  end;
end.
