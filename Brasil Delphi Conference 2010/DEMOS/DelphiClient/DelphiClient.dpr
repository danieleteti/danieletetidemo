program DelphiClient;

uses
  Forms,
  MainForm in 'MainForm.pas' {Form3},
  ServiceClientClassesUnit in 'ServiceClientClassesUnit.pas',
  ServiceClientModuleUnit in 'ServiceClientModuleUnit.pas' {ClientModule1: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm3, Form3);
  Application.CreateForm(TClientModule1, ClientModule1);
  Application.Run;
end.
