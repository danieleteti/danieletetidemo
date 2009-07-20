program receiver;

{$APPTYPE CONSOLE}

uses
  SysUtils,
  {$IFDEF VER200}
  Ansistrings,
  {$ENDIF}
  ZMQ in '..\lib\ZMQ.PAS';

var
  connection: Pointer;
  data_size: Int64;
  data: PAnsiChar;
  atype: Cardinal;
  rcv: integer;
begin
  connection := zmq_create('localhost');
  zmq_create_queue(connection,'MyQueue', ZMQ_SCOPE_LOCAL, '*', ZMQ_NO_LIMIT, ZMQ_NO_LIMIT, ZMQ_NO_SWAP);
  zmq_bind(connection, 'E', 'MyQueue',nil,nil);
  while True do
  begin
    data := nil;
    data_size := 0;
    rcv := zmq_receive(connection,data,data_size,atype, 0);
    if rcv > 0 then
    begin
      WriteLn('Readed: ' , PAnsiChar(data), ' with data size: ',data_size);
    end;
    zmq_free(data);
    sleep(1);
  end;
end.
