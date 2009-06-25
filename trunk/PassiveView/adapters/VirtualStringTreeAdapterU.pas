unit VirtualStringTreeAdapterU;

interface

uses
  view.common, VirtualTrees, model.common;

type
  PDataHolder = ^TDataHolder;
  TDataHolder = record
    Data: ISpeaker;
  end;

  TVirtualStringTreeAdapter = class(TInterfacedObject, IGridAdapter)
  private
    VST: TVirtualStringTree;
    procedure vstGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
  public
    constructor Create(AVST: TVirtualStringTree);
    procedure ClearHeader;
    procedure ClearRow;
    procedure AddHeader(ACaption: String);
    procedure AddObject(ASpeaker: ISpeaker);
  end;



implementation



{ TVirtualStringTreeAdapter }

procedure TVirtualStringTreeAdapter.vstGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
  Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
begin
  case Column of
    0: begin
      CellText := PDataHolder(VST.GetNodeData(Node))^.Data.FirstName;
    end;

    1: begin
      CellText := PDataHolder(VST.GetNodeData(Node))^.Data.LastName;
    end;

  end;
end;

procedure TVirtualStringTreeAdapter.AddHeader(ACaption: String);
var
  col: TVirtualTreeColumn;
begin
  col := VST.Header.Columns.Add;
  col.Text := ACaption;
end;

procedure TVirtualStringTreeAdapter.AddObject(ASpeaker: ISpeaker);
var
  node: PVirtualNode;
  DataHolder: PDataHolder;
begin
  node := VST.AddChild(nil, nil);
  DataHolder := VST.GetNodeData(node);
  DataHolder.Data := ASpeaker;
end;

procedure TVirtualStringTreeAdapter.ClearHeader;
begin
  VST.Header.Columns.Clear;
end;

procedure TVirtualStringTreeAdapter.ClearRow;
begin
  VST.RootNodeCount := 0;
end;

constructor TVirtualStringTreeAdapter.Create(AVST: TVirtualStringTree);
begin
  inherited Create;
  VST := AVST;
  VST.NodeDataSize := SizeOf(PDataHolder);
  VST.OnGetText := vstGetText;
  VST.TreeOptions.MiscOptions := [toReportMode];
end;

end.
