program DEMOServer;

{$APPTYPE CONSOLE}

uses
  SysUtils,
  ServiceResourceUnit in 'ServiceResourceUnit.pas' {Service: TDataModule},
  ServerContainerUnit in 'ServerContainerUnit.pas' {ServerContainer: TDataModule},
  ServerUtils in 'ServerUtils.pas';

begin
  try
    RunDSServer;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end
end.

