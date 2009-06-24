program PassiveView02;

uses
  Forms,
  MainView in 'view\MainView.pas' {Form1},
  model.SpeakerMapper in 'model\model.SpeakerMapper.pas',
  presenter.Main in 'presenter\presenter.Main.pas',
  model.common in 'model\model.common.pas',
  view.common in 'view\view.common.pas',
  model.Speaker in 'model\model.Speaker.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
