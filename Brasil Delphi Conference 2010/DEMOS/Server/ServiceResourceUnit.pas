unit ServiceResourceUnit;

interface

uses
  SysUtils, Classes, DSServer, DBXJSON, DBXInterBase, DB, SqlExpr, DBXCommon;

type
{$METHODINFO ON}
  TService = class(TDataModule)
    Connection: TSQLConnection;
  private
    procedure Init;
    function StripMetadata(const Value: TJSONObject): TJSONObject;
    function GetNextID(const TableName: String): Int32;
    procedure SaveOrderDetail(cmd: TDBXCommand; ID_Order: Int32;
      JSON: TJSONObject);
    procedure SaveDetails(cmd: TDBXCommand; ID: Integer; JSON: TJSONArray);
  public
    { Public declarations }
    function EchoString(Value: string): string;
    function ReverseString(Value: string): string;

    // CUSTOMERS
    function SearchCustomers(Criteria: String): TJSONObject;
    function Customers(key: Int32): TJSONObject;
    function acceptCustomers(Value: TJSONObject): TJSONObject;
    function updateCustomers(ID: Int32; Value: TJSONObject): TJSONObject;
    procedure cancelCustomers(ID: Int32);

    // ORDERS
    function acceptOrders(Value: TJSONObject): TJSONObject;
    function updateOrders(ID: Int32; Value: TJSONObject): TJSONObject;
    procedure cancelOrders(ID: Int32);
    function Orders(ID: Int32): TJSONObject;

    // PRODUCTS
    function Products: TJSONObject;


    // MONITOR (Could be in another service)
    function OrdersMonitor: TJSONObject;
  end;
{$METHODINFO OFF}

implementation

{$R *.dfm}

uses StrUtils, DBXDBReaders, DBXJSONCommon, ServerUtils;

function TService.acceptCustomers(Value: TJSONObject): TJSONObject;
var
  cmd: TDBXCommand;
  ID: Int32;
  ShipDate: TDBXDateValue;
begin
  if not Assigned(Value) then
    raise Exception.Create('Invalid message');

  Init;
  // {"DESCRIPTION": "TDSOFT","ADDRESS":"Via Roma, 100","LATITUDE":23.1232, "LONGITUDE":12.12312}
  cmd := Connection.DBXConnection.CreateCommand;
  try
    ID := GetNextID('customers');
    cmd.Text :=
      'INSERT INTO CUSTOMERS (ID, DESCRIPTION, ADDRESS, LATITUDE, LONGITUDE) VALUES (?,?,?,?,?)';
    cmd.Prepare;
    cmd.Parameters[0].Value.SetInt32(ID);
    cmd.Parameters[1].Value.SetAnsiString(Value.Get('DESCRIPTION')
      .JsonValue.Value);
    cmd.Parameters[2].Value.SetAnsiString(Value.Get('ADDRESS').JsonValue.Value);

    if Assigned(Value.Get('LATITUDE')) then
      cmd.Parameters[3].Value.SetDouble
        (StrToFloat(Value.Get('LATITUDE').JsonValue.Value))
    else
      cmd.Parameters[3].Value.SetNull;

    if Assigned(Value.Get('LONGITUDE')) then
      cmd.Parameters[4].Value.SetDouble
        (StrToFloat(Value.Get('LONGITUDE').JsonValue.Value))
    else
      cmd.Parameters[4].Value.SetNull;

    cmd.ExecuteUpdate;
    cmd.Close;
    cmd.Text := 'SELECT * FROM CUSTOMERS WHERE ID = ?';
    cmd.Prepare;
    cmd.Parameters[0].Value.SetInt32(ID);
    Result := StripMetadata(TDBXJSONTools.TableToJSON(cmd.ExecuteQuery,
      1, true));
  finally
    cmd.Free;
  end;

end;

function TService.acceptOrders(Value: TJSONObject): TJSONObject;
var
  cmd: TDBXCommand;
  i, ID: Int32;
  ShipDate: TDBXDateValue;
  Rows: TJSONArray;
  tr: TDBXTransaction;
begin
  if not Assigned(Value) then
    raise Exception.Create('Invalid message');
  Init;

  tr := Connection.DBXConnection.BeginTransaction();
  try
    cmd := Connection.DBXConnection.CreateCommand;
    try
      ID := GetNextID('orders');
      cmd.Text :=
        'INSERT INTO ORDERS (ID, ID_CUSTOMER, CREATED_AT, SHIP_BEFORE) VALUES (?,?,CURRENT_DATE,?)';
      cmd.Prepare;
      cmd.Parameters[0].Value.SetInt32(ID);
      cmd.Parameters[1].Value.SetInt32
        (TJSONNumber(Value.Get('ID_CUSTOMER').JsonValue).AsInt);
      cmd.Parameters[2].Value.SetAnsiString(Value.Get('SHIP_BEFORE')
        .JsonValue.Value);
      cmd.ExecuteUpdate;
      SaveDetails(cmd, ID, Value.Get('ROWS').JsonValue as TJSONArray);
    finally
      cmd.Free;
    end;
    Connection.DBXConnection.CommitFreeAndNil(tr);
  except
    Connection.DBXConnection.RollbackFreeAndNil(tr);
    raise;
  end;
end;

procedure TService.SaveDetails(cmd: TDBXCommand; ID: Integer; JSON: TJSONArray);
var
  i: Integer;
begin
  if not Assigned(JSON) then
    Exit;
  for i := 0 to JSON.Size - 1 do
    SaveOrderDetail(cmd, ID, JSON.Get(i) as TJSONObject);
end;

procedure TService.SaveOrderDetail(cmd: TDBXCommand; ID_Order: Int32;
  JSON: TJSONObject);
begin
  cmd.Close;
  if not Assigned(JSON.Get('ID')) then // INSERT
  begin
    cmd.Text :=
      'INSERT INTO ORDER_DETAILS (ID_ORDER, ID_PRODUCT, QUANTITY) VALUES (?,?,?)';
    cmd.Prepare;
    cmd.Parameters[0].Value.SetInt32(ID_Order);
    cmd.Parameters[1].Value.SetInt32
      (TJSONNumber(JSON.Get('ID_PRODUCT').JsonValue).AsInt);
    cmd.Parameters[2].Value.SetInt32
      (TJSONNumber(JSON.Get('QUANTITY').JsonValue).AsInt);
  end
  else
  begin // UPDATE
    cmd.Text :=
      'UPDATE ORDER_DETAILS SET ID_PRODUCT = ?, QUANTITY = ? WHERE ID = ?';
    cmd.Prepare;
    cmd.Parameters[0].Value.SetInt32
      (TJSONNumber(JSON.Get('ID_PRODUCT').JsonValue).AsInt);
    cmd.Parameters[1].Value.SetInt32
      (TJSONNumber(JSON.Get('QUANTITY').JsonValue).AsInt);
    cmd.Parameters[2].Value.SetInt32
      (TJSONNumber(JSON.Get('ID').JsonValue).AsInt);
  end;
  cmd.ExecuteUpdate;
end;

function TService.SearchCustomers(Criteria: String): TJSONObject;
var
  cmd: TDBXCommand;
begin
  Init;
  Result := TJSONObject.Create;
  cmd := Connection.DBXConnection.CreateCommand;
  try
    cmd.Text :=
      'select * from customers where description containing ? or address containing ?';
    cmd.Prepare;
    cmd.Parameters[0].Value.SetAnsiString(Criteria);
    cmd.Parameters[1].Value.SetAnsiString(Criteria);
    Result := StripMetadata(TDBXJSONTools.TableToJSON(cmd.ExecuteQuery,
      1000, true));
  finally
    cmd.Free;
  end;
end;

function TService.Customers(key: Int32): TJSONObject;
var
  cmd: TDBXCommand;
begin
  if key = 0 then // no GET param sent
  begin
    Init;
    cmd := Connection.DBXConnection.CreateCommand;
    try
      cmd.Text := 'select * from customers';
      Result := TDBXJSONTools.TableToJSON(cmd.ExecuteQuery, 1000, true);
    finally
      cmd.Free;
    end;
  end
  else
  begin
    Init;
    cmd := Connection.DBXConnection.CreateCommand;
    try
      cmd.Text := 'select * from customers where id = ?';
      cmd.Prepare;
      cmd.Parameters[0].Value.SetInt32(key);
      Result := StripMetadata(TDBXJSONTools.TableToJSON(cmd.ExecuteQuery,
        1, true));
      cmd.Text := 'select * from orders where id_customer = ?';
      cmd.Prepare;
      cmd.Parameters[0].Value.SetInt32(key);
      Result.AddPair('ORDERS',
        StripMetadata(TDBXJSONTools.TableToJSON(cmd.ExecuteQuery, 1000, true)));
    finally
      cmd.Free;
    end;
  end;
end;

procedure TService.cancelCustomers(ID: Int32);
var
  cmd: TDBXCommand;
begin
  Init;

  cmd := Connection.DBXConnection.CreateCommand;
  try
    cmd.Text := 'DELETE FROM CUSTOMERS WHERE ID = ?';
    cmd.Prepare;
    cmd.Parameters[0].Value.SetInt32(ID);
    cmd.ExecuteUpdate;
  finally
    cmd.Free;
  end;
end;

procedure TService.cancelOrders(ID: Int32);
var
  cmd: TDBXCommand;
begin
  Init;

  cmd := Connection.DBXConnection.CreateCommand;
  try
    cmd.Text := 'DELETE FROM ORDERS WHERE ID = ?';
    cmd.Prepare;
    cmd.Parameters[0].Value.SetInt32(ID);
    cmd.ExecuteUpdate;
  finally
    cmd.Free;
  end;
end;

function TService.EchoString(Value: string): string;
begin
  Result := Value;
end;

function TService.GetNextID(const TableName: String): Int32;
var
  cmd: TDBXCommand;
  rdr: TDBXReader;
begin
  Init;
  cmd := Connection.DBXConnection.CreateCommand;
  try
    cmd.Text := 'select gen_id(GEN_' + TableName + '_ID,1) from rdb$database';
    rdr := cmd.ExecuteQuery;
    try
      if rdr.Next then
        Result := rdr.Value[0].AsInt32
      else
        raise Exception.Create('Error in GetNextID');
    finally
      rdr.Free;
    end;
  finally
    cmd.Free;
  end;
end;

procedure TService.Init;
begin
  if not Connection.Connected then
    Connection.Open;
end;

function TService.Orders(ID: Int32): TJSONObject;
var
  cmd: TDBXCommand;
begin
  Init;
  cmd := Connection.DBXConnection.CreateCommand;
  try
    if ID <> 0 then
    begin
      cmd.Text := 'SELECT * FROM ORDERS WHERE ID = ?';
      cmd.Prepare;
      cmd.Parameters[0].Value.SetInt32(ID);
      Result := StripMetadata(TDBXJSONTools.TableToJSON(cmd.ExecuteQuery,
        1, true));
    end
    else
    begin
      cmd.Text := 'SELECT * FROM ORDERS ORDER BY CREATED_AT';
      cmd.Prepare;
      Result := StripMetadata(TDBXJSONTools.TableToJSON(cmd.ExecuteQuery,
        1000, true));
    end;
  finally
    cmd.Free;
  end;
end;

function TService.OrdersMonitor: TJSONObject;
var
  cmd: TDBXCommand;
begin
  Init;
  cmd := Connection.DBXConnection.CreateCommand;
  try
    cmd.Text := 'SELECT c.*, o.ID as ID_ORDER, o.created_at, o.ship_before FROM CUSTOMERS c join orders o on c.id = o.id_customer order by o.created_at desc, o.id asc';
    Result := StripMetadata(TDBXJSONTools.TableToJSON(cmd.ExecuteQuery,
      1000, true));
  finally
    cmd.Free;
  end;
end;

function TService.Products: TJSONObject;
var
  cmd: TDBXCommand;
begin
  Init;
  cmd := Connection.DBXConnection.CreateCommand;
  try
    cmd.Text := 'SELECT * FROM PRODUCTS';
    Result := StripMetadata(TDBXJSONTools.TableToJSON(cmd.ExecuteQuery,
      1000, true));
  finally
    cmd.Free;
  end;
end;

function TService.ReverseString(Value: string): string;
begin
  Result := StrUtils.ReverseString(Value);
end;

function TService.StripMetadata(const Value: TJSONObject): TJSONObject;
begin
  Value.RemovePair('table');
  Result := Value;
end;

function TService.updateCustomers(ID: Int32; Value: TJSONObject): TJSONObject;
var
  cmd: TDBXCommand;
  ShipDate: TDBXDateValue;
begin
  if not Assigned(Value) then
    raise Exception.Create('Invalid message');

  Init;
  // {"DESCRIPTION": "TDSOFT","ADDRESS":"Via Roma, 100","LATITUDE":23.1232, "LONGITUDE":12.12312}
  cmd := Connection.DBXConnection.CreateCommand;
  try
    cmd.Text :=
      'UPDATE CUSTOMERS SET DESCRIPTION = ?, ADDRESS = ?, LATITUDE = ?, LONGITUDE = ? WHERE ID = ?';
    cmd.Prepare;
    cmd.Parameters[0].Value.SetAnsiString(Value.Get('DESCRIPTION')
      .JsonValue.Value);
    cmd.Parameters[1].Value.SetAnsiString(Value.Get('ADDRESS').JsonValue.Value);
    cmd.Parameters[2].Value.SetDouble
      (StrToFloat(Value.Get('LATITUDE').JsonValue.Value));
    cmd.Parameters[3].Value.SetDouble
      (StrToFloat(Value.Get('LONGITUDE').JsonValue.Value));
    cmd.Parameters[4].Value.SetInt32(ID);
    cmd.ExecuteUpdate;
    cmd.Close;
    cmd.Text := 'SELECT * FROM CUSTOMERS WHERE ID = ?';
    cmd.Prepare;
    cmd.Parameters[0].Value.SetInt32(ID);
    Result := StripMetadata(TDBXJSONTools.TableToJSON(cmd.ExecuteQuery,
      1, true));
  finally
    cmd.Free;
  end;
end;

function TService.updateOrders(ID: Int32; Value: TJSONObject): TJSONObject;
var
  cmd: TDBXCommand;
  tr: TDBXTransaction;
begin
  if not Assigned(Value) then
    raise Exception.Create('Invalid message');
  Init;

  tr := Connection.DBXConnection.BeginTransaction();
  try
    cmd := Connection.DBXConnection.CreateCommand;
    try
      cmd.Text := 'UPDATE ORDERS SET SHIP_BEFORE = ? WHERE ID = ?';
      cmd.Prepare;
      cmd.Parameters[0].Value.SetAnsiString(Value.Get('SHIP_BEFORE')
        .JsonValue.Value);
      cmd.Parameters[1].Value.SetInt32(ID);
      cmd.ExecuteUpdate;
      cmd.Close;
      SaveDetails(cmd, ID, Value.Get('rows').JsonValue as TJSONArray);
    finally
      cmd.Free;
    end;
    Connection.DBXConnection.CommitFreeAndNil(tr);
  except
    Connection.DBXConnection.RollbackFreeAndNil(tr);
    raise;
  end;
end;

end.
