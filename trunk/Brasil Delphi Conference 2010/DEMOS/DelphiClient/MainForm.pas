unit MainForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, ActnList, Grids;

type
  TForm3 = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Button1: TButton;
    ActionList1: TActionList;
    actCustomers: TAction;
    actOrders: TAction;
    actDetails: TAction;
    sg: TStringGrid;
    Timer1: TTimer;
    procedure actCustomersExecute(Sender: TObject);
    procedure actOrdersExecute(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  public
    { Public declarations }
  end;

var
  Form3: TForm3;

implementation

uses ServiceClientModuleUnit, DBXJSON, DBXJSONCommon;

{$R *.dfm}
{ TForm3 }

procedure TForm3.actCustomersExecute(Sender: TObject);
var
  customers: TJSONObject;
  descriptions: TJSONArray;
  i: Integer;
  li: TListItem;
  ids: TJSONArray;

begin
  customers := ClientModule1.ServiceClient.customers(0);
  descriptions := customers.Get('DESCRIPTION').JsonValue as TJSONArray;
  ids := customers.Get('ID').JsonValue as TJSONArray;
end;

procedure TForm3.actOrdersExecute(Sender: TObject);
var
  info: TJSONObject;
  descriptions: TJSONArray;
  i: Integer;
  li: TListItem;
  desc: TJSONArray;
  lat, lon: TJSONArray;
  created_at: TJSONArray;
  ship_before: TJSONArray;
  orders_id: TJSONArray;
begin
  sg.Cols[0].Clear;
  sg.Cols[1].Clear;
  sg.Cols[2].Clear;
  sg.Cols[3].Clear;
  sg.Cols[4].Clear;
  info := ClientModule1.ServiceClient.OrdersMonitor;
  desc := info.Get('DESCRIPTION').JsonValue as TJSONArray;
  orders_id := info.Get('ID_ORDER').JsonValue as TJSONArray;
  lat := info.Get('LATITUDE').JsonValue as TJSONArray;
  lon := info.Get('LONGITUDE').JsonValue as TJSONArray;
  created_at := info.Get('CREATED_AT').JsonValue as TJSONArray;
  ship_before := info.Get('SHIP_BEFORE').JsonValue as TJSONArray;
  sg.FixedCols := 0;
  sg.RowCount := desc.Size + 1;
  sg.Rows[0].Add('Order #ID');
  sg.Rows[0].Add('Customer Name');
  sg.Rows[0].Add('GPS');
  sg.Rows[0].Add('Created At');
  sg.Rows[0].Add('Ship Before');

  for i := 0 to desc.Size - 1 do
  begin
    sg.Rows[i + 1].Add(orders_id.Get(i).Value);
    sg.Rows[i + 1].Add(desc.Get(i).Value);
    sg.Rows[i + 1].Add(Format('[%s/%s]', [lat.Get(i).Value, lon.Get(i).Value]));
    sg.Rows[i + 1].Add(created_at.Get(i).Value);
    sg.Rows[i + 1].Add(ship_before.Get(i).Value);
  end;
end;

procedure TForm3.FormCreate(Sender: TObject);
begin
  sg.ColCount := 5;
  sg.ColWidths[0] := 100;
  sg.ColWidths[1] := 300;
  sg.ColWidths[2] := 400;
  sg.ColWidths[3] := 100;
  sg.ColWidths[4] := 100;
end;

procedure TForm3.Timer1Timer(Sender: TObject);
begin
  actOrders.Execute;
end;

end.
