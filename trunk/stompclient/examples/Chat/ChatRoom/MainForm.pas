unit MainForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ChatRoomThread;

type
  TForm4 = class(TForm, IListener)
    EditRoomName: TEdit;
    Label1: TLabel;
    Button1: TButton;
    Memo: TMemo;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    room: TChatRoomThread;
  public
    //IListener
    procedure Trace(const AMessage: AnsiString);
  end;

var
  Form4: TForm4;

implementation

{$R *.dfm}

procedure TForm4.Button1Click(Sender: TObject);
begin
  if room = nil then
  begin
    room := TChatRoomThread.Create(true);
    room.RoomName := EditRoomName.Text;
    room.Listener := self;
    room.Resume;
    Button1.Enabled := false;
    Button2.Visible := true;
  end;
end;

procedure TForm4.Button2Click(Sender: TObject);
begin
  room.Terminate;
  room.WaitFor;
  room.Free;
  room := nil;
  Button2.Visible := false;
  Button1.Enabled := true;
end;

procedure TForm4.FormCreate(Sender: TObject);
begin
  Button1.Enabled := true;
  Button2.Visible := false;
  EditRoomName.Text := 'ChatRoomName';
end;

procedure TForm4.Trace(const AMessage: AnsiString);
begin
  Memo.Lines.Add(AMessage);
end;

end.

