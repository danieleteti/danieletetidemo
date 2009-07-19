program sender;

{$APPTYPE CONSOLE}

uses
  SysUtils,
  Ansistrings,
  ZMQ in 'ZMQ.PAS';

var
  connection: Pointer;
  i, ex, data_size: Integer;
  data: PAnsiChar;
begin
  connection := zmq_create('192.168.2.5:5672');
  ex := zmq_create_exchange(connection, 'E', ZMQ_SCOPE_GLOBAL, '*', ZMQ_STYLE_DATA_DISTRIBUTION);
  i := 0;
  while True do
  begin
    data := AnsiStrAlloc(10);
    StrCopy(data,'ciaos' + #0);
    data_size := StrLen(data);
    WriteLn('sending ',data);
    zmq_send(connection,ex,data,data_size,0);
    StrDispose(data);
    sleep(1000);
    inc(i);
  end;
end.
