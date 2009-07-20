program sender;

{$APPTYPE CONSOLE}

uses
  SysUtils,
  {$IFDEF VER190}
  Ansistrings,
  {$ENDIF}
  ZMQ in 'ZMQ.PAS';

var
  connection: Pointer;
  i, ex, data_size: Integer;
  id, amessage: string;
begin
  if ParamCount<>1 then
    exit;
  id := ParamStr(1);

  connection := zmq_create('localhost');
  ex := zmq_create_exchange(connection, 'E', ZMQ_SCOPE_LOCAL, '', ZMQ_STYLE_DATA_DISTRIBUTION);
  zmq_bind(connection, 'E', 'MyQueue',nil,nil);
  i := 1;
  while True do
  begin
    amessage := Format('[%s] #%3.3d. Hello World'#0,[id, i]);
    data_size := length(amessage);
    WriteLn('sending ',amessage);
    zmq_send(connection,ex,PAnsiChar(amessage),data_size + 1,0);
    sleep(1);
    inc(i);
  end;
end.
