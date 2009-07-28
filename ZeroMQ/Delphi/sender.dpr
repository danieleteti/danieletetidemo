program sender;

{$APPTYPE CONSOLE}

uses
  SysUtils,
  ZMQ in 'lib\ZMQ.PAS';

var
  connection: Pointer;
  i, ex, data_size: Integer;
  id, amessage: AnsiString;
begin
  if ParamCount<>1 then
    id := AnsiString('#' + FormatDateTime('nn_zzz', now))
  else
    id := AnsiString(ParamStr(1));

  connection := zmq_create(pansichar(paramstr(2)));
  ex := zmq_create_exchange(connection, 'E', ZMQ_SCOPE_LOCAL, '', ZMQ_STYLE_DATA_DISTRIBUTION);
  zmq_bind(connection, 'E', 'MyQueue',nil,nil);
  i := 1;
  while True do
  begin
    amessage := AnsiString(Format('[%s] #%3.3d. Hello World' + #0,[id, i]));
    data_size := length(amessage);
    WriteLn('sending ',amessage);
    zmq_send(
      connection,
      ex,
      PAnsiChar(amessage),
      data_size + SizeOf(ansichar),
      0);
    sleep(1);
    inc(i);
  end;
end.
