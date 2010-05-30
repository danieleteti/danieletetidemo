program SampleProject;

uses
  Forms,
  MainForm in 'MainForm.pas' {Form2},
  bo in 'BO\bo.pas',
  MGM in '..\lib\MGM.pas',
  MGM.ListMediator in '..\lib\MGM.ListMediator.pas',
  MGM.LabelMediator in '..\lib\MGM.LabelMediator.pas',
  MGM.EditMediator in '..\lib\MGM.EditMediator.pas',
  PersonaEditForm in 'PersonaEditForm.pas' {frmPersoneEdit},
  func in '..\lib\func.pas';

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown := True;
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
