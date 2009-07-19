program Project3;

{$APPTYPE CONSOLE}

uses
  SysUtils,
  ZMQ in 'ZMQ.PAS';

var
  _object,_object2, data: Pointer;
  message, xx: PAnsiChar;
  message_size: Int64;
  eid, eid2, qid: Integer;
  outtype: UINT32_T;
begin
  try
    //Setup reader
    _object := zmq_create('localhost:5682');
    eid := zmq_create_queue(_object, 'Q', ZMQ_SCOPE_GLOBAL, '*', ZMQ_NO_LIMIT,ZMQ_NO_LIMIT,ZMQ_NO_LIMIT);
    //zmq_receive(_object,Pointer(data),message_size,outtype,0);

    //Setup writer
    _object2 := zmq_create('localhost:5682');
    eid2 := zmq_create_exchange (_object2, 'E', ZMQ_SCOPE_LOCAL, '*', ZMQ_STYLE_DATA_DISTRIBUTION);
    zmq_bind(_object2,'E','Q','','');

    message_size := 4;
    message := GetMemory(message_size+1);
    StrCopy(message, 'ciao' + #0);

    data := nil;
    //zmq_send(_object2,eid2,message, message_size,1);
    zmq_receive(_object,data,message_size,outtype,1);
    xx := pansichar(data);
    WriteLn('Memoria liberata', xx);
  except
    on E:Exception do
      Writeln(e.Message);
  end;
  Write('Reading...');
  readln;
end.
