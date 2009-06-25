program PassiveView02Tests;
{

  Delphi DUnit Test Project
  -------------------------
  This project contains the DUnit test framework and the GUI/Console test runners.
  Add "CONSOLE_TESTRUNNER" to the conditional defines entry in the project options 
  to use the console test runner.  Otherwise the GUI test runner will be used by 
  default.

}

{$IFDEF CONSOLE_TESTRUNNER}
{$APPTYPE CONSOLE}
{$ENDIF}

uses
  Forms,
  TestFramework,
  GUITestRunner,
  TextTestRunner,
  model.Speaker in '..\model\model.Speaker.pas',
  TestSpeakerMapper in 'TestSpeakerMapper.pas',
  model.common in '..\model\model.common.pas',
  model.SpeakerMapper in '..\model\model.SpeakerMapper.pas',
  model.persistence.factory in '..\model\model.persistence.factory.pas',
  model.guidcreator in '..\model\model.guidcreator.pas';

{$R *.RES}

begin
  ReportMemoryLeaksOnShutdown := True;
  TDBFactory.ConnectionString := 'data.db';
  Application.Initialize;
  if IsConsole then
    TextTestRunner.RunRegisteredTests
  else
    GUITestRunner.RunRegisteredTests;
end.

