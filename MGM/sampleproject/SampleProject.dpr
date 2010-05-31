program SampleProject;

uses
  Forms,
  MainForm in 'MainForm.pas' {frmMain},
  bo in 'BO\bo.pas',
  MGM in '..\lib\MGM.pas',
  MGM.ListMediator in '..\lib\MGM.ListMediator.pas',
  MGM.LabelMediator in '..\lib\MGM.LabelMediator.pas',
  MGM.EditMediator in '..\lib\MGM.EditMediator.pas',
  PersonaEditForm in 'PersonaEditForm.pas' {frmPersoneEdit};

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown := True;
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
