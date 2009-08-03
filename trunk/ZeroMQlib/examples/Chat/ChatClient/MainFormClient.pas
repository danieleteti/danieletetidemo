unit MainFormClient;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ZeroMQ;

type
  TForm5 = class(TForm)
    Edit1: TEdit;
    Edit2: TEdit;
    Button1: TButton;
    Edit3: TEdit;
    Memo1: TMemo;
    Memo2: TMemo;
    Button2: TButton;
    tmr: TTimer;
    procedure Button1Click(Sender: TObject);
    procedure tmrTimer(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    zmq: TZeroMQ;
    roomname: string;
    ex: Integer;
  public
    { Public declarations }
  end;

var
  Form5: TForm5;

implementation


{$R *.dfm}

procedure TForm5.Button1Click(Sender: TObject);
begin
  if assigned(zmq) then
  begin
    tmr.Enabled := false;
    zmq.Free;
  end
  else
  begin
    roomname := Edit2.Text;
    zmq := TZeroMQ.Create;
    zmq.Open(Edit1.Text);

    //Setup for reading messages
    zmq.CreateLocalQueue('Q_read');
    zmq.Bind('E_' + roomname, 'Q_read');

    //Setup for sending messages
    ex := zmq.CreateLocalExchange('LocalE', zmqStyleDataDistribution);
    zmq.Bind('LocalE','Q_' + roomname);
    tmr.Enabled := true;
  end;
end;

procedure TForm5.Button2Click(Sender: TObject);
begin
  zmq.Send(ex, '[' + Edit3.Text + '] say...' + sLineBreak + Memo2.Lines.Text, zmqBlocking);
end;

procedure TForm5.tmrTimer(Sender: TObject);
var
  msg: AnsiString;
  mt: Cardinal;
  ms: Int64;
begin
  if zmq.Receive(msg, mt, ms, zmqBlocking) > 0 then
    Memo1.Lines.Add(msg);
end;

end.
