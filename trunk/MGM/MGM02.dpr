program MGM02;

uses
  Forms,
  MainForm in 'MainForm.pas' {Form1},
  MGM in 'lib\MGM.pas',
  MGM.EditMediator in 'lib\MGM.EditMediator.pas',
  PersonU in 'PersonU.pas',
  MGM.LabelMediator in 'lib\MGM.LabelMediator.pas',
  MGM.ListMediator in 'lib\MGM.ListMediator.pas';

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown := True;
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
