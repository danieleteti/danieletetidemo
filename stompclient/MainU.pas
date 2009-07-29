unit MainU;

interface

procedure Main(serveraddress: string = 'localhost');

implementation

uses
  SysUtils,
  dateutils,
  StompClient,
  StompTypes,
  StopWatch;

procedure Main(serveraddress: string = 'localhost');
var
  stomp: TStompClient;
  frame: TStompFrame;
  i, c: Integer;
  msgcount: Cardinal;
  sw: TStopWatch;
  message_data: string;
const
  MSG = 10000;
  MSG_SIZE = 100000;
begin
  message_data := StringOfChar('X', MSG_SIZE);
  WriteLn('TESTs MESSAGE (', length(message_data), ' bytes):', #13#10, '"',
    message_data, '"'#13#10#13#10);
  sw := TStopWatch.Create;
  try
    stomp := TStompClient.Create;
    try
      stomp.UserName := 'Daniele';
      stomp.Password := 'Paperino';
      stomp.Connect(serveraddress);
      stomp.Subscribe('/queue/p');

      for c := 1 to 10 do
      begin
        WriteLn;
        WriteLn('= STATS LOOP ', c, '=======================================');
        for i := 1 to MSG do
        begin
          stomp.send('/queue/p',
            message_data
            //'01234567890123456789012345678901234567890123456789'
            );
          if i mod 1000 = 0 then
            WriteLn('Queued ', i, ' messages');
        end;

        msgcount := 0;
        sw.start;
        while msgcount < MSG do
        begin
          frame := stomp.Receive;
          if assigned(Frame) then
          begin
            inc(msgcount);
            Frame.Free;
          end
        end;
        sw.Stop;
        Writeln(msgcount, ' in ', sw.ElapsedMiliseconds, ' milliseconds and ',
          sw.ElapsedTicks, ' ticks');
        Writeln('Throughput: ');
        WriteLn(FormatFloat('###,##0.000', sw.ElapsedMiliseconds / msgcount),
          ' ms/msg');
        WriteLn(FormatFloat('###,##0.000', msgcount / sw.ElapsedMiliseconds),
          ' msg/ms');
        WriteLn('= END LOOP ', c,
          '========================================='#13#10);
      end;

      stomp.Unsubscribe('/queue/p');
      write('test finished...');
    finally
      stomp.Free;
    end;
  finally
    sw.Free;
  end;
end;

end.

