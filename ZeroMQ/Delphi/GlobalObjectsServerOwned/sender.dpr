program sender;

{$APPTYPE CONSOLE}

uses
  SysUtils,
  Ansistrings,
  ZMQ in '..\lib\ZMQ.PAS',
  ZeroMQ in '..\lib\ZeroMQ.pas';

var
  zmq: TZeroMQ;
  id, amessage: AnsiString;
  ex: TZeroExchange;
  i: integer;
begin
  if ParamCount<>1 then
    id := AnsiString('#' + FormatDateTime('nn_zzz', now))
  else
    id := AnsiString(ParamStr(1));

  zmq := TZeroMQ.Create;
  try
    ZMQ.Open('localhost');
    ex := zmq.CreateExchange('E', zmqScopeGlobal, '*', zmqStyleDataDistribution);
    i := 1;
    while True do
    begin
      amessage := AnsiString(Format('[%s] #%3.3d. Hello World' + #0,[id, i]));
      WriteLn('sending ',amessage);
      zmq.Send(ex,amessage, zmqNoBlocking);
      sleep(1);
      inc(i);
    end;
  finally
    zmq.Free;
  end;
end.
