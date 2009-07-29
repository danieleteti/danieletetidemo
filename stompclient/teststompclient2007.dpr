program teststompclient2007;

{$APPTYPE CONSOLE}

uses
  StompTypes in 'StompTypes.pas',
  StompClient in 'StompClient.pas',
  MainU in 'MainU.pas',
  SysUtils,
  StopWatch in 'StopWatch.pas';

begin
  try
    Main;
  except
    on E: Exception do
      Writeln(E.Classname, ': ', E.Message);
  end;
end.

