program receiver;

{$APPTYPE CONSOLE}

uses
  SysUtils,
  Ansistrings,
  ZMQ in 'ZMQ.PAS';

var
  connection: Pointer;
  data_size: Int64;
  data: PAnsiChar;
  atype: Cardinal;
begin
  connection := zmq_create('192.168.2.5:5672');
  zmq_create_queue(connection,'MyQueue', ZMQ_SCOPE_LOCAL, '*', ZMQ_NO_LIMIT, ZMQ_NO_LIMIT, ZMQ_NO_SWAP);
  zmq_bind(connection, 'E', 'MyQueue', '','');
  while True do
  begin
    data := nil;
    data_size := 0;
    zmq_receive(connection,data,data_size,atype, 0);
    WriteLn('Readed: ' , data, ' with data size: ',data_size);
    if data_size > 0 then
      StrDispose(data);
    sleep(1000);
  end;
end.
