unit ListViewAdapterU;

interface

uses
  view.common, VirtualTrees, model.common, ComCtrls;

type
  TListViewAdapter = class(TInterfacedObject, IGridAdapter)
  private
    lv: TListView;
  public
    constructor Create(AVST: TListView);
    procedure ClearHeader;
    procedure ClearRow;
    procedure AddHeader(ACaption: String; AWidth: Cardinal = 100);
    procedure AddObject(ASpeaker: ISpeaker);
    procedure BeginUpdate;
    procedure EndUpdate;
    function SelectedSpeaker: ISpeaker;    
  end;

  TDataHolder = class
    Data: ISpeaker;
    constructor Create(ASpeaker: ISpeaker);
  end;


implementation



{ TListViewAdapter }

procedure TListViewAdapter.AddHeader(ACaption: String; AWidth: Cardinal = 100);
var
  col: TListColumn;
begin
  col := lv.Columns.Add;
  col.Caption := ACaption;
  col.Width := AWidth;
end;

procedure TListViewAdapter.AddObject(ASpeaker: ISpeaker);
var
  li: TListItem;
begin
  li := lv.Items.Add;
  li.Data := TDataHolder.Create(ASpeaker);
  li.Caption := ASpeaker.FirstName;
  li.SubItems.Add(ASpeaker.LastName);
end;

procedure TListViewAdapter.BeginUpdate;
begin
  lv.Items.BeginUpdate;
end;

procedure TListViewAdapter.ClearHeader;
begin
  lv.Columns.Clear;
end;

procedure TListViewAdapter.ClearRow;
var
  I: Integer;
begin
  for I := 0 to lv.Items.Count - 1 do
    TDataHolder(lv.Items[i].Data).Free;
  lv.Items.Clear;
end;

constructor TListViewAdapter.Create(AVST: TListView);
begin
  inherited Create;
  lv := AVST;
  lv.ViewStyle := vsReport;
end;

procedure TListViewAdapter.EndUpdate;
begin
  lv.Items.EndUpdate;
end;

function TListViewAdapter.SelectedSpeaker: ISpeaker;
begin
  if Assigned(lv.Selected) then  
    Result := TDataHolder(lv.Selected.Data).Data;
end;

{ TDataHolder }

constructor TDataHolder.Create(ASpeaker: ISpeaker);
begin
  inherited Create;
  Data := ASpeaker;
end;

end.
