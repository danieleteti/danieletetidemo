program teststompclient;

{$APPTYPE CONSOLE}

uses
  SysUtils,
  StompTypes in 'StompTypes.pas',
  StompClient in 'StompClient.pas';

var
  stomp: TStompClient;
begin
  try
    stomp := TStompClient.Create;
    try
      stomp.UserName := 'Daniele';
      stomp.Password := 'Paperino';
      stomp.Connect('localhost');
      readln;
    finally
      stomp.Free;
    end;
  except
    on E: Exception do
      Writeln(E.Classname, ': ', E.Message);
  end;
end.

