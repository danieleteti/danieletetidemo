unit MainU;

interface

procedure Main;

implementation

uses
  SysUtils,
  dateutils, StompClient, StompTypes, StopWatch;

procedure Main;
var
  stomp: TStompClient;
  frame: TStompFrame;
  i, c: Integer;
  msgcount: Cardinal;
  start, endt: TDateTime;
  ms: Int64;
  sw: TStopWatch;
const
  MSG = 1000;  
begin
  sw := TStopWatch.Create;
  try
    stomp := TStompClient.Create;
    try
      stomp.UserName := 'Daniele';
      stomp.Password := 'Paperino';
      stomp.Connect('10.5.2.25');
      stomp.Subscribe('/queue/p');

      for c := 1 to 10 do
      begin
        WriteLn(#13#10'LOOP: ', c);
        for i := 1 to MSG do
        begin
          stomp.send('/queue/p',
            StringOfChar('X', 10000)
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
//            Assert(Length(trim(Frame.Body)) = 10000, 'Length = ' + inttostr(Length(Frame.Body)));
//            if msgcount mod (MSG div 10) = 0 then
//              WriteLn('Readed ', msgcount, ' of ', MSG, ' messages');

            Frame.Free;
          end
          else
            Sleep(200);
        end;
        sw.Stop;
        Writeln(msgcount, ' in ', sw.ElapsedMiliseconds, ' milliseconds and ', sw.ElapsedTicks, ' ticks');
        WriteLn(FormatFloat('###,##0.000', msgcount / sw.ElapsedMiliseconds), ' msg/ms');
      end;

      write('test finished...');
      stomp.Unsubscribe('/queue/p');      
      readln;
    finally
      stomp.Free;
    end;
  finally
    sw.Free;
  end;
end;

end.

