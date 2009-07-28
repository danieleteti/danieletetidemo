program teststompclient;

{$APPTYPE CONSOLE}

uses
  SysUtils,
  dateutils,
  StompTypes in 'StompTypes.pas',
  StompClient in 'StompClient.pas';

var
  stomp: TStompClient;
  frame: TStompFrame;
  i,c: Integer;
  msgcount: Cardinal;
  start, endt: TDateTime;
begin
  try
    stomp := TStompClient.Create;
    try
      stomp.UserName := 'Daniele';
      stomp.Password := 'Paperino';
      stomp.Connect('localhost');
      stomp.Subscribe('/queue/p');


      for c := 1 to 10 do
      begin
        WriteLn('LOOP: ', c);
        for i := 1 to 5000 do
        begin
          stomp.send('/queue/p',
            StringOfChar('X', 10000)
            //'01234567890123456789012345678901234567890123456789'
            );
          if i mod 1000 = 0 then
            WriteLn('Queued ',i,' messages');
        end;

        msgcount := 0;
        start := now;
        while true do
        begin
          frame := stomp.Receive;
          if assigned(Frame) then
          begin
            inc(msgcount);
            //WriteLn(Frame.Output);
            Frame.Free;
          end
          else
            Break;
        end;
        endt := now;
        Writeln(msgcount, ' in ', FormatDateTime('nn:ss:zzz', endt-start));
        WriteLn(FormatFloat('##0.00', msgcount / MilliSecondsBetween(endt, start)), ' per millisecondo');
      end;

      readln;
    finally
      stomp.Free;
    end;
  except
    on E: Exception do
      Writeln(E.Classname, ': ', E.Message);
  end;
end.

