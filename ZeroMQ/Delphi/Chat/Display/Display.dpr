program Display;

{$APPTYPE CONSOLE}

uses
  SysUtils,
  ZeroMQ in '..\..\lib\ZeroMQ.pas',
  ZMQ in '..\..\lib\ZMQ.PAS';

var
  zmq: TZeroMQ;
  ex: TZeroExchange;
  cmd: string;
  msg: AnsiString;
  msgtype: Cardinal;
  msgsize: Int64;
begin
  try
    zmq := TZeroMQ.Create;
    try
      zmq.Open(ParamStr(1));
      ex := zmq.CreateLocalQueue('LocalQ');
      zmq.Bind('E_chat', 'LocalQ');
      while cmd <> '!quit' do
      begin
        zmq.Receive(msg, msgtype, msgsize);
        WriteLn(DateTimeToStr(now), ' ', msg);
      end;
    finally
      zmq.Free;
    end;
  except
    on E:Exception do
      Writeln(E.Classname, ': ', E.Message);
  end;
end.

