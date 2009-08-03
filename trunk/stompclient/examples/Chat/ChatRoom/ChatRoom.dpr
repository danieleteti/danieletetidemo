program ChatRoom;

uses
  Forms,
  MainForm in 'MainForm.pas' {Form4},
  ZeroMQ in '..\..\..\ZeroMQ.pas',
  ZMQ in '..\..\..\ZMQ.PAS',
  ChatRoomThread in 'ChatRoomThread.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm4, Form4);
  Application.Run;
end.
