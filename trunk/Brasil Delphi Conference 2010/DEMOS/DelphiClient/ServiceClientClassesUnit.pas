// 
// Created by the DataSnap proxy generator.
// 22/10/2010 13.32.15
// 

unit ServiceClientClassesUnit;

interface

uses DSProxyRest, DSClientRest, DBXCommon, DBXClient, DBXJSON, DSProxy, Classes, SysUtils, DB, SqlExpr, DBXDBReaders, DBXJSONReflect;

type
  TServiceClient = class(TDSAdminRestClient)
  private
    FEchoStringCommand: TDSRestCommand;
    FReverseStringCommand: TDSRestCommand;
    FSearchCustomersCommand: TDSRestCommand;
    FSearchCustomersCommand_Cache: TDSRestCommand;
    FCustomersCommand: TDSRestCommand;
    FCustomersCommand_Cache: TDSRestCommand;
    FacceptCustomersCommand: TDSRestCommand;
    FacceptCustomersCommand_Cache: TDSRestCommand;
    FupdateCustomersCommand: TDSRestCommand;
    FupdateCustomersCommand_Cache: TDSRestCommand;
    FcancelCustomersCommand: TDSRestCommand;
    FacceptOrdersCommand: TDSRestCommand;
    FacceptOrdersCommand_Cache: TDSRestCommand;
    FupdateOrdersCommand: TDSRestCommand;
    FupdateOrdersCommand_Cache: TDSRestCommand;
    FcancelOrdersCommand: TDSRestCommand;
    FOrdersCommand: TDSRestCommand;
    FOrdersCommand_Cache: TDSRestCommand;
    FProductsCommand: TDSRestCommand;
    FProductsCommand_Cache: TDSRestCommand;
    FOrdersMonitorCommand: TDSRestCommand;
    FOrdersMonitorCommand_Cache: TDSRestCommand;
  public
    constructor Create(ARestConnection: TDSRestConnection); overload;
    constructor Create(ARestConnection: TDSRestConnection; AInstanceOwner: Boolean); overload;
    destructor Destroy; override;
    function EchoString(Value: string; const ARequestFilter: string = ''): string;
    function ReverseString(Value: string; const ARequestFilter: string = ''): string;
    function SearchCustomers(Criteria: string; const ARequestFilter: string = ''): TJSONObject;
    function SearchCustomers_Cache(Criteria: string; const ARequestFilter: string = ''): IDSRestCachedJSONObject;
    function Customers(key: Integer; const ARequestFilter: string = ''): TJSONObject;
    function Customers_Cache(key: Integer; const ARequestFilter: string = ''): IDSRestCachedJSONObject;
    function acceptCustomers(Value: TJSONObject; const ARequestFilter: string = ''): TJSONObject;
    function acceptCustomers_Cache(Value: TJSONObject; const ARequestFilter: string = ''): IDSRestCachedJSONObject;
    function updateCustomers(ID: Integer; Value: TJSONObject; const ARequestFilter: string = ''): TJSONObject;
    function updateCustomers_Cache(ID: Integer; Value: TJSONObject; const ARequestFilter: string = ''): IDSRestCachedJSONObject;
    procedure cancelCustomers(ID: Integer);
    function acceptOrders(Value: TJSONObject; const ARequestFilter: string = ''): TJSONObject;
    function acceptOrders_Cache(Value: TJSONObject; const ARequestFilter: string = ''): IDSRestCachedJSONObject;
    function updateOrders(ID: Integer; Value: TJSONObject; const ARequestFilter: string = ''): TJSONObject;
    function updateOrders_Cache(ID: Integer; Value: TJSONObject; const ARequestFilter: string = ''): IDSRestCachedJSONObject;
    procedure cancelOrders(ID: Integer);
    function Orders(ID: Integer; const ARequestFilter: string = ''): TJSONObject;
    function Orders_Cache(ID: Integer; const ARequestFilter: string = ''): IDSRestCachedJSONObject;
    function Products(const ARequestFilter: string = ''): TJSONObject;
    function Products_Cache(const ARequestFilter: string = ''): IDSRestCachedJSONObject;
    function OrdersMonitor(const ARequestFilter: string = ''): TJSONObject;
    function OrdersMonitor_Cache(const ARequestFilter: string = ''): IDSRestCachedJSONObject;
  end;

const
  TService_EchoString: array [0..1] of TDSRestParameterMetaData =
  (
    (Name: 'Value'; Direction: 1; DBXType: 26; TypeName: 'string'),
    (Name: ''; Direction: 4; DBXType: 26; TypeName: 'string')
  );

  TService_ReverseString: array [0..1] of TDSRestParameterMetaData =
  (
    (Name: 'Value'; Direction: 1; DBXType: 26; TypeName: 'string'),
    (Name: ''; Direction: 4; DBXType: 26; TypeName: 'string')
  );

  TService_SearchCustomers: array [0..1] of TDSRestParameterMetaData =
  (
    (Name: 'Criteria'; Direction: 1; DBXType: 26; TypeName: 'string'),
    (Name: ''; Direction: 4; DBXType: 37; TypeName: 'TJSONObject')
  );

  TService_SearchCustomers_Cache: array [0..1] of TDSRestParameterMetaData =
  (
    (Name: 'Criteria'; Direction: 1; DBXType: 26; TypeName: 'string'),
    (Name: ''; Direction: 4; DBXType: 26; TypeName: 'String')
  );

  TService_Customers: array [0..1] of TDSRestParameterMetaData =
  (
    (Name: 'key'; Direction: 1; DBXType: 6; TypeName: 'Integer'),
    (Name: ''; Direction: 4; DBXType: 37; TypeName: 'TJSONObject')
  );

  TService_Customers_Cache: array [0..1] of TDSRestParameterMetaData =
  (
    (Name: 'key'; Direction: 1; DBXType: 6; TypeName: 'Integer'),
    (Name: ''; Direction: 4; DBXType: 26; TypeName: 'String')
  );

  TService_acceptCustomers: array [0..1] of TDSRestParameterMetaData =
  (
    (Name: 'Value'; Direction: 1; DBXType: 37; TypeName: 'TJSONObject'),
    (Name: ''; Direction: 4; DBXType: 37; TypeName: 'TJSONObject')
  );

  TService_acceptCustomers_Cache: array [0..1] of TDSRestParameterMetaData =
  (
    (Name: 'Value'; Direction: 1; DBXType: 37; TypeName: 'TJSONObject'),
    (Name: ''; Direction: 4; DBXType: 26; TypeName: 'String')
  );

  TService_updateCustomers: array [0..2] of TDSRestParameterMetaData =
  (
    (Name: 'ID'; Direction: 1; DBXType: 6; TypeName: 'Integer'),
    (Name: 'Value'; Direction: 1; DBXType: 37; TypeName: 'TJSONObject'),
    (Name: ''; Direction: 4; DBXType: 37; TypeName: 'TJSONObject')
  );

  TService_updateCustomers_Cache: array [0..2] of TDSRestParameterMetaData =
  (
    (Name: 'ID'; Direction: 1; DBXType: 6; TypeName: 'Integer'),
    (Name: 'Value'; Direction: 1; DBXType: 37; TypeName: 'TJSONObject'),
    (Name: ''; Direction: 4; DBXType: 26; TypeName: 'String')
  );

  TService_cancelCustomers: array [0..0] of TDSRestParameterMetaData =
  (
    (Name: 'ID'; Direction: 1; DBXType: 6; TypeName: 'Integer')
  );

  TService_acceptOrders: array [0..1] of TDSRestParameterMetaData =
  (
    (Name: 'Value'; Direction: 1; DBXType: 37; TypeName: 'TJSONObject'),
    (Name: ''; Direction: 4; DBXType: 37; TypeName: 'TJSONObject')
  );

  TService_acceptOrders_Cache: array [0..1] of TDSRestParameterMetaData =
  (
    (Name: 'Value'; Direction: 1; DBXType: 37; TypeName: 'TJSONObject'),
    (Name: ''; Direction: 4; DBXType: 26; TypeName: 'String')
  );

  TService_updateOrders: array [0..2] of TDSRestParameterMetaData =
  (
    (Name: 'ID'; Direction: 1; DBXType: 6; TypeName: 'Integer'),
    (Name: 'Value'; Direction: 1; DBXType: 37; TypeName: 'TJSONObject'),
    (Name: ''; Direction: 4; DBXType: 37; TypeName: 'TJSONObject')
  );

  TService_updateOrders_Cache: array [0..2] of TDSRestParameterMetaData =
  (
    (Name: 'ID'; Direction: 1; DBXType: 6; TypeName: 'Integer'),
    (Name: 'Value'; Direction: 1; DBXType: 37; TypeName: 'TJSONObject'),
    (Name: ''; Direction: 4; DBXType: 26; TypeName: 'String')
  );

  TService_cancelOrders: array [0..0] of TDSRestParameterMetaData =
  (
    (Name: 'ID'; Direction: 1; DBXType: 6; TypeName: 'Integer')
  );

  TService_Orders: array [0..1] of TDSRestParameterMetaData =
  (
    (Name: 'ID'; Direction: 1; DBXType: 6; TypeName: 'Integer'),
    (Name: ''; Direction: 4; DBXType: 37; TypeName: 'TJSONObject')
  );

  TService_Orders_Cache: array [0..1] of TDSRestParameterMetaData =
  (
    (Name: 'ID'; Direction: 1; DBXType: 6; TypeName: 'Integer'),
    (Name: ''; Direction: 4; DBXType: 26; TypeName: 'String')
  );

  TService_Products: array [0..0] of TDSRestParameterMetaData =
  (
    (Name: ''; Direction: 4; DBXType: 37; TypeName: 'TJSONObject')
  );

  TService_Products_Cache: array [0..0] of TDSRestParameterMetaData =
  (
    (Name: ''; Direction: 4; DBXType: 26; TypeName: 'String')
  );

  TService_OrdersMonitor: array [0..0] of TDSRestParameterMetaData =
  (
    (Name: ''; Direction: 4; DBXType: 37; TypeName: 'TJSONObject')
  );

  TService_OrdersMonitor_Cache: array [0..0] of TDSRestParameterMetaData =
  (
    (Name: ''; Direction: 4; DBXType: 26; TypeName: 'String')
  );

implementation

function TServiceClient.EchoString(Value: string; const ARequestFilter: string): string;
begin
  if FEchoStringCommand = nil then
  begin
    FEchoStringCommand := FConnection.CreateCommand;
    FEchoStringCommand.RequestType := 'GET';
    FEchoStringCommand.Text := 'TService.EchoString';
    FEchoStringCommand.Prepare(TService_EchoString);
  end;
  FEchoStringCommand.Parameters[0].Value.SetWideString(Value);
  FEchoStringCommand.Execute(ARequestFilter);
  Result := FEchoStringCommand.Parameters[1].Value.GetWideString;
end;

function TServiceClient.ReverseString(Value: string; const ARequestFilter: string): string;
begin
  if FReverseStringCommand = nil then
  begin
    FReverseStringCommand := FConnection.CreateCommand;
    FReverseStringCommand.RequestType := 'GET';
    FReverseStringCommand.Text := 'TService.ReverseString';
    FReverseStringCommand.Prepare(TService_ReverseString);
  end;
  FReverseStringCommand.Parameters[0].Value.SetWideString(Value);
  FReverseStringCommand.Execute(ARequestFilter);
  Result := FReverseStringCommand.Parameters[1].Value.GetWideString;
end;

function TServiceClient.SearchCustomers(Criteria: string; const ARequestFilter: string): TJSONObject;
begin
  if FSearchCustomersCommand = nil then
  begin
    FSearchCustomersCommand := FConnection.CreateCommand;
    FSearchCustomersCommand.RequestType := 'GET';
    FSearchCustomersCommand.Text := 'TService.SearchCustomers';
    FSearchCustomersCommand.Prepare(TService_SearchCustomers);
  end;
  FSearchCustomersCommand.Parameters[0].Value.SetWideString(Criteria);
  FSearchCustomersCommand.Execute(ARequestFilter);
  Result := TJSONObject(FSearchCustomersCommand.Parameters[1].Value.GetJSONValue(FInstanceOwner));
end;

function TServiceClient.SearchCustomers_Cache(Criteria: string; const ARequestFilter: string): IDSRestCachedJSONObject;
begin
  if FSearchCustomersCommand_Cache = nil then
  begin
    FSearchCustomersCommand_Cache := FConnection.CreateCommand;
    FSearchCustomersCommand_Cache.RequestType := 'GET';
    FSearchCustomersCommand_Cache.Text := 'TService.SearchCustomers';
    FSearchCustomersCommand_Cache.Prepare(TService_SearchCustomers_Cache);
  end;
  FSearchCustomersCommand_Cache.Parameters[0].Value.SetWideString(Criteria);
  FSearchCustomersCommand_Cache.ExecuteCache(ARequestFilter);
  Result := TDSRestCachedJSONObject.Create(FSearchCustomersCommand_Cache.Parameters[1].Value.GetString);
end;

function TServiceClient.Customers(key: Integer; const ARequestFilter: string): TJSONObject;
begin
  if FCustomersCommand = nil then
  begin
    FCustomersCommand := FConnection.CreateCommand;
    FCustomersCommand.RequestType := 'GET';
    FCustomersCommand.Text := 'TService.Customers';
    FCustomersCommand.Prepare(TService_Customers);
  end;
  FCustomersCommand.Parameters[0].Value.SetInt32(key);
  FCustomersCommand.Execute(ARequestFilter);
  Result := TJSONObject(FCustomersCommand.Parameters[1].Value.GetJSONValue(FInstanceOwner));
end;

function TServiceClient.Customers_Cache(key: Integer; const ARequestFilter: string): IDSRestCachedJSONObject;
begin
  if FCustomersCommand_Cache = nil then
  begin
    FCustomersCommand_Cache := FConnection.CreateCommand;
    FCustomersCommand_Cache.RequestType := 'GET';
    FCustomersCommand_Cache.Text := 'TService.Customers';
    FCustomersCommand_Cache.Prepare(TService_Customers_Cache);
  end;
  FCustomersCommand_Cache.Parameters[0].Value.SetInt32(key);
  FCustomersCommand_Cache.ExecuteCache(ARequestFilter);
  Result := TDSRestCachedJSONObject.Create(FCustomersCommand_Cache.Parameters[1].Value.GetString);
end;

function TServiceClient.acceptCustomers(Value: TJSONObject; const ARequestFilter: string): TJSONObject;
begin
  if FacceptCustomersCommand = nil then
  begin
    FacceptCustomersCommand := FConnection.CreateCommand;
    FacceptCustomersCommand.RequestType := 'POST';
    FacceptCustomersCommand.Text := 'TService."acceptCustomers"';
    FacceptCustomersCommand.Prepare(TService_acceptCustomers);
  end;
  FacceptCustomersCommand.Parameters[0].Value.SetJSONValue(Value, FInstanceOwner);
  FacceptCustomersCommand.Execute(ARequestFilter);
  Result := TJSONObject(FacceptCustomersCommand.Parameters[1].Value.GetJSONValue(FInstanceOwner));
end;

function TServiceClient.acceptCustomers_Cache(Value: TJSONObject; const ARequestFilter: string): IDSRestCachedJSONObject;
begin
  if FacceptCustomersCommand_Cache = nil then
  begin
    FacceptCustomersCommand_Cache := FConnection.CreateCommand;
    FacceptCustomersCommand_Cache.RequestType := 'POST';
    FacceptCustomersCommand_Cache.Text := 'TService."acceptCustomers"';
    FacceptCustomersCommand_Cache.Prepare(TService_acceptCustomers_Cache);
  end;
  FacceptCustomersCommand_Cache.Parameters[0].Value.SetJSONValue(Value, FInstanceOwner);
  FacceptCustomersCommand_Cache.ExecuteCache(ARequestFilter);
  Result := TDSRestCachedJSONObject.Create(FacceptCustomersCommand_Cache.Parameters[1].Value.GetString);
end;

function TServiceClient.updateCustomers(ID: Integer; Value: TJSONObject; const ARequestFilter: string): TJSONObject;
begin
  if FupdateCustomersCommand = nil then
  begin
    FupdateCustomersCommand := FConnection.CreateCommand;
    FupdateCustomersCommand.RequestType := 'POST';
    FupdateCustomersCommand.Text := 'TService."updateCustomers"';
    FupdateCustomersCommand.Prepare(TService_updateCustomers);
  end;
  FupdateCustomersCommand.Parameters[0].Value.SetInt32(ID);
  FupdateCustomersCommand.Parameters[1].Value.SetJSONValue(Value, FInstanceOwner);
  FupdateCustomersCommand.Execute(ARequestFilter);
  Result := TJSONObject(FupdateCustomersCommand.Parameters[2].Value.GetJSONValue(FInstanceOwner));
end;

function TServiceClient.updateCustomers_Cache(ID: Integer; Value: TJSONObject; const ARequestFilter: string): IDSRestCachedJSONObject;
begin
  if FupdateCustomersCommand_Cache = nil then
  begin
    FupdateCustomersCommand_Cache := FConnection.CreateCommand;
    FupdateCustomersCommand_Cache.RequestType := 'POST';
    FupdateCustomersCommand_Cache.Text := 'TService."updateCustomers"';
    FupdateCustomersCommand_Cache.Prepare(TService_updateCustomers_Cache);
  end;
  FupdateCustomersCommand_Cache.Parameters[0].Value.SetInt32(ID);
  FupdateCustomersCommand_Cache.Parameters[1].Value.SetJSONValue(Value, FInstanceOwner);
  FupdateCustomersCommand_Cache.ExecuteCache(ARequestFilter);
  Result := TDSRestCachedJSONObject.Create(FupdateCustomersCommand_Cache.Parameters[2].Value.GetString);
end;

procedure TServiceClient.cancelCustomers(ID: Integer);
begin
  if FcancelCustomersCommand = nil then
  begin
    FcancelCustomersCommand := FConnection.CreateCommand;
    FcancelCustomersCommand.RequestType := 'GET';
    FcancelCustomersCommand.Text := 'TService.cancelCustomers';
    FcancelCustomersCommand.Prepare(TService_cancelCustomers);
  end;
  FcancelCustomersCommand.Parameters[0].Value.SetInt32(ID);
  FcancelCustomersCommand.Execute;
end;

function TServiceClient.acceptOrders(Value: TJSONObject; const ARequestFilter: string): TJSONObject;
begin
  if FacceptOrdersCommand = nil then
  begin
    FacceptOrdersCommand := FConnection.CreateCommand;
    FacceptOrdersCommand.RequestType := 'POST';
    FacceptOrdersCommand.Text := 'TService."acceptOrders"';
    FacceptOrdersCommand.Prepare(TService_acceptOrders);
  end;
  FacceptOrdersCommand.Parameters[0].Value.SetJSONValue(Value, FInstanceOwner);
  FacceptOrdersCommand.Execute(ARequestFilter);
  Result := TJSONObject(FacceptOrdersCommand.Parameters[1].Value.GetJSONValue(FInstanceOwner));
end;

function TServiceClient.acceptOrders_Cache(Value: TJSONObject; const ARequestFilter: string): IDSRestCachedJSONObject;
begin
  if FacceptOrdersCommand_Cache = nil then
  begin
    FacceptOrdersCommand_Cache := FConnection.CreateCommand;
    FacceptOrdersCommand_Cache.RequestType := 'POST';
    FacceptOrdersCommand_Cache.Text := 'TService."acceptOrders"';
    FacceptOrdersCommand_Cache.Prepare(TService_acceptOrders_Cache);
  end;
  FacceptOrdersCommand_Cache.Parameters[0].Value.SetJSONValue(Value, FInstanceOwner);
  FacceptOrdersCommand_Cache.ExecuteCache(ARequestFilter);
  Result := TDSRestCachedJSONObject.Create(FacceptOrdersCommand_Cache.Parameters[1].Value.GetString);
end;

function TServiceClient.updateOrders(ID: Integer; Value: TJSONObject; const ARequestFilter: string): TJSONObject;
begin
  if FupdateOrdersCommand = nil then
  begin
    FupdateOrdersCommand := FConnection.CreateCommand;
    FupdateOrdersCommand.RequestType := 'POST';
    FupdateOrdersCommand.Text := 'TService."updateOrders"';
    FupdateOrdersCommand.Prepare(TService_updateOrders);
  end;
  FupdateOrdersCommand.Parameters[0].Value.SetInt32(ID);
  FupdateOrdersCommand.Parameters[1].Value.SetJSONValue(Value, FInstanceOwner);
  FupdateOrdersCommand.Execute(ARequestFilter);
  Result := TJSONObject(FupdateOrdersCommand.Parameters[2].Value.GetJSONValue(FInstanceOwner));
end;

function TServiceClient.updateOrders_Cache(ID: Integer; Value: TJSONObject; const ARequestFilter: string): IDSRestCachedJSONObject;
begin
  if FupdateOrdersCommand_Cache = nil then
  begin
    FupdateOrdersCommand_Cache := FConnection.CreateCommand;
    FupdateOrdersCommand_Cache.RequestType := 'POST';
    FupdateOrdersCommand_Cache.Text := 'TService."updateOrders"';
    FupdateOrdersCommand_Cache.Prepare(TService_updateOrders_Cache);
  end;
  FupdateOrdersCommand_Cache.Parameters[0].Value.SetInt32(ID);
  FupdateOrdersCommand_Cache.Parameters[1].Value.SetJSONValue(Value, FInstanceOwner);
  FupdateOrdersCommand_Cache.ExecuteCache(ARequestFilter);
  Result := TDSRestCachedJSONObject.Create(FupdateOrdersCommand_Cache.Parameters[2].Value.GetString);
end;

procedure TServiceClient.cancelOrders(ID: Integer);
begin
  if FcancelOrdersCommand = nil then
  begin
    FcancelOrdersCommand := FConnection.CreateCommand;
    FcancelOrdersCommand.RequestType := 'GET';
    FcancelOrdersCommand.Text := 'TService.cancelOrders';
    FcancelOrdersCommand.Prepare(TService_cancelOrders);
  end;
  FcancelOrdersCommand.Parameters[0].Value.SetInt32(ID);
  FcancelOrdersCommand.Execute;
end;

function TServiceClient.Orders(ID: Integer; const ARequestFilter: string): TJSONObject;
begin
  if FOrdersCommand = nil then
  begin
    FOrdersCommand := FConnection.CreateCommand;
    FOrdersCommand.RequestType := 'GET';
    FOrdersCommand.Text := 'TService.Orders';
    FOrdersCommand.Prepare(TService_Orders);
  end;
  FOrdersCommand.Parameters[0].Value.SetInt32(ID);
  FOrdersCommand.Execute(ARequestFilter);
  Result := TJSONObject(FOrdersCommand.Parameters[1].Value.GetJSONValue(FInstanceOwner));
end;

function TServiceClient.Orders_Cache(ID: Integer; const ARequestFilter: string): IDSRestCachedJSONObject;
begin
  if FOrdersCommand_Cache = nil then
  begin
    FOrdersCommand_Cache := FConnection.CreateCommand;
    FOrdersCommand_Cache.RequestType := 'GET';
    FOrdersCommand_Cache.Text := 'TService.Orders';
    FOrdersCommand_Cache.Prepare(TService_Orders_Cache);
  end;
  FOrdersCommand_Cache.Parameters[0].Value.SetInt32(ID);
  FOrdersCommand_Cache.ExecuteCache(ARequestFilter);
  Result := TDSRestCachedJSONObject.Create(FOrdersCommand_Cache.Parameters[1].Value.GetString);
end;

function TServiceClient.Products(const ARequestFilter: string): TJSONObject;
begin
  if FProductsCommand = nil then
  begin
    FProductsCommand := FConnection.CreateCommand;
    FProductsCommand.RequestType := 'GET';
    FProductsCommand.Text := 'TService.Products';
    FProductsCommand.Prepare(TService_Products);
  end;
  FProductsCommand.Execute(ARequestFilter);
  Result := TJSONObject(FProductsCommand.Parameters[0].Value.GetJSONValue(FInstanceOwner));
end;

function TServiceClient.Products_Cache(const ARequestFilter: string): IDSRestCachedJSONObject;
begin
  if FProductsCommand_Cache = nil then
  begin
    FProductsCommand_Cache := FConnection.CreateCommand;
    FProductsCommand_Cache.RequestType := 'GET';
    FProductsCommand_Cache.Text := 'TService.Products';
    FProductsCommand_Cache.Prepare(TService_Products_Cache);
  end;
  FProductsCommand_Cache.ExecuteCache(ARequestFilter);
  Result := TDSRestCachedJSONObject.Create(FProductsCommand_Cache.Parameters[0].Value.GetString);
end;

function TServiceClient.OrdersMonitor(const ARequestFilter: string): TJSONObject;
begin
  if FOrdersMonitorCommand = nil then
  begin
    FOrdersMonitorCommand := FConnection.CreateCommand;
    FOrdersMonitorCommand.RequestType := 'GET';
    FOrdersMonitorCommand.Text := 'TService.OrdersMonitor';
    FOrdersMonitorCommand.Prepare(TService_OrdersMonitor);
  end;
  FOrdersMonitorCommand.Execute(ARequestFilter);
  Result := TJSONObject(FOrdersMonitorCommand.Parameters[0].Value.GetJSONValue(FInstanceOwner));
end;

function TServiceClient.OrdersMonitor_Cache(const ARequestFilter: string): IDSRestCachedJSONObject;
begin
  if FOrdersMonitorCommand_Cache = nil then
  begin
    FOrdersMonitorCommand_Cache := FConnection.CreateCommand;
    FOrdersMonitorCommand_Cache.RequestType := 'GET';
    FOrdersMonitorCommand_Cache.Text := 'TService.OrdersMonitor';
    FOrdersMonitorCommand_Cache.Prepare(TService_OrdersMonitor_Cache);
  end;
  FOrdersMonitorCommand_Cache.ExecuteCache(ARequestFilter);
  Result := TDSRestCachedJSONObject.Create(FOrdersMonitorCommand_Cache.Parameters[0].Value.GetString);
end;

constructor TServiceClient.Create(ARestConnection: TDSRestConnection);
begin
  inherited Create(ARestConnection);
end;

constructor TServiceClient.Create(ARestConnection: TDSRestConnection; AInstanceOwner: Boolean);
begin
  inherited Create(ARestConnection, AInstanceOwner);
end;

destructor TServiceClient.Destroy;
begin
  FreeAndNil(FEchoStringCommand);
  FreeAndNil(FReverseStringCommand);
  FreeAndNil(FSearchCustomersCommand);
  FreeAndNil(FSearchCustomersCommand_Cache);
  FreeAndNil(FCustomersCommand);
  FreeAndNil(FCustomersCommand_Cache);
  FreeAndNil(FacceptCustomersCommand);
  FreeAndNil(FacceptCustomersCommand_Cache);
  FreeAndNil(FupdateCustomersCommand);
  FreeAndNil(FupdateCustomersCommand_Cache);
  FreeAndNil(FcancelCustomersCommand);
  FreeAndNil(FacceptOrdersCommand);
  FreeAndNil(FacceptOrdersCommand_Cache);
  FreeAndNil(FupdateOrdersCommand);
  FreeAndNil(FupdateOrdersCommand_Cache);
  FreeAndNil(FcancelOrdersCommand);
  FreeAndNil(FOrdersCommand);
  FreeAndNil(FOrdersCommand_Cache);
  FreeAndNil(FProductsCommand);
  FreeAndNil(FProductsCommand_Cache);
  FreeAndNil(FOrdersMonitorCommand);
  FreeAndNil(FOrdersMonitorCommand_Cache);
  inherited;
end;

end.
