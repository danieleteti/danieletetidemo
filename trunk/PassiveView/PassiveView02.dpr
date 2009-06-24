program PassiveView02;

uses
  Forms,
  MainView in 'view\MainView.pas' {Form1},
  model.SpeakerMapper in 'model\model.SpeakerMapper.pas',
  presenter.Main in 'presenter\presenter.Main.pas',
  model.common in 'model\model.common.pas',
  view.common in 'view\view.common.pas',
  model.Speaker in 'model\model.Speaker.pas',
  SQLite3 in 'model\sqlite\lib\SQLite3.pas',
  sqlite3udf in 'model\sqlite\lib\sqlite3udf.pas',
  SQLiteTable3 in 'model\sqlite\lib\SQLiteTable3.pas',
  model.persistence.factory in 'model\model.persistence.factory.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
