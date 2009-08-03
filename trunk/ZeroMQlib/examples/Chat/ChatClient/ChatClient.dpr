program ChatClient;

uses
  Forms,
  MainFormClient in 'MainFormClient.pas' {Form5},
  ZeroMQ in '..\..\..\ZeroMQ.pas',
  ZMQ in '..\..\..\ZMQ.PAS';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm5, Form5);
  Application.Run;
end.
