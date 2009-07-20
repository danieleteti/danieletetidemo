program receiver;

{$APPTYPE CONSOLE}

uses
  SysUtils,
  {$IFDEF VER190}
  Ansistrings,
  {$ENDIF}
  ZMQ in 'ZMQ.PAS';

var
  connection: Pointer;
  data_size: Int64;
  data: PAnsiChar;
  atype: Cardinal;
begin
  connection := zmq_create('localhost');
  zmq_create_queue(connection,'MyQueue', ZMQ_SCOPE_GLOBAL, '*', ZMQ_NO_LIMIT, ZMQ_NO_LIMIT, ZMQ_NO_SWAP);
  //zmq_bind(connection, 'E', 'MyQueue', '','');
  while True do
  begin
    data := nil;
    data_size := 0;
    zmq_receive(connection,data,data_size,atype, 1);
    WriteLn('Readed: ' , pansichar(data), ' with data size: ',data_size);
    zmq_free(data);
    sleep(1);
  end;
end.
