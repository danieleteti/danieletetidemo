program receiver;

{$APPTYPE CONSOLE}

uses
  SysUtils,
  Ansistrings,
  ZMQ in '..\lib\ZMQ.PAS',
  ZeroMQ in '..\lib\ZeroMQ.pas';

var
  MessageType: Cardinal;
  MessageSize: Int64;
  zmq: TZeroMQ;
  Message: AnsiString;
begin
  zmq := TZeroMQ.Create;
  try
    zmq.Open('localhost');
    zmq.CreateLocalQueue('MyLocalQueue');
    zmq.Bind('E','MyLocalQueue');
    while True do
    begin
      if zmq.Receive(Message, MessageType, MessageSize, zmqNoBlocking) then
        WriteLn('Message: ', Message, ' - Message Data Size: ', MessageSize);
      sleep(1);
    end;
  finally
    zmq.Free;
  end;
end.
