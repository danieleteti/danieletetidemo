unit ServerContainerUnit;

interface

uses
  SysUtils, Classes, 
  DSHTTPCommon, DSHTTP,
  DSServer, DSCommonServer, DSAuth; 

type
  TServerContainer = class(TDataModule)
    DSServer1: TDSServer;
    DSHTTPService1: TDSHTTPService;
    DSServerClass1: TDSServerClass;
    procedure DSServerClass1GetClass(DSServerClass: TDSServerClass;
      var PersistentClass: TPersistentClass);
  private
    { Private declarations }
  public
  end;

procedure RunDSServer;

implementation

uses Windows, serviceResourceUnit, strutils;

{$R *.dfm}

procedure TServerContainer.DSServerClass1GetClass(
  DSServerClass: TDSServerClass; var PersistentClass: TPersistentClass);
begin
  PersistentClass := serviceResourceUnit.TService;
end;

procedure RunDSServer;
var
  LModule: TServerContainer;
  LInputRecord: TInputRecord;
  LEvent: DWord;
  LHandle: THandle;
begin
  Writeln(Format('Starting %s', [TServerContainer.ClassName]));
  LModule := TServerContainer.Create(nil);
  try
    LModule.DSServer1.Start;
    try
      Writeln('Press ESC to stop the server');
      LHandle := GetStdHandle(STD_INPUT_HANDLE);
      while True do
      begin
        Win32Check(ReadConsoleInput(LHandle, LInputRecord, 1, LEvent));
        if (LInputRecord.EventType = KEY_EVENT) and
        LInputRecord.Event.KeyEvent.bKeyDown and
        (LInputRecord.Event.KeyEvent.wVirtualKeyCode = VK_ESCAPE) then
          break;
      end;
    finally
      LModule.DSServer1.Stop;
    end;
  finally
    LModule.Free;
  end;
end;

end.

