unit ServiceClientModuleUnit;

interface

uses
  SysUtils, Classes, ServiceClientClassesUnit, DSClientRest;

type
  TClientModule1 = class(TDataModule)
    DSRestConnection1: TDSRestConnection;
  private
    FInstanceOwner: Boolean;
    FServiceClient: TServiceClient;
    function GetServiceClient: TServiceClient;
    { Private declarations }
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property InstanceOwner: Boolean read FInstanceOwner write FInstanceOwner;
    property ServiceClient: TServiceClient read GetServiceClient write FServiceClient;

end;

var
  ClientModule1: TClientModule1;

implementation

{$R *.dfm}

constructor TClientModule1.Create(AOwner: TComponent);
begin
  inherited;
  FInstanceOwner := True;
end;

destructor TClientModule1.Destroy;
begin
  FServiceClient.Free;
end;

function TClientModule1.GetServiceClient: TServiceClient;
begin
  if FServiceClient = nil then
    FServiceClient:= TServiceClient.Create(DSRestConnection1, FInstanceOwner);
  Result := FServiceClient;
end;

end.
